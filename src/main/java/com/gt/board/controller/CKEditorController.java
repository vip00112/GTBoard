package com.gt.board.controller;

import java.util.ArrayList;
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
        List<AttachFile> uploadedFiles = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
        List<AttachFile> files = new ArrayList<AttachFile>();

        switch (type) {
        case "img":
            for (AttachFile file : uploadedFiles) {
                if (file.isUseable() && file.isImage()) {
                    files.add(file);
                }
            }
            break;
        case "file":
            for (AttachFile file : uploadedFiles) {
                if (file.isUseable() && !file.isImage()) {
                    files.add(file);
                }
            }
            break;
        default:
            return null;
        }
        return files;
    }

    // 브라우저에서 이미지 외부링크 등록 ajax 요청 json 반환
    @RequestMapping(value = "/editor/browser/img/link", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public AttachFile addImageLink(HttpSession session, @RequestParam String url) {
        return ckeditorService.saveImageLink(session, url);
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
        switch (type) {
        case "img":
        case "file":
            List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
            return fileUtil.deleteUploadedFile(files, url);
        default:
            return false;
        }
    }

}
