package com.gt.board.util;

import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;

public class CommonUtil {
    public CommonUtil() {
    }

    /** Client의 IP 취득
     *  @param request HttpServletRequest **/
    public String getIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    /** 게시글의 제목 또는 내용이 공백인지 확인
     *  @param text **/
    public boolean isEmptyText(String text) {
        if (text == null || text.isEmpty()) {
            return true;
        }
        text = text.replace("\r", "").replace("\n", "");
        text = text.replace("<p>", "").replace("</p>", "");
        text = text.replace("<br>", "").replace("<br />", "").replace("<br/>", "");
        text = text.replace("&nbsp;", "").replace(" ", "").replace("　", "");
        return text.isEmpty();
    }

    /** 오늘 일자 반환
     *  @return yyyy-MM-dd **/
    public String getToday() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(System.currentTimeMillis());
    }

    /** 어제 일자 반환
     *  @return yyyy-MM-dd **/
    public String getYesterday() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(System.currentTimeMillis() - (60 * 60 * 24 * 1000));
    }

}
