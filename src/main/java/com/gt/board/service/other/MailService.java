package com.gt.board.service.other;

public interface MailService {

    /** 이메일 템플릿
     *  @param title 본문 제목
     *  @param content 본문 내용
     *  @param linkText a 링크 표기 문자
     *  @param url a 링크 이동 url **/
    public String getTemplate(String title, String content, String linkText, String url);

    /** 메일 전송
     *  @param subject 제목
     *  @param text 내용
     *  @param from 보내는 메일 주소
     *  @param to 받는 메일 주소
     *  @param filePath 첨부 파일 경로: 첨부파일 없을시 null **/
    public boolean send(String subject, String text, String from, String to, String filePath);

}
