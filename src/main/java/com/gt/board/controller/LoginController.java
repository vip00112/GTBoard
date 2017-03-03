package com.gt.board.controller;

import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gt.board.config.SessionAttribute;
import com.gt.board.service.UserService;
import com.gt.board.service.other.MailService;
import com.gt.board.service.other.SettingService;
import com.gt.board.util.RSAUtil;
import com.gt.board.vo.AttachFile;
import com.gt.board.vo.User;
import com.gt.board.vo.other.MailCode;
import com.gt.board.vo.other.RSA;

@Controller
public class LoginController {
    private static final Logger logger = Logger.getLogger(LoginController.class);

    private UserService userService;
    private SettingService settingService;
    private MailService mailService;
    private RSAUtil rsaUtil;

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public void setSettingService(SettingService settingService) {
        this.settingService = settingService;
    }

    public void setMailService(MailService mailService) {
        this.mailService = mailService;
    }

    public void setRsaUtil(RSAUtil rsaUtil) {
        this.rsaUtil = rsaUtil;
    }

    // 로그인 페이지 진입
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String loginForm(HttpServletRequest req, Model model) {
        // 이미 로그인된 경우
        if (req.getSession().getAttribute("loginUser") != null) {
            return "redirect:/index";
        }

        String referer = (String) req.getSession().getAttribute(SessionAttribute.REFERER);
        String refererFromHeader = req.getHeader("referer");
        if (referer == null && refererFromHeader != null) {
            req.getSession().setAttribute(SessionAttribute.REFERER, refererFromHeader);
        }

        // RSA 키 생성
        PrivateKey key = (PrivateKey) req.getSession().getAttribute(SessionAttribute.RSA_KEY);
        if (key != null) { // 기존 key 파기
            req.getSession().removeAttribute(SessionAttribute.RSA_KEY);
        }
        RSA rsa = rsaUtil.createRSA();
        model.addAttribute("modulus", rsa.getModulus());
        model.addAttribute("exponent", rsa.getExponent());
        req.getSession().setAttribute(SessionAttribute.RSA_KEY, rsa.getPrivateKey());
        return "login";
    }

    // 로그인 처리
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(User user, HttpServletRequest req, RedirectAttributes ra) {
        HttpSession session = req.getSession();
        if (session.getAttribute(SessionAttribute.USER) != null) { // 이미 로그인된 경우
            return "redirect:/index";
        }

        // RSA 복호화 후 parameter 재설정
        try {
            PrivateKey key = (PrivateKey) session.getAttribute(SessionAttribute.RSA_KEY);
            if (key == null) {
                ra.addFlashAttribute(SessionAttribute.MSG, "비정상 적인 접근 입니다.");
                return "redirect:/login";
            }
            session.removeAttribute(SessionAttribute.RSA_KEY);

            String email = rsaUtil.getDecryptText(key, user.getEmail());
            String password = rsaUtil.getDecryptText(key, user.getPassword());
            user.setEmail(email);
            user.setPassword(password);
        } catch (Exception e) {
            ra.addFlashAttribute(SessionAttribute.MSG, "비정상 적인 접근 입니다.");
            return "redirect:/login";
        }

        User loginUser = userService.getUser(user.getEmail());
        if (loginUser != null) {
            // BCrypt hash 암호 체크
            String plainPassword = user.getPassword();
            String hashedPassword = loginUser.getPassword();
            try {
                if (BCrypt.checkpw(plainPassword, hashedPassword)) {
                    String referer = (String) session.getAttribute(SessionAttribute.REFERER);

                    // session 재할당
                    session.invalidate();
                    session = req.getSession(true);

                    session.setAttribute(SessionAttribute.TOKEN, UUID.randomUUID().toString());
                    session.setAttribute(SessionAttribute.USER, loginUser);
                    session.setAttribute(SessionAttribute.IMAGE_FILES, new ArrayList<AttachFile>());
                    session.setAttribute(SessionAttribute.ATTACH_FILES, new ArrayList<AttachFile>());

                    // 계정 활성화 여부
                    if (!loginUser.isActive()) {
                        return "redirect:/join/verify";
                    }

                    if (referer != null) {
                        session.removeAttribute("referer");
                        return "redirect:" + referer;
                    }
                    return "redirect:/index";
                }
            } catch (Exception e) {
                logger.warn("login", e);
            }
        }

        ra.addFlashAttribute(SessionAttribute.MSG, "아이디 또는 비밀번호가 올바르지 않습니다.");
        return "redirect:/login";
    }

