package com.gt.board.vo;

import java.sql.Timestamp;
import java.text.DecimalFormat;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.gt.board.enums.AttachFileStatus;
import com.gt.board.enums.Path;
import com.gt.board.service.other.CKEditorService;

public class AttachFile {
    @JsonIgnore private int no;
    @JsonIgnore private int boardNo; // 첨부된 게시글 번호
    private String name; // 원본 파일명
    private long size; // 파일 크기
    private String extension; // 확장자
    private String newName; // 새로운 파일명
    @JsonIgnore private String fullPath; // 파일 전체 경로
    @JsonIgnore private Timestamp regdate;

    private boolean uploaded; // 업로드 성공 여부 (view 페이지 전달)
    private String url; // 링크 주소
    private String message; // 업로드 메시지
    @JsonIgnore private AttachFileStatus status;

    public AttachFile() {
        status = AttachFileStatus.NONE;
    }

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public int getBoardNo() {
        return boardNo;
    }

    public void setBoardNo(int boardNo) {
        this.boardNo = boardNo;
    }

    public boolean isUploaded() {
        return uploaded;
    }

    public void setUploaded(boolean uploaded) {
        this.uploaded = uploaded;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getSize() {
        return size;
    }

    public void setSize(long size) {
        this.size = size;
    }

    public String getExtension() {
        return extension;
    }

    public void setExtension(String extension) {
        this.extension = extension.toLowerCase();
    }

    public String getNewName() {
        return newName;
    }

    public void setNewName(String newName) {
        this.newName = newName;
    }

    public String getFullPath() {
        return fullPath;
    }

    public void setFullPath(String fullPath) {
        this.fullPath = fullPath;
    }

    public Timestamp getRegdate() {
        return regdate;
    }

    public void setRegdate(Timestamp regdate) {
        this.regdate = regdate;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public AttachFileStatus getStatus() {
        return status;
    }

    public void setStatus(AttachFileStatus status) {
        this.status = status;
    }

    /** 파일 크기 문자열 반환 **/
    public String getViewSize() {
        DecimalFormat df = new DecimalFormat("0.00");
        float kb = 1024F;
        float mb = kb * kb;

        if (size < kb) {
            return size + " Byte";
        } else if (size < mb) {
            return df.format(size / kb) + " KB";
        } else {
            return df.format(size / mb) + " MB";
        }
    }

    /** 삭제 상태가 아닌 사용 가능한 상태인지 확인 **/
    @JsonIgnore
    public boolean isUseable() {
        switch (status) {
        case NONE:
        case NORMAL:
        case UPLOADED:
            return true;
        default:
            return false;
        }
    }

    /** 이미지 유형 여부 **/
    @JsonIgnore
    public boolean isImage() {
        if (extension != null) {
            for (String extension : CKEditorService.EXTENDS_IMAGE) {
                if (extension.equals(this.extension)) {
                    return true;
                }
            }
        }
        return false;
    }

    /** 이미지 파일 여부 **/
    @JsonIgnore
    public boolean isImageFile() {
        if (fullPath == null) return false;
        return isImage() && fullPath.contains(Path.IMAGE.getPath());
    }

    /** 이미지 링크 여부 **/
    @JsonIgnore
    public boolean isImageLink() {
        if (fullPath == null) return false;
        return isImage() && (fullPath.startsWith("http://") || fullPath.startsWith("https://"));
    }

}
