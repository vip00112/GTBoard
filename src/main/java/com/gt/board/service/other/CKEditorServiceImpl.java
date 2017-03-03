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
        // TODO 최대 파일 갯수 제한
        // TODO 파일 확장자 whitelist xml 설정으로 읽을것
        // TODO windows 서버일 경우 파일명에; 가 들어가면 안됨
        List<AttachFile> result = new ArrayList<AttachFile>();
        MultipartFile[] uploadFiles = data.getUpload();

        for (MultipartFile uploadFile : uploadFiles) {
            AttachFile attach = new AttachFile();
            try {
                if (uploadFile == null || uploadFile.getOriginalFilename() == null || uploadFile.getOriginalFilename().isEmpty()) {
                    attach.setName("Unknown");
                    attach.setMessage("올바른 파일이 아닙니다.");
                } else if (uploadFile.getSize() > CKEditorService.MAX_SIZE_ATTACH) {
                    int max = (int) (CKEditorService.MAX_SIZE_ATTACH / 1024 / 1024);
                    attach.setName(uploadFile.getOriginalFilename());
                    attach.setSize(uploadFile.getSize());
                    attach.setMessage("첨부파일은 최대 " + max + "MB만 가능 합니다.");
                } else if (isUploadedSameFile(session, SessionAttribute.ATTACH_FILES, uploadFile.getOriginalFilename(), uploadFile.getSize())) {
                    attach.setName(uploadFile.getOriginalFilename());
                    attach.setSize(uploadFile.getSize());
                    attach.setMessage("이미 동일한 파일이 등록되어 있습니다.");
                } else {
                    String realPath = session.getServletContext().getRealPath(Path.ATTACH.getPath()); // 기본 경로
                    String path = realPath + File.separator + "upload" + File.separator; // 상세 경로
                    String fileName = uploadFile.getOriginalFilename(); // 원본 파일명
                    long fileSize = uploadFile.getSize();
                    String ext = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase(); // 확장자
                    if (!isValidExtend(ext, CKEditorService.EXTENDS_IMAGE)) {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
                        String today = sdf.format(System.currentTimeMillis());
                        String newName = today + "_" + UUID.randomUUID().toString() + "." + ext; // 랜덤 파일명

                        // 파일명 변경 및 이동
                        File moveFile = new File(path + newName);
                        moveFile = fileRenameUtil.rename(moveFile);
                        uploadFile.transferTo(moveFile);

                        attach.setUploaded(true);
                        attach.setName(fileName);
                        attach.setSize(fileSize);
                        attach.setExtension(ext);
                        attach.setMessage("업로드에 성공 하였습니다.");
                        attach.setUrl("/board/{boardNo}/download/" + newName);
                        attach.setNewName(newName);
                        attach.setFullPath(path + newName);

                        // 첨부파일 업로드 임시 파일 경로
                        List<AttachFile> uploadedFiles = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
                        uploadedFiles.add(attach); // session에 임시경로 기록
                    } else {
                        attach.setName(uploadFile.getOriginalFilename());
                        attach.setSize(uploadFile.getSize());
                        attach.setMessage("bmp, jpg, jpeg, png, gif 파일은 이미지 첨부를 이용 해주세요.");
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
                    image.setMessage("올바른 이미지 파일이 아닙니다.");
                } else if (uploadFile.getSize() > CKEditorService.MAX_SIZE_IMAGE) {
                    int max = (int) (CKEditorService.MAX_SIZE_IMAGE / 1024 / 1024);
                    image.setName(uploadFile.getOriginalFilename());
                    image.setSize(uploadFile.getSize());
                    image.setMessage("이미지 파일은 최대 " + max + "MB만 가능 합니다.");
                } else if (isUploadedSameFile(session, SessionAttribute.IMAGE_FILES, uploadFile.getOriginalFilename(), uploadFile.getSize())) {
                    image.setName(uploadFile.getOriginalFilename());
                    image.setSize(uploadFile.getSize());
                    image.setMessage("이미 동일한 파일이 등록되어 있습니다.");
                } else {
                    String realPath = session.getServletContext().getRealPath(Path.IMAGE.getPath()); // 기본 경로
                    String path = realPath + File.separator + "upload" + File.separator; // 상세 경로
                    String fileName = uploadFile.getOriginalFilename(); // 원본 파일명
                    long fileSize = uploadFile.getSize();
                    String ext = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase(); // 확장자
                    if (isValidExtend(ext, CKEditorService.EXTENDS_IMAGE)) {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
                        String today = sdf.format(System.currentTimeMillis());
                        String newName = today + "_" + UUID.randomUUID().toString() + "." + ext; // 랜덤 파일명

                        // 파일명 변경 및 이동
                        File moveFile = new File(path + newName);
                        moveFile = fileRenameUtil.rename(moveFile);
                        uploadFile.transferTo(moveFile);

                        image.setUploaded(true);
                        image.setName(fileName);
                        image.setSize(fileSize);
                        image.setExtension(ext);
                        image.setMessage("업로드에 성공 하였습니다.");
                        image.setUrl("/resources/img/upload/" + newName);
                        image.setNewName(newName);
                        image.setFullPath(path + newName);

                        // 이미지 업로드 임시 파일 경로
                        List<AttachFile> uploadedFiles = (List<AttachFile>) session.getAttribute(SessionAttribute.IMAGE_FILES);
                        uploadedFiles.add(image); // session에 임시경로 기록
                    } else {
                        image.setName(uploadFile.getOriginalFilename());
                        image.setSize(uploadFile.getSize());
                        image.setMessage("bmp, jpg, jpeg, png, gif 파일만 가능 합니다.");
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
    private boolean isUploadedSameFile(HttpSession session, String attribute, String fileName, long fileSize) {
        @SuppressWarnings("unchecked")
        List<AttachFile> uploadedFiles = (List<AttachFile>) session.getAttribute(attribute);
        for (AttachFile file : uploadedFiles) {
            if (file.getName().equals(fileName) && file.getSize() == fileSize) {
                return true;
            }
        }
        return false;
    }
}
