package com.gt.board.vo;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.gt.board.vo.xml.BoardType;

public class Comment {
    private int no;
    private int boardNo;
    private int userNo;
    private String nickname;
    private String content;
    @JsonIgnore private String ip; // 댓글 작성 IP
    private Timestamp regdate;

    @JsonIgnore private String captcha; // 자동 방지 코드
    @JsonIgnore private SimpleDateFormat sdf; // viewDate 표기를 위한 변수 선언

    public Comment() {
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

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public Timestamp getRegdate() {
        return regdate;
    }

    public void setRegdate(Timestamp regdate) {
        this.regdate = regdate;
    }

    public String getCaptcha() {
        return captcha;
    }

    public void setCaptcha(String captcha) {
        this.captcha = captcha;
    }

    /** 댓글 수정/삭제 권한 여부 확인
     *  @param boardType 해당 댓글을 소유한 게시글의 게시판 정보
     *  @param user 댓글 수정/삭제를 시도한 유저 **/
    public boolean isEditable(BoardType boardType, User user) {
        if (user == null || boardType == null || !boardType.isWritableComment(user)) {
            return false;
        }
        return user.isAdmin() || user.getGrade() == boardType.getAdminGrade() || user.getNo() == userNo;
    }

    /** 등록일자 표기(년-월-일 시:분:초)
     *  @return yyyy-MM-dd HH:mm:ss **/
    public String getViewRegdateFull() {
        if (regdate == null) {
            return "-";
        }

        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(regdate.getTime());
    }
}