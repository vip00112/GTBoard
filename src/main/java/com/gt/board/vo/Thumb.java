package com.gt.board.vo;

import java.sql.Timestamp;

public class Thumb {
    private int no;
    private int boardNo;
    private int userNo;
    private Timestamp regdate;

    public Thumb() {
    }

    public Thumb(int boardNo, int userNo) {
        this.boardNo = boardNo;
        this.userNo = userNo;
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

    public int getUserNo() {
        return userNo;
    }

    public void setUserNo(int userNo) {
        this.userNo = userNo;
    }

    public Timestamp getRegdate() {
        return regdate;
    }

    public void setRegdate(Timestamp regdate) {
        this.regdate = regdate;
    }
}
