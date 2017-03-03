package com.gt.board.service.other;

import java.io.File;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class MailServiceImpl implements MailService {
    private static final Logger logger = Logger.getLogger(MailServiceImpl.class);

    private JavaMailSender javaMailSender;

    public void setJavaMailSender(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    @Override
    public String getTemplate(String title, String content, String linkText, String url) {
        StringBuilder sb = new StringBuilder();
        sb.append("<div style='border:1px solid #aaa;border-top:20px solid #424242;border-bottom:20px solid #424242;border-radius:10px;padding:20px;max-width:500px;margin:auto;'>");
        sb.append("<h1 style='font-weight:bold;line-height:50px;font-size:15px;'>");
        sb.append(title);
        sb.append("</h1>");
        sb.append("<p style='line-height:20px;'>");
        sb.append(content);
        sb.append("</p>");
        if (linkText != null) {
            sb.append("<a href='" + url + "' style='line-height:20px;'>");
            sb.append(linkText);
            sb.append("</a>");
        }
        sb.append("</div>");
        return sb.toString();
    }

    @Override
    public boolean send(String subject, String text, String from, String to, String filePath) {
        MimeMessage message = javaMailSender.createMimeMessage();

        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setSubject(subject);
            helper.setText(text, true);
            helper.setFrom(from);
            helper.setTo(to);

            // 첨부 파일 처리
            if (filePath != null) {
                File file = new File(filePath);
                if (file.exists()) {
                    helper.addAttachment(file.getName(), new File(filePath));
                }
            }

            javaMailSender.send(message);
            return true;
        } catch (MessagingException e) {
            logger.warn("send", e);
        }
        return false;
    }
}
