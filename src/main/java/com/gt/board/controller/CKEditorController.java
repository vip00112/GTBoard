package com.gt.board.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gt.board.config.SessionAttribute;
import com.gt.board.service.other.CKEditorService;
import com.gt.board.util.FileUtil;
import com.gt.board.vo.AttachFile;
import com.gt.board.vo.other.CKEditorUploadData;

@Controller
public class CKEditorController {
    private CKEditorService ckeditorService;
    private FileUtil fileUtil;

    public void setCKEditorService(CKEditorService ckeditorService) {
        this.ckeditorService = ckeditorService;
    }

    public void setFileUtil(FileUtil fileUtil) {
        this.fileUtil = fileUtil;
    }

    // 브라우저 새창 열기
    @RequestMapping(value = "/editor/browser/{type:[a-z]+}", method = RequestMethod.GET)
    public String browser(@PathVariable String type, @RequestParam(defaultValue = "-1") int key) {
        if (!type.equals("img") && !type.equals("file")) {
            return "redirect:/error";
        } else if (key < 0) {
            return "redirect:/error";
        }
        return type + "Browser";
    }

    // 임시 업로드 된 목록 ajax 요청 json 반환
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/editor/browser/{type:[a-z]+}/list", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public List<AttachFile> fileList(@PathVariable String type, HttpSession session) {
        List<AttachFile> uploadedFiles = null;
        switch (type) {
        case "img":
            uploadedFiles = (List<AttachFile>) session.getAttribute(SessionAttribute.IMAGE_FILES);
            break;
        case "file":
            uploadedFiles = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
            break;
        default:
            return null;
        }
        return uploadedFiles;
    }

    // 브라우저에서 이미지 외부링크 등록 ajax 요청 json 반환
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/editor/browser/img/link", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public AttachFile addImageLink(HttpSession session, @RequestParam String url) {
        // TODO service layer로 이동
        AttachFile file = new AttachFile();
        file.setUrl(url);
        file.setFullPath(url);

        if (url.lastIndexOf(".") == -1 || (!url.startsWith("http://") && !url.startsWith("https://"))) {
            file.setUploaded(false);
            file.setName("외부 이미지");
            file.setMessage("잘못된 링크 주소 입니다.");
            return file;
        }
        String fileName = url.substring(url.lastIndexOf("/") + 1);
        file.setName(fileName);
        file.setNewName(fileName);

        // 유효한 이미지 파일 확장자 확인
        boolean isValid = false;
        String ext = url.substring(url.lastIndexOf(".") + 1).toLowerCase();
        String[] validExtends = CKEditorService.EXTENDS_IMAGE;
        for (String validExtend : validExtends) {
            if (validExtend.toLowerCase().equals(ext)) {
                isValid = true;
                break;
            }
        }
        if (!isValid) {
            file.setUploaded(false);
            file.setMessage("bmp, jpg, jpeg, png, gif 파일만 가능 합니다.");
            return file;
        }
        file.setExtension(ext);

        List<AttachFile> uploadedFiles = (List<AttachFile>) session.getAttribute(SessionAttribute.IMAGE_FILES);
        for (AttachFile uploadedFile : uploadedFiles) {
            if (uploadedFile.getUrl().equals(url)) {
                file.setUploaded(false);
                file.setMessage("이미 등록된 외부 링크 입니다.");
                return file;
            }
        }

        // session에 등록
        file.setUploaded(true);
        file.setMessage("외부 이미지를 참조 하였습니다.");
        uploadedFiles.add(file);
        return file;
    }

    // 브라우저에서 임시 업로드 ajax 요청 json 반환
    @RequestMapping(value = "/editor/browser/{type:[a-z]+}/upload", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public List<AttachFile> uploadFiles(@PathVariable String type, HttpSession session, CKEditorUploadData data) {
        switch (type) {
        case "img":
            return ckeditorService.saveImageFiles(session, data);
        case "file":
            return ckeditorService.saveAttachFiles(session, data);
        default:
            return null;
        }
    }

    // 임시 업로드된 파일 삭제 ajax 요청 json 반환
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/editor/browser/{type:[a-z]+}/delete", method = RequestMethod.DELETE, produces = "application/json")
    @ResponseBody
    public boolean deleteFile(@PathVariable String type, @RequestParam(defaultValue = "") String url, HttpSession session) {
        List<AttachFile> files = null;
        switch (type) {
        case "img":
            files = (List<AttachFile>) session.getAttribute(SessionAttribute.IMAGE_FILES);
            break;
        case "file":
            files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
            break;
        default:
            return false;
        }
        // TODO 글수정시 첨부파일 기존것 삭제 안됨
        return fileUtil.deleteUploadedFile(files, url);
    }

}
