package com.gt.board.vo.other;

public class MailCode {
    private String email; // 이메일 주소
    private String code; // 인증 코드
    private int startTime;
    private int endTime;

    /** 이메일 인증 코드 생성자
     *  @param code 인증 코드
     *  @param timeout 유효 시간(초) **/
    public MailCode(String code, int timeout) {
        this(null, code, timeout);
    }

    /** 이메일 인증 코드 생성자
     *  @param code 인증 코드
     *  @param timeout 유효 시간(초) **/
    public MailCode(String email, String code, int timeout) {
        this.email = email;
        this.code = code;
        startTime = (int) (System.currentTimeMillis() / 1000);
        endTime = startTime + timeout;
    }

    /** 이메일 주소 반환 **/
    public String getEmail() {
        return email;
    }

    /** 메일로 받은 인증 코드 반환 **/
    public String getCode() {
        return code;
    }

    /** 유효 시간이 만료 되었는지 확인 **/
    public boolean isTimeout() {
        int now = (int) (System.currentTimeMillis() / 1000);
        return now >= endTime;
    }
}
