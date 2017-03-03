package com.gt.board.vo.other;

import org.springframework.web.multipart.MultipartFile;

/** CKEditor 업로드시 formdata를 저장하는 VO **/
public class CKEditorUploadData {
    private MultipartFile[] upload;
    private int key;

    public CKEditorUploadData() {
    }

    public MultipartFile[] getUpload() {
        return upload;
    }

    public void setUpload(MultipartFile[] upload) {
        this.upload = upload;
    }

    public int getKey() {
        return key;
    }

    public void setKey(int key) {
        this.key = key;
    }

}
