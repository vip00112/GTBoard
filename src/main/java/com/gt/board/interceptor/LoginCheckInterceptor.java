package com.gt.board.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.gt.board.config.SessionAttribute;
import com.gt.board.vo.User;

/** 로그인이 필요한 페이지를 들어가기전 체크 **/
public class LoginCheckInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // POST 메서드의 경우 CSRFToken 비교
        RequestMethod method = RequestMethod.valueOf(request.getMethod());
        if (method == RequestMethod.POST || method == RequestMethod.PUT || method == RequestMethod.DELETE) {
            String token = (String) request.getSession().getAttribute(SessionAttribute.TOKEN);
            String param = (String) request.getParameter(SessionAttribute.TOKEN);
            if (token == null || param == null || !token.equals(param)) {
                response.sendRedirect("/error");
                return false;
            }
        }

        User loginUser = (User) request.getSession().getAttribute("loginUser");
        if (loginUser != null) {
            String url = request.getRequestURL().toString();

            // 계정 활성화 여부
            if (!loginUser.isActive()) {
                if (url.indexOf("/join/verify") == -1 && url.indexOf("/join/complete") == -1) {
                    response.sendRedirect("/join/complete");
                    return false;
                }
            }

            // 관리자 페이지
            if (url.indexOf("/admin") != -1 && !loginUser.isAdmin()) {
                response.sendRedirect("/error");
                return false;
            }
            return true;
        }
        response.sendRedirect("/login");
        return false;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        super.postHandle(request, response, handler, modelAndView);
    }

}
