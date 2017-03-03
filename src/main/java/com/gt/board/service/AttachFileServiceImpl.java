package com.gt.board.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.gt.board.dao.AttachFilesDAO;
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
        if (board == null || files == null || files.size() == 0) {
            return false;
        }

        int no = board.getNo();
        String content = board.getContent();
        String tempFolder = File.separator + "upload" + File.separator;
        String folderName = File.separator + "board" + File.separator + no + File.separator;

        // 임시폴더에서 실제 폴더로 파일 이동
        fileUtil.moveUploadedFiles(board.getContent(), tempFolder, folderName, files);

        // DB 입력
        for (AttachFile file : files) {
            // TODO 기존 파일일 경우는 실제 파일이 없다면 디비에서 삭제
            if (!file.isProtected()) { // 신규 파일만 입력
                file.setBoardNo(no);
                if (!file.isImageLink()) {
                    String newPath = file.getFullPath().replace(tempFolder, folderName);
                    file.setFullPath(newPath);
                }
                if (attachFilesDAO.insert(file) == 0) {
                    return false;
                }

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
        }
        files.clear();

        // 본문 내용 수정
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
            file.setUploaded(true);
            file.setProtected(true);
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
}
