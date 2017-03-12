package com.gt.board.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.view.RedirectView;

import com.gt.board.config.SessionAttribute;
import com.gt.board.enums.Path;
import com.gt.board.service.other.SettingService;
import com.gt.board.util.FileUtil;
import com.gt.board.vo.AttachFile;

/** 모든 페이지 접근시 Model Attribute 추가 **/
public class GlobalModelInterceptor extends HandlerInterceptorAdapter {
    private boolean loadedSettingXML; // 최초 모든 setting xml 파일 load 여부
    private SettingService settingService;
    private FileUtil fileUtil;

    public void setSettingService(SettingService settingService) {
        this.settingService = settingService;
    }

    public void setFileUtil(FileUtil fileUtil) {
        this.fileUtil = fileUtil;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 최초 session 접근시 모든 setting xml 파일 load
        if (!loadedSettingXML) {
            loadedSettingXML = true;
            HttpSession session = request.getSession();
            String path = session.getServletContext().getRealPath(Path.SETTING.getPath()); // 기본 경로
            settingService.readAllSettingXML(path);
        }

        // meta 태그 표기를 위한 현재 요청 url 저장(parameter를 제외한 대표 url)
        request.setAttribute("requestServerName", "http://" + request.getServerName());
        request.setAttribute("requestUrl", request.getRequestURL().toString());
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView mav) throws Exception {
        // CKEditor 업로드 브라우저
        boolean isCKEditor = request.getRequestURL().toString().contains("/editor/browser");

        if (!isCKEditor && mav != null && mav.hasView()) {
            boolean isHasView = mav.getView() != null;
            boolean isRedirectView = mav.getView() instanceof RedirectView;
            boolean isRedirectViewByName = (mav.getViewName() == null) ? true : mav.getViewName().startsWith("redirect:");
            if ((isHasView && !isRedirectView) || (!isHasView && !isRedirectViewByName)) {
                HttpSession session = request.getSession();

                // xml 설정
                session.setAttribute(SessionAttribute.SETTING_BASE, settingService.getBaseSetting());
                session.setAttribute(SessionAttribute.SETTING_BOARD, settingService.getBoardSetting());
                session.setAttribute(SessionAttribute.SETTING_MENU, settingService.getMenuSetting());

                // 이미지/첨부파일 업로드 임시 파일 삭제
                @SuppressWarnings("unchecked")
                List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
                fileUtil.deleteUploadedFiles(files);

                // 글 수정 페이지 진입시 기존 업로드 파일 전달
                Object obj = mav.getModel().get(SessionAttribute.ATTACH_FILES);
                if (obj != null) {
                    session.setAttribute(SessionAttribute.ATTACH_FILES, obj);
                    mav.getModel().remove(SessionAttribute.ATTACH_FILES);
                }

                // captcha 코드 초기화
                session.removeAttribute(SessionAttribute.CAPTCHA);
            }
        }
        super.postHandle(request, response, handler, mav);
    }

}
