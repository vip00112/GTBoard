package com.gt.board.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** 조회수 중복 증가 방지를 위한 Cookie 관리 Class **/
public class CookieUtil {
    public static final String BOARD_HIT = "boardNos"; // 게시글 조회수 증가
    private static final String SPLIT = ","; // 여러 값이 등록될때 나뉠 문자열

    public CookieUtil() {
    }

    /** 해당 이름의 쿠키 취득(없을시 해당 이름의 빈 값이 들어가는 새로운 쿠키 객체 생성)
     *  @param request Client 요청 객체
     *  @param cookieName 쿠키명 **/
    public Cookie getCookie(HttpServletRequest request, String cookieName) {
        Cookie[] cookies = request.getCookies(); // 쿠키 목록

        if (cookies != null && cookies.length > 0) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(cookieName)) {
                    return cookie;
                }
            }
        }
        return new Cookie(cookieName, "");
    }

    /** 해당 쿠키에 값이 있는지 확인
     *  @param cookie 쿠키
     *  @param value 확일할 값 **/
    public boolean isHasCookie(Cookie cookie, String value) {
        String[] oldValues = cookie.getValue().split(SPLIT);

        for (String oldValue : oldValues) {
            if (oldValue.equals(value)) {
                return true;
            }
        }
        return false;
    }

    /** 해당 쿠키에 값 추가
     *  @param response Client 응답 객체
     *  @param cookie 쿠키
     *  @param newValue 추가할 값 **/
    public void addValue(HttpServletResponse response, Cookie cookie, String newValue) {
        String oldValue = cookie.getValue();
        if (!oldValue.equals("")) {
            oldValue += SPLIT;
        }
        cookie.setValue(oldValue + newValue);
        response.addCookie(cookie);
    }

    /** 해당 쿠키 삭제(만료)
     *  @param response Client 응답 객체
     *  @param cookie 쿠키 **/
    public void removeCookie(HttpServletResponse response, Cookie cookie) {
        cookie.setValue(null);
        cookie.setMaxAge(0); // 만료
        response.addCookie(cookie);
    }

}
