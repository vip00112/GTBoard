package com.gt.board.enums;

public enum AttachFileStatus {
    NONE,

    /** 신규 업로드 파일 **/
    NORMAL,

    /** 기존 업로드된 파일 **/
    UPLOADED,

    /** 신규 업로드 파일 삭제 **/
    DELETE,

    /** 기존 업로드된 파일 삭제 **/
    UPLOADED_DELETE;
}