    // 로그아웃 처리
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest req) {
        // 이미 로그아웃된 경우
        if (req.getSession().getAttribute("loginUser") == null) {
            return "redirect:/index";
        }

        // 세션 해제 : 로그아웃 처리
        req.getSession().invalidate();

        String referer = req.getHeader("referer");
        if (referer != null) {
            return "redirect:" + referer;
        }
        return "redirect:/index";
    }

    // 회원가입 페이지 진입 : 이용 약관
    @RequestMapping(value = "/join/agreement", method = RequestMethod.GET)
    public String joinFormAgreement(HttpSession session) {
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (loginUser != null) { // 이미 로그인된 경우
            if (!loginUser.isActive()) { // 활성화 안된 경우
                return "redirect:/join/verify";
            }
            return "redirect:/index";
        }

        session.removeAttribute("agreement");
        return "join-agreement";
    }

    // 회원가입 처리 : 이용 약관
    @RequestMapping(value = "/join/agreement", method = RequestMethod.POST)
    public String joinAgreement(HttpSession session, @RequestParam(defaultValue = "false") boolean isAgree) {
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (loginUser != null) { // 이미 로그인된 경우
            if (!loginUser.isActive()) { // 활성화 안된 경우
                return "redirect:/join/verify";
            }
            return "redirect:/index";
        } else if (!isAgree) { // 약관 동의 없이 submit된 경우
            return "redirect:/join/agreement";
        }

        session.setAttribute("agreement", "Y");
        return "redirect:/join/profile";
    }

    // 회원가입 페이지 진입 : 정보 입력
    @RequestMapping(value = "/join/profile", method = RequestMethod.GET)
    public String joinFormProfile(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (loginUser != null) { // 이미 로그인된 경우
            if (!loginUser.isActive()) { // 활성화 안된 경우
                return "redirect:/join/verify";
            }
            return "redirect:/index";
        } else if (session.getAttribute("agreement") == null) { // 약관 동의 없이 진입한 경우
            return "redirect:/join/agreement";
        }

        // RSA 키 생성
        PrivateKey key = (PrivateKey) session.getAttribute(SessionAttribute.RSA_KEY);
        if (key != null) { // 기존 key 파기
            session.removeAttribute(SessionAttribute.RSA_KEY);
        }
        RSA rsa = rsaUtil.createRSA();
        model.addAttribute("modulus", rsa.getModulus());
        model.addAttribute("exponent", rsa.getExponent());
        session.setAttribute(SessionAttribute.RSA_KEY, rsa.getPrivateKey());

        session.removeAttribute("agreement");
        return "join-profile";
    }

    // 회원가입 처리 : 정보 입력
    @RequestMapping(value = "/join/profile", method = RequestMethod.POST)
    public String joinProfile(HttpSession session, User user, RedirectAttributes ra) {
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (loginUser != null) { // 이미 로그인된 경우
            if (!loginUser.isActive()) { // 활성화 안된 경우
                return "redirect:/join/verify";
            }
            return "redirect:/index";
        }

        // RSA 복호화 후 parameter 재설정
        try {
            PrivateKey key = (PrivateKey) session.getAttribute(SessionAttribute.RSA_KEY);
            if (key == null) {
                ra.addFlashAttribute(SessionAttribute.MSG, "비정상 적인 접근 입니다.");
                session.setAttribute("agreement", "Y");
                return "redirect:/join/profile";
            }
            session.removeAttribute(SessionAttribute.RSA_KEY);

            String email = rsaUtil.getDecryptText(key, user.getEmail());
            String nickname = rsaUtil.getDecryptText(key, user.getNickname());
            String password = rsaUtil.getDecryptText(key, user.getPassword());
            String captcha = rsaUtil.getDecryptText(key, user.getCaptcha());
            user.setEmail(email);
            user.setNickname(nickname);
            user.setPassword(password);
            user.setCaptcha(captcha);
        } catch (Exception e) {
            ra.addFlashAttribute(SessionAttribute.MSG, "비정상 적인 접근 입니다.");
            session.setAttribute("agreement", "Y");
            return "redirect:/join/profile";
        }

        // 자동 방지 코드 확인
        String captcha = (String) session.getAttribute(SessionAttribute.CAPTCHA);
        if (captcha == null || !captcha.equals(user.getCaptcha())) {
            ra.addFlashAttribute(SessionAttribute.MSG, "자동 방지 코드가 일치하지 않습니다.");
            session.setAttribute("agreement", "Y");
            return "redirect:/join/profile";
        }

        // DB 입력 및 로그인 처리
        if (userService.join(user)) {
            session.setAttribute(SessionAttribute.USER, userService.getUser(user.getEmail()));
            return "redirect:/join/verify";
        } else {
            ra.addFlashAttribute(SessionAttribute.MSG, "회원가입에 실패 하였습니다.");
            return "redirect:/join/agreement";
        }
    }

    // 회원가입 페이지 진입 : 이메일 인증
    @RequestMapping(value = "/join/verify", method = RequestMethod.GET)
    public String joinFormVerify(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (loginUser.isActive()) { // 이미 활성화 된 경우
            return "redirect:/join/complete";
        }

        return "join-verify";
    }

    // 회원가입 처리 : 이메일 인증
    @RequestMapping(value = "/join/verify", method = RequestMethod.POST)
    public String joinVerify(HttpServletRequest req, User user, RedirectAttributes ra) {
        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (loginUser.isActive()) { // 이미 활성화 된 경우
            return "redirect:/index";
        }

        // 자동 방지 코드 확인
        String captcha = (String) session.getAttribute(SessionAttribute.CAPTCHA);
        if (captcha == null || !captcha.equals(user.getCaptcha())) {
            ra.addFlashAttribute(SessionAttribute.MSG, "자동 방지 코드가 일치하지 않습니다.");
            return "redirect:/join/verify";
        }

        // 메일 발송
        int ran = new Random().nextInt(90000) + 10000; // 10000 ~ 99999
        String code = String.valueOf(ran);
        session.setAttribute(SessionAttribute.EMAIL_CODE_JOIN, new MailCode(code, 60 * 5));

        String subject = "'" + settingService.getBaseSetting().getTitle() + "' 회원가입 인증 코드 발급 안내 입니다.";
        String url = "http://" + req.getServerName() + "/join/complete";
        String text = mailService.getTemplate(subject, "귀하의 인증 코드는 '<b style='font-weight:bold;'>" + code + "</b>' 입니다.", "인증 페이지로 이동(Click)", url);
        String from = settingService.getBaseSetting().getReply();
        String email = loginUser.getEmail();
        mailService.send(subject, text, from, email, null);

        return "redirect:/join/complete";
    }

    // 회원가입 페이지 진입 : 완료
    @RequestMapping(value = "/join/complete", method = RequestMethod.GET)
    public String joinFormComplete(HttpSession session, Model model, RedirectAttributes ra) {
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (!loginUser.isActive()) { // 활성화 안된 경우

            // 이메일 인증 유효기간 확인
            MailCode mailCode = (MailCode) session.getAttribute(SessionAttribute.EMAIL_CODE_JOIN);
            if (mailCode == null || mailCode.isTimeout()) {
                ra.addFlashAttribute(SessionAttribute.MSG, "이메일 인증 코드 유효기간이 만료 되었습니다.<br/>다시 발급 받아 주세요.");
                return "redirect:/join/verify";
            }

            // RSA 키 생성
            PrivateKey key = (PrivateKey) session.getAttribute(SessionAttribute.RSA_KEY);
            if (key != null) { // 기존 key 파기
                session.removeAttribute(SessionAttribute.RSA_KEY);
            }
            RSA rsa = rsaUtil.createRSA();
            model.addAttribute("modulus", rsa.getModulus());
            model.addAttribute("exponent", rsa.getExponent());
            session.setAttribute(SessionAttribute.RSA_KEY, rsa.getPrivateKey());
        }

        return "join-complete";
    }

    // 회원가입 처리 : 완료
    @RequestMapping(value = "/join/complete", method = RequestMethod.PUT)
    public String joinComplete(HttpSession session, User user, RedirectAttributes ra) {
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (loginUser.isActive()) { // 이미 활성화 된 경우
            ra.addFlashAttribute(SessionAttribute.MSG, "계정이 활성화 되었습니다.");
            return "redirect:/join/complete";
        }

        // RSA 복호화 후 parameter 재설정
        try {
            PrivateKey key = (PrivateKey) session.getAttribute(SessionAttribute.RSA_KEY);
            if (key == null) {
                ra.addFlashAttribute(SessionAttribute.MSG, "비정상 적인 접근 입니다.");
                return "redirect:/join/complete";
            }
            session.removeAttribute(SessionAttribute.RSA_KEY);

            String joinCode = rsaUtil.getDecryptText(key, user.getJoinCode());
            String captcha = rsaUtil.getDecryptText(key, user.getCaptcha());
            user.setJoinCode(joinCode);
            user.setCaptcha(captcha);
        } catch (Exception e) {
            ra.addFlashAttribute(SessionAttribute.MSG, "비정상 적인 접근 입니다.");
            return "redirect:/join/complete";
        }

        // 이메일 인증 확인
        MailCode mailCode = (MailCode) session.getAttribute(SessionAttribute.EMAIL_CODE_JOIN);
        if (mailCode == null || mailCode.isTimeout()) {
            ra.addFlashAttribute(SessionAttribute.MSG, "이메일 인증 코드 유효기간이 만료 되었습니다.<br/>다시 발급 받아 주세요.");
            return "redirect:/join/verify";
        } else if (!mailCode.getCode().equals(user.getJoinCode())) {
            ra.addFlashAttribute(SessionAttribute.MSG, "이메일 인증 코드가 일치하지 않습니다.");
            return "redirect:/join/complete";
        }

        // 자동 방지 코드 확인
        String captcha = (String) session.getAttribute(SessionAttribute.CAPTCHA);
        if (captcha == null || !captcha.equals(user.getCaptcha())) {
            ra.addFlashAttribute(SessionAttribute.MSG, "자동 방지 코드가 일치하지 않습니다.");
            return "redirect:/join/complete";
        }

        loginUser.setActive(true);
        userService.setActive(loginUser.getNo());

        ra.addFlashAttribute(SessionAttribute.MSG, "계정이 활성화 되었습니다.");
        return "redirect:/join/complete";
    }

    // email,nickname 중복 검사
    @RequestMapping(value = "/join/check/{type}", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public boolean isOverlap(@PathVariable String type, HttpSession session, @RequestParam String value) {
        if (!type.equals("email") && !type.equals("nickname")) {
            return true;
        }

        // RSA 복호화 후 parameter 재설정
        try {
            PrivateKey key = (PrivateKey) session.getAttribute(SessionAttribute.RSA_KEY);
            if (key == null) {
                return true;
            }
            value = rsaUtil.getDecryptText(key, value);
        } catch (Exception e) {
            return true;
        }
        return userService.isOverlap(0, type, value);
    }

    // 비밀번호 찾기 페이지 진입 : 이메일 인증
    @RequestMapping(value = "/find/password/verify", method = RequestMethod.GET)
    public String findPasswordFormVerify(HttpSession session) {
        // 이미 로그인된 경우
        if (session.getAttribute(SessionAttribute.USER) != null) {
            return "redirect:/index";
        }

        return "findPassword-verify";
    }

    // 비밀번호 찾기 처리 : 이메일 인증
    @RequestMapping(value = "/find/password/verify", method = RequestMethod.POST)
    public String findPasswordVerify(HttpServletRequest req, User user, RedirectAttributes ra) {
        HttpSession session = req.getSession();
        if (session.getAttribute(SessionAttribute.USER) != null) { // 이미 로그인된 경우
            return "redirect:/index";
        }

        // 자동 방지 코드 확인
        String captcha = (String) session.getAttribute(SessionAttribute.CAPTCHA);
        if (captcha == null || !captcha.equals(user.getCaptcha())) {
            ra.addFlashAttribute(SessionAttribute.MSG, "자동 방지 코드가 일치하지 않습니다.");
            return "redirect:/find/password/verify";
        }

        // 유효한 이메일 확인
        if (userService.getUser(user.getEmail()) != null) {
            long now = System.currentTimeMillis();
            int ran = new Random().nextInt(90000) + 10000; // 10000 ~ 99999
            String code = String.valueOf(now + ran);
            session.setAttribute(SessionAttribute.EMAIL_CODE_FIND, new MailCode(user.getEmail(), code, 60 * 5));

            String subject = "'" + settingService.getBaseSetting().getTitle() + "' 비밀번호 찾기 안내 입니다.";
            String url = "http://" + req.getServerName() + "/find/password/" + code;
            String text = mailService.getTemplate(subject, "아래 URL을 클릭하여 비밀번호 변경 페이지로 이동 하세요.", "비밀번호 변경 페이지로 이동(Click)", url);
            String from = settingService.getBaseSetting().getReply();
            String email = user.getEmail();
            mailService.send(subject, text, from, email, null);
        }

        ra.addFlashAttribute(SessionAttribute.MSG, "귀하의 이메일에 포함된 URL로 이동 해주세요.");
        return "redirect:/find/password/verify";
    }

    // 비밀번호 찾기 페이지 진입 : 비밀번호 변경
    @RequestMapping(value = "/find/password/{code:[0-9]+}", method = RequestMethod.GET)
    public String findPasswordFormComplete(HttpSession session, @PathVariable long code, Model model, RedirectAttributes ra) {
        // 이미 로그인된 경우
        if (session.getAttribute(SessionAttribute.USER) != null) {
            return "redirect:/index";
        }

        // 이메일 인증 유효기간 확인
        MailCode mailCode = (MailCode) session.getAttribute(SessionAttribute.EMAIL_CODE_FIND);
        if (mailCode == null || mailCode.isTimeout()) {
            ra.addFlashAttribute(SessionAttribute.MSG, "이메일 인증 코드 유효기간이 만료 되었습니다.<br/>다시 발급 받아 주세요.");
            return "redirect:/find/password/verify";
        }

        // 유효한 인증 번호 확인
        String codeStr = String.valueOf(code);
        if (!codeStr.equals(mailCode.getCode())) {
            return "redirect:/find/password/verify";
        }
        model.addAttribute("code", codeStr);

        // RSA 키 생성
        PrivateKey key = (PrivateKey) session.getAttribute(SessionAttribute.RSA_KEY);
        if (key != null) { // 기존 key 파기
            session.removeAttribute(SessionAttribute.RSA_KEY);
        }
        RSA rsa = rsaUtil.createRSA();
        model.addAttribute("modulus", rsa.getModulus());
        model.addAttribute("exponent", rsa.getExponent());
        session.setAttribute(SessionAttribute.RSA_KEY, rsa.getPrivateKey());

        return "findPassword-complete";
    }

    // 비밀번호 찾기 처리 : 비밀번호 변경
    @RequestMapping(value = "/find/password/{code:[0-9]+}", method = RequestMethod.PUT)
    public String findPasswordComplete(HttpSession session, @PathVariable long code, User user, RedirectAttributes ra) {
        // 이미 로그인된 경우
        if (session.getAttribute(SessionAttribute.USER) != null) {
            return "redirect:/index";
        }

        // 유효한 인증 번호 확인
        MailCode mailCode = (MailCode) session.getAttribute(SessionAttribute.EMAIL_CODE_FIND);
        String codeStr = String.valueOf(code);
        if (mailCode == null || !codeStr.equals(mailCode.getCode())) {
            return "redirect:/find/password/verify";
        }
        session.removeAttribute(SessionAttribute.EMAIL_CODE_FIND);

        // RSA 복호화 후 parameter 재설정
        try {
            PrivateKey key = (PrivateKey) session.getAttribute(SessionAttribute.RSA_KEY);
            if (key == null) {
                ra.addFlashAttribute(SessionAttribute.MSG, "비정상 적인 접근 입니다.");
                return "redirect:/find/password/" + code;
            }
            session.removeAttribute(SessionAttribute.RSA_KEY);

            String password = rsaUtil.getDecryptText(key, user.getPassword());
            String captcha = rsaUtil.getDecryptText(key, user.getCaptcha());
            user.setPassword(password);
            user.setCaptcha(captcha);
        } catch (Exception e) {
            ra.addFlashAttribute(SessionAttribute.MSG, "비정상 적인 접근 입니다.");
            return "redirect:/find/password/" + code;
        }

        // 자동 방지 코드 확인
        String captcha = (String) session.getAttribute(SessionAttribute.CAPTCHA);
        if (captcha == null || !captcha.equals(user.getCaptcha())) {
            ra.addFlashAttribute(SessionAttribute.MSG, "자동 방지 코드가 일치하지 않습니다.");
            return "redirect:/find/password/" + code;
        }

        // 비밀번호 변경
        userService.updatePassword(mailCode.getEmail(), user.getPassword());

        ra.addFlashAttribute(SessionAttribute.MSG, "비밀번호 변경이 완료 되었습니다.");
        return "redirect:/login";
    }

}
