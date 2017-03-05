package com.gt.board.service.other;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.gt.board.config.SessionAttribute;
import com.gt.board.enums.AttachFileStatus;
import com.gt.board.enums.Path;
import com.gt.board.util.FileRenameUtil;
import com.gt.board.vo.AttachFile;
import com.gt.board.vo.other.CKEditorUploadData;

@Service
public class CKEditorServiceImpl implements CKEditorService {
    private static final Logger logger = Logger.getLogger(CKEditorServiceImpl.class);

    private FileRenameUtil fileRenameUtil;

    public void setFileRenameUtil(FileRenameUtil fileRenameUtil) {
        this.fileRenameUtil = fileRenameUtil;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<AttachFile> saveAttachFiles(HttpSession session, CKEditorUploadData data) {
        List<AttachFile> result = new ArrayList<AttachFile>();
        MultipartFile[] uploadFiles = data.getUpload();

        for (MultipartFile uploadFile : uploadFiles) {
            AttachFile attach = new AttachFile();
            try {
                if (uploadFile == null || uploadFile.getOriginalFilename() == null || uploadFile.getOriginalFilename().isEmpty()) {
                    attach.setName("Unknown");
                    attach.setMessage("올바른 파일이 아닙니다.");
                } else {
                    String realPath = session.getServletContext().getRealPath(Path.ATTACH.getPath()); // 기본 경로
                    String path = realPath + File.separator + "upload" + File.separator; // 상세 경로
                    String fileName = uploadFile.getOriginalFilename(); // 원본 파일명
                    String ext = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase(); // 확장자
                    long fileSize = uploadFile.getSize();

                    attach.setName(fileName);
                    attach.setSize(fileSize);
                    attach.setExtension(ext);

                    if (fileSize > CKEditorService.MAX_SIZE_FILE) {
                        int max = (int) (CKEditorService.MAX_SIZE_FILE / 1024 / 1024);
                        attach.setMessage("첨부파일은 최대 " + max + "MB만 가능 합니다.");
                    } else if (isMaxFileCount(session)) {
                        attach.setMessage("첨부파일은 최대 " + CKEditorService.MAX_COUNT_FILE + "개만 가능 합니다.");
                    } else if (isValidExtend(ext, CKEditorService.EXTENDS_IMAGE)) {
                        attach.setMessage("bmp, jpg, jpeg, png, gif 파일은 이미지 첨부를 이용 해주세요.");
                    } else if (isUploadedSameFile(session, fileName, fileSize)) {
                        attach.setMessage("이미 동일한 파일이 등록되어 있습니다.");
                    } else {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
                        String today = sdf.format(System.currentTimeMillis());
                        String newName = today + "_" + UUID.randomUUID().toString() + "." + ext; // 랜덤 파일명

                        // 파일명 변경 및 이동
                        File moveFile = new File(path + newName);
                        moveFile = fileRenameUtil.rename(moveFile);
                        uploadFile.transferTo(moveFile);

                        attach.setStatus(AttachFileStatus.NORMAL);
                        attach.setUploaded(true);
                        attach.setMessage("업로드에 성공 하였습니다.");
                        attach.setUrl("/board/{boardNo}/download/" + newName);
                        attach.setNewName(newName);
                        attach.setFullPath(path + newName);

                        // 첨부파일 업로드 임시 파일 경로
                        List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
                        files.add(attach); // session에 임시경로 기록
                    }
                }
            } catch (Exception e) {
                logger.warn("saveAttachFiles", e);
                attach.setUploaded(false);
                attach.setMessage("업로드 중 에러가 발생 하였습니다.");
            }
            result.add(attach);
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<AttachFile> saveImageFiles(HttpSession session, CKEditorUploadData data) {
        List<AttachFile> result = new ArrayList<AttachFile>();
        MultipartFile[] uploadFiles = data.getUpload();

        for (MultipartFile uploadFile : uploadFiles) {
            AttachFile image = new AttachFile();
            try {
                if (uploadFile == null || uploadFile.getOriginalFilename() == null || uploadFile.getOriginalFilename().isEmpty()) {
                    image.setName("Unknown");
                    image.setMessage("올바른 파일이 아닙니다.");
                } else {
                    String realPath = session.getServletContext().getRealPath(Path.IMAGE.getPath()); // 기본 경로
                    String path = realPath + File.separator + "upload" + File.separator; // 상세 경로
                    String fileName = uploadFile.getOriginalFilename(); // 원본 파일명
                    String ext = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase(); // 확장자
                    long fileSize = uploadFile.getSize();

                    image.setName(fileName);
                    image.setSize(fileSize);
                    image.setExtension(ext);

                    if (fileSize > CKEditorService.MAX_SIZE_IMAGE) {
                        int max = (int) (CKEditorService.MAX_SIZE_IMAGE / 1024 / 1024);
                        image.setMessage("이미지 파일은 최대 " + max + "MB만 가능 합니다.");
                    } else if (isMaxImageCount(session)) {
                        image.setMessage("이미지 파일은 최대 " + CKEditorService.MAX_COUNT_IMAGE + "개만 가능 합니다.(외부링크 포함)");
                    } else if (!isValidExtend(ext, CKEditorService.EXTENDS_IMAGE)) {
                        image.setMessage("bmp, jpg, jpeg, png, gif 파일만 가능 합니다.");
                    } else if (isUploadedSameFile(session, fileName, fileSize)) {
                        image.setMessage("이미 동일한 파일이 등록되어 있습니다.");
                    } else {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
                        String today = sdf.format(System.currentTimeMillis());
                        String newName = today + "_" + UUID.randomUUID().toString() + "." + ext; // 랜덤 파일명

                        // 파일명 변경 및 이동
                        File moveFile = new File(path + newName);
                        moveFile = fileRenameUtil.rename(moveFile);
                        uploadFile.transferTo(moveFile);

                        image.setStatus(AttachFileStatus.NORMAL);
                        image.setUploaded(true);
                        image.setMessage("업로드에 성공 하였습니다.");
                        image.setUrl("/resources/img/upload/" + newName);
                        image.setNewName(newName);
                        image.setFullPath(path + newName);

                        // 이미지 업로드 임시 파일 경로
                        List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
                        files.add(image); // session에 임시경로 기록
                    }
                }
            } catch (Exception e) {
                logger.warn("saveImageFiles", e);
                image.setUploaded(false);
                image.setMessage("업로드 중 에러가 발생 하였습니다.");
            }
            result.add(image);
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    @Override
    public AttachFile saveImageLink(HttpSession session, String url) {
        AttachFile attach = new AttachFile();
        attach.setUrl(url);
        attach.setFullPath(url);

        // 유효한 url 확인
        if (url.lastIndexOf(".") == -1 || (!url.startsWith("http://") && !url.startsWith("https://"))) {
            attach.setName("외부 이미지");
            attach.setMessage("잘못된 링크 주소 입니다.");
            return attach;
        }

        String fileName = url.substring(url.lastIndexOf("/") + 1);
        String ext = url.substring(url.lastIndexOf(".") + 1).toLowerCase();
        attach.setName(fileName);
        attach.setNewName(fileName);
        attach.setExtension(ext);

        if (isMaxImageCount(session)) {
            attach.setMessage("이미지 파일은 최대 " + CKEditorService.MAX_COUNT_IMAGE + "개만 가능 합니다.(외부링크 포함)");
            return attach;
        }

        // 이미 등록된 외부 링크인지 확인
        List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
        for (AttachFile uploadedFile : files) {
            if (uploadedFile.getUrl().equals(url)) {
                attach.setMessage("이미 등록된 외부 링크 입니다.");
                return attach;
            }
        }

        // 유효한 이미지 파일 확장자 확인
        if (!isValidExtend(ext, CKEditorService.EXTENDS_IMAGE)) {
            attach.setMessage("bmp, jpg, jpeg, png, gif 파일만 가능 합니다.");
            return attach;
        }

        // session에 등록
        attach.setStatus(AttachFileStatus.NORMAL);
        attach.setUploaded(true);
        attach.setMessage("외부 이미지를 참조 하였습니다.");
        files.add(attach);

        return attach;
    }

    // 이미지 최대 갯수 제한
    private boolean isMaxImageCount(HttpSession session) {
        @SuppressWarnings("unchecked")
        List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
        int count = 0;
        for (AttachFile file : files) {
            if (file.isUseable() && file.isImage()) {
                count++;
            }
        }
        return count >= CKEditorService.MAX_COUNT_IMAGE;
    }

    // 파일 최대 갯수 제한
    private boolean isMaxFileCount(HttpSession session) {
        @SuppressWarnings("unchecked")
        List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
        int count = 0;
        for (AttachFile file : files) {
            if (file.isUseable() && !file.isImage()) {
                count++;
            }
        }
        return count >= CKEditorService.MAX_COUNT_FILE;
    }

    // 유효한 파일 확장자 확인
    private boolean isValidExtend(String extend, String[] validExtends) {
        for (String validExtend : validExtends) {
            if (validExtend.toLowerCase().equals(extend.toLowerCase())) {
                return true;
            }
        }
        return false;
    }

    // 동일한 파일이 업로드 되어 있는지 확인
    private boolean isUploadedSameFile(HttpSession session, String fileName, long fileSize) {
        @SuppressWarnings("unchecked")
        List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
        for (AttachFile file : files) {
            if (file.isUseable() && file.getName().equals(fileName) && file.getSize() == fileSize) {
                return true;
            }
        }
        return false;
    }

}
