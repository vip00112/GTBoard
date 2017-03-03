package com.gt.board.config;

public class SessionAttribute {
    public static final String SETTING_BASE = "baseSetting"; // 기본 설정
    public static final String SETTING_BOARD = "boardSetting"; // 게시판 설정

    public static final String USER = "loginUser"; // 로그인 된 유저
    public static final String IMAGE_FILES = "uploadedImageFiles"; // 이미지 첨부 목록
    public static final String ATTACH_FILES = "uploadedAttachFiles"; // 첨부파일 목록
    public static final String TOKEN = "CSRFToken"; // CSRF Token

    public static final String EMAIL_CODE_JOIN = "joinCode"; // 회원가입 이메일 인증 코드
    public static final String EMAIL_CODE_FIND = "findCode"; // 비밀번호 찾기 이메일 인증 코드
    public static final String CAPTCHA = "captcha"; // captcha 코드
    public static final String RSA_KEY = "RSAprivateKey"; // RSA 암호화 개인키

    public static final String REFERER = "referer"; // 이전 페이지 URL
    public static final String MSG = "resultMsg"; // redirect 메시지
}
