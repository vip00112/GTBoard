package com.gt.board.vo;

import java.sql.Timestamp;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import com.fasterxml.jackson.annotation.JsonIgnore;

public class User implements HttpSessionBindingListener {
    @Override
    public void valueBound(HttpSessionBindingEvent event) {
        // User 객체가 session에 put될때 발생 된다.
        HttpSession session = event.getSession();
        System.out.println("User VO bound session : " + session.getId());
    }

    @Override
    public void valueUnbound(HttpSessionBindingEvent event) {
        // User 객체가 session에서 remove될때 발생 된다.
        // 또한 session이 invalidate되어 sessionDestroyed될때도 발생 한다(우선순위)
        HttpSession session = event.getSession();
        System.out.println("User VO unbound session : " + session.getId());
    }

    @JsonIgnore private int no;
    private String email; // 아이디
    @JsonIgnore private String password; // Bcrypt로 암호화된 비밀번호
    private String nickname;
    private boolean isActive; // 계정 활성화 여부
    private int grade; // 9999:최고관리자
    private int point;
    private Timestamp regdate;

    private String joinCode; // 회원 가입: 이메일 인증 코드
    private String captcha; // 회원 가입: 자동 방지 코드

    public User() {
    }

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public int getGrade() {
        return grade;
    }

    public void setGrade(int grade) {
        this.grade = grade;
    }

    public int getPoint() {
        return point;
    }

    public void setPoint(int point) {
        this.point = point;
    }

    public Timestamp getRegdate() {
        return regdate;
    }

    public void setRegdate(Timestamp regdate) {
        this.regdate = regdate;
    }

    public String getJoinCode() {
        return joinCode;
    }

    public void setJoinCode(String joinCode) {
        this.joinCode = joinCode;
    }

    public String getCaptcha() {
        return captcha;
    }

    public void setCaptcha(String captcha) {
        this.captcha = captcha;
    }

    /** 최고 관리자 여부 **/
    public boolean isAdmin() {
        return grade == 9999;
    }

}
