package com.gt.board.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.gt.board.dao.AttachFilesDAO;
import com.gt.board.enums.AttachFileStatus;
import com.gt.board.util.FileUtil;
import com.gt.board.vo.AttachFile;
import com.gt.board.vo.Board;

@Service
public class AttachFileServiceImpl implements AttachFileService {
    private AttachFilesDAO attachFilesDAO;
    private FileUtil fileUtil;

    public void setAttachFilesDAO(AttachFilesDAO attachFilesDAO) {
        this.attachFilesDAO = attachFilesDAO;
    }

    public void setFileUtil(FileUtil fileUtil) {
        this.fileUtil = fileUtil;
    }

    @Override
    public boolean addFiles(Board board, List<AttachFile> files) {
        if (board == null || board.getBoardType() == null || files == null || files.size() == 0) {
            return false;
        }

        // 게시판 설정이 첨부파일 사용불가 일때 처리
        if (!board.getBoardType().isUseAttachFile()) {
            AttachFile[] fileArray = files.toArray(new AttachFile[files.size()]);
            for (AttachFile file : fileArray) {
                if (!file.isImage()) {
                    switch (file.getStatus()) {
                    case UPLOADED:
                    case UPLOADED_DELETE:
                        file.setStatus(AttachFileStatus.UPLOADED_DELETE);
                        break;
                    default:
                        file.setStatus(AttachFileStatus.DELETE);
                        break;
                    }
                }
            }
        }

        int no = board.getNo();
        String content = board.getContent();
        String tempFolder = File.separator + "upload" + File.separator;
        String folderName = File.separator + "board" + File.separator + no + File.separator;

        // 임시폴더에서 실제 폴더로 파일 이동
        fileUtil.moveUploadedFiles(board.getContent(), tempFolder, folderName, files);

        // DB 입력 및 삭제, 본문 내용 수정
        for (AttachFile file : files) {
            switch (file.getStatus()) {
            case NORMAL: // 신규 업로드 파일
                if (!file.isImageLink()) {
                    String newPath = file.getFullPath().replace(tempFolder, folderName);
                    file.setFullPath(newPath);
                }
                file.setBoardNo(no);

                // DB 입력
                if (attachFilesDAO.insert(file) == 1) {
                    if (!file.isImage()) { // 첨부파일 다운로드 URL 수정
                        String oldUrl = "/board/{boardNo}/download/" + file.getNewName();
                        String newUrl = "/board/" + no + "/download/" + file.getNo();
                        content = content.replace(oldUrl, newUrl);
                    } else if (file.isImageFile()) { // 이미지 파일 src 수정
                        String oldSrc = "/img/upload/" + file.getNewName();
                        String newSrc = "/img/board/" + no + "/" + file.getNewName();
                        content = content.replace(oldSrc, newSrc);
                    }
                }
                break;
            case DELETE: // 신규 업로드 파일 삭제
                if (!file.isImage()) { // 첨부파일 다운로드 URL 삭제
                    content = content.replaceAll("(?s)<a.*?" + file.getNewName() + ".*?>.*?<\\/a>", "");
                } else if (file.isImageFile()) { // 이미지 파일 src 삭제
                    content = content.replaceAll("(?s)<img.*?" + file.getNewName() + ".*?>", "");
                }
                break;
            case UPLOADED_DELETE: // 기존 업로드된 파일 삭제
                if (!file.isImage()) { // 첨부파일 다운로드 URL 삭제
                    String replace = "/board/" + no + "/download/" + file.getNo();
                    content = content.replaceAll("(?s)<a.*?" + replace + ".*?>.*?<\\/a>", "");
                } else if (file.isImageFile()) { // 이미지 파일 src 삭제
                    String replace = "/img/board/" + no + "/" + file.getNewName();
                    content = content.replaceAll("(?s)<img.*?" + replace + ".*?>", "");
                }
                Map<String, Object> paramMap = new HashMap<String, Object>();
                paramMap.put("boardNo", no);
                paramMap.put("newName", file.getNewName());
                attachFilesDAO.deleteByName(paramMap);
                break;
            default:
                break;
            }
        }
        files.clear();

        // 수정된 본문 내용 적용
        board.setContent(content);
        return true;
    }

    @Override
    public AttachFile getFile(int boardNo, int fileNo) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("boardNo", boardNo);
        paramMap.put("no", fileNo);
        return attachFilesDAO.selectOne(paramMap);
    }

    @Override
    public List<AttachFile> getFileList(int boardNo) {
        List<AttachFile> files = attachFilesDAO.selectList(boardNo);
        for (AttachFile file : files) {
            if (file.isImageLink()) {
                file.setUrl(file.getFullPath());
            } else if (file.isImageFile()) {
                file.setUrl("/resources/img/board/" + boardNo + "/" + file.getNewName());
            } else {
                file.setUrl("/board/" + boardNo + "/download/" + file.getNo());
            }
            file.setStatus(AttachFileStatus.UPLOADED);
            file.setUploaded(true);
        }
        return files;
    }

    @Override
    public List<AttachFile> getDownloadFileList(int boardNo) {
        List<AttachFile> files = attachFilesDAO.selectList(boardNo);
        AttachFile[] downloadFiles = files.toArray(new AttachFile[files.size()]);
        for (AttachFile file : downloadFiles) {
            if (file.isImage()) {
                files.remove(file);
            } else {
                file.setUrl("/board/" + boardNo + "/download/" + file.getNo());
            }
        }
        return files;
    }

    @Override
    public boolean removeFile(int boardNo, String newName) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("boardNo", boardNo);
        paramMap.put("newName", newName);
        return attachFilesDAO.deleteByName(paramMap) == 1;
    }

    @Override
    public boolean removeFileList(int boardNo) {
        return attachFilesDAO.deleteByBoard(boardNo) > 0;
    }

    @Override
    public boolean addDownloadLog(int userNo, int fileNo) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("userNo", userNo);
        paramMap.put("fileNo", fileNo);
        return attachFilesDAO.insertLog(paramMap) == 1;
    }

    @Override
    public boolean isDownloaded(int userNo, int fileNo) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("userNo", userNo);
        paramMap.put("fileNo", fileNo);
        return attachFilesDAO.selectCountLog(paramMap) > 0;
    }
}
