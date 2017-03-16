package com.gt.board.vo;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import com.fasterxml.jackson.annotation.JsonIgnore;

public class Agreement {
    public static final String TERMS = "terms"; // Terms Of Service 이용약관
    public static final String PRIVACY = "privacy"; // Privacy Policy 개인정보취급방침
    public static final String YOUTH = "youth"; // 청소년 보호 정책
    public static final String EMAIL = "email"; // 이메일 무단 수집 거부

    private int no;
    private String type;
    private String content;
    private Timestamp regdate;

    @JsonIgnore private SimpleDateFormat sdf; // viewDate 표기를 위한 변수 선언

    public Agreement() {
    }

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getRegdate() {
        return regdate;
    }

    public void setRegdate(Timestamp regdate) {
        this.regdate = regdate;
    }

    /** 등록일자 표기(년-월-일 시:분:초)
     *  @return yyyy-MM-dd HH:mm:ss **/
    public String getViewRegdate() {
        if (regdate == null) {
            return "-";
        }

        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(regdate.getTime());
    }
}
