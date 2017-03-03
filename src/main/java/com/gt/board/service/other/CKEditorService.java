package com.gt.board.service.other;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.gt.board.vo.AttachFile;
import com.gt.board.vo.other.CKEditorUploadData;

public interface CKEditorService {
    public static final long MAX_SIZE_IMAGE = 1024 * 1024 * 3; // 3MB
    public static final long MAX_SIZE_ATTACH = 1024 * 1024 * 10; // 10MB

    public static final String[] EXTENDS_IMAGE = { "bmp", "jpg", "jpeg", "gif", "png" };

    /** CKEditor 첨부파일 목록 저장 (브라우저)
     *  @param session HttpSession
     *  @param data CKEditor 업로드시 formdata를 저장하는 VO **/
    public List<AttachFile> saveAttachFiles(HttpSession session, CKEditorUploadData data);

    /** CKEditor 이미지 파일 목록 저장 (브라우저)
     *  @param session HttpSession
     *  @param data CKEditor 업로드시 formdata를 저장하는 VO **/
    public List<AttachFile> saveImageFiles(HttpSession session, CKEditorUploadData data);
}