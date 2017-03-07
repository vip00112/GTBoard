package com.gt.board.enums;

/** 유저 Point 증가/감소의 이유 열거 **/
public enum Point {
    WRITE_BOARD("신규 게시글 작성"),
    DELETE_BOARD("게시글 삭제"),

    ADD_THUMB("게시글 추천 받음"),
    REMOVE_THUMB("추천 받은 게시글 삭제"),

    WRITE_COMMENT("신규 댓글 작성"),
    DELETE_COMMENT("댓글 삭제"),

    DOWNLOAD_FILE("첨부파일 다운로드");

    private String reason;

    private Point() {
    }

    private Point(String reason) {
        this.reason = reason;
    }

    public String getReason() {
        return reason;
    }

    /** 포인트 증가/감소 타입 **/
    public char getType() {
        switch (this) {
        case WRITE_BOARD:
        case ADD_THUMB:
        case WRITE_COMMENT:
            return 'I';
        default:
            return 'D';
        }
    }
}
