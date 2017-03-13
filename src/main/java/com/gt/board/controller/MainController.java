package com.gt.board.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gt.board.config.SessionAttribute;
import com.gt.board.enums.Path;
import com.gt.board.service.BoardService;
import com.gt.board.service.NoticeService;
import com.gt.board.service.other.SettingService;
import com.gt.board.util.CookieUtil;
import com.gt.board.util.FileUtil;
import com.gt.board.vo.AttachFile;
import com.gt.board.vo.Notice;
import com.gt.board.vo.User;
import com.gt.board.vo.xml.BoardType;

@Controller
public class MainController {
    private BoardService boardService;
    private NoticeService noticeService;
    private SettingService settingService;
    private CookieUtil cookieUtil;
    private FileUtil fileUtil;

    public void setBoardService(BoardService boardService) {
        this.boardService = boardService;
    }

    public void setNoticeService(NoticeService noticeService) {
        this.noticeService = noticeService;
    }

    public void setSettingService(SettingService settingService) {
        this.settingService = settingService;
    }

    public void setCookieUtil(CookieUtil cookieUtil) {
        this.cookieUtil = cookieUtil;
    }

    public void setFileUtil(FileUtil fileUtil) {
        this.fileUtil = fileUtil;
    }

    // index 페이지 진입
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String index(Model model) {
        Map<String, Object> boardList = new HashMap<String, Object>();

        int indexViewCount = settingService.getBaseSetting().getIndexViewCount();
        int indexViewCountTotal = settingService.getBaseSetting().getIndexViewCountTotal();
        List<BoardType> boardTypeList = settingService.getBoardSetting().getBoardTypeList();
        List<BoardType> useableBoardTypeList = new ArrayList<BoardType>();
        List<Integer> typeNoList = new ArrayList<Integer>();

        for (BoardType boardType : boardTypeList) {
            if (boardType.isUse() && boardType.isViewMain()) {
                int typeNo = boardType.getNo();
                boardList.put(String.valueOf(typeNo), boardService.getRecentList(typeNo, indexViewCount));
                useableBoardTypeList.add(boardType);
                typeNoList.add(typeNo);
            }
        }
        boardList.put(String.valueOf(0), boardService.getRecentList(typeNoList, indexViewCountTotal)); // 전체 게시글

        model.addAttribute("noticeList", noticeService.getNoticeListRecent(indexViewCount));
        model.addAttribute("useableBoardTypeList", useableBoardTypeList);
        model.addAttribute("boardList", boardList);
        return "index";
    }

    // 공지사항 목록 페이지 진입
    @RequestMapping(value = "/notice", method = RequestMethod.GET)
    public String noticeList(Model model,
            @RequestParam(defaultValue = "title") String searchType,
            @RequestParam(defaultValue = "") String search,
            @RequestParam(defaultValue = "1") int pageNo,
            @RequestParam(defaultValue = "30") int numPage,
            @RequestParam(defaultValue = "regdate_DESC") String order) {

        // 유효한 정렬 방식 확인: 입력 값 그대로 쿼리로 들어가기 때문
        if (!order.equals("regdate_DESC") && !order.equals("hit_DESC")) {
            order = "regdate_DESC";
        }

        // 공지사항 리스트
        model.addAllAttributes(noticeService.getNoticeList(searchType, search, pageNo, numPage, order));
        return "noticeList";
    }

    // 공지사항 상세 페이지 진입
    @RequestMapping(value = "/notice/{no:[0-9]+}", method = RequestMethod.GET)
    public String noticeDetail(@PathVariable int no, Model model, HttpServletRequest req, HttpServletResponse res, RedirectAttributes ra,
            @RequestParam(defaultValue = "title") String searchType,
            @RequestParam(defaultValue = "") String search,
            @RequestParam(defaultValue = "1") int pageNo,
            @RequestParam(defaultValue = "30") int numPage,
            @RequestParam(defaultValue = "regdate_DESC") String order) {
        Notice notice = noticeService.getNotice(no);
        if (notice == null) {
            return "redirect:/error";
        }

        // 유효한 정렬 방식 확인: 입력 값 그대로 쿼리로 들어가기 때문
        if (!order.equals("regdate_DESC") && !order.equals("hit_DESC")) {
            order = "regdate_DESC";
        }

        // 조회수 증가
        String value = String.valueOf(no);
        Cookie cookie = cookieUtil.getCookie(req, CookieUtil.BOARD_HIT);
        if (!cookieUtil.isHasCookie(cookie, value)) {
            cookieUtil.addValue(res, cookie, value);
            noticeService.addHit(no); // DB 값 증가
            notice.setHit(notice.getHit() + 1);
        }

        // 공지사항 리스트
        model.addAllAttributes(noticeService.getNoticeList(searchType, search, pageNo, numPage, order));

        // 공지사항 상세 정보
        model.addAttribute("notice", notice);
        return "noticeDetail";
    }

    // 공지사항 작성 페이지 진입
    @RequestMapping(value = "/notice/write", method = RequestMethod.GET)
    public String noticeWriteForm(HttpSession session, Model model, RedirectAttributes ra) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        if (user == null) {
            return "redirect:/error";
        } else if (!user.isAdmin()) {
            ra.addFlashAttribute(SessionAttribute.MSG, "공지사항 작성 권한이 없습니다.");
            return "redirect:/notice";
        }
        model.addAttribute("type", "write");
        return "noticeWrite";
    }

    // 공지사항 작성
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/notice/write", method = RequestMethod.POST)
    public String noticeWrite(Notice notice, HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        if (user == null) {
            return "redirect:/error";
        } else if (!user.isAdmin()) {
            ra.addFlashAttribute(SessionAttribute.MSG, "공지사항 작성 권한이 없습니다.");
            return "redirect:/notice";
        }

        notice.setUserNo(user.getNo());
        notice.setNickname(user.getNickname());

        if (noticeService.writeNotice(notice)) {
            // 이미지 업로드 임시 파일 이동
            List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
            String tempFolder = File.separator + "upload" + File.separator;
            String folderName = File.separator + "notice" + File.separator + notice.getNo() + File.separator;
            fileUtil.moveUploadedFiles(notice.getContent(), tempFolder, folderName, files);
            files.clear();

            // local로 복사
            String realPath = session.getServletContext().getRealPath(""); // 기본 경로
            fileUtil.copyFolder(realPath + Path.IMAGE.getPath() + folderName, Path.IMAGE.getLocalPath(folderName));

            // 본문 내용 수정
            String content = notice.getContent().replace("/img/upload", "/img/notice/" + notice.getNo());
            if (!content.equals(notice.getContent())) {
                notice.setContent(content);
                noticeService.updateNotice(notice);
            }

            ra.addFlashAttribute(SessionAttribute.MSG, "공지사항 작성이 완료 되었습니다");
        } else {
            ra.addFlashAttribute(SessionAttribute.MSG, "공지사항 작성이 실패 하였습니다.");
        }
        return "redirect:/notice/" + notice.getNo();
    }

    // 공지사항 수정 페이지 진입
    @RequestMapping(value = "/notice/{no:[0-9]+}/update", method = RequestMethod.GET)
    public String noticeUpdateForm(@PathVariable int no, Model model, HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        Notice notice = noticeService.getNotice(no);
        if (user == null || notice == null) {
            return "redirect:/error";
        } else if (!user.isAdmin()) {
            ra.addFlashAttribute(SessionAttribute.MSG, "공지사항 수정 권한이 없습니다.");
            return "redirect:/notice/" + no;
        }
        model.addAttribute("type", "update");
        model.addAttribute("notice", notice);
        return "noticeWrite";
    }

    // 공지사항 수정
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/notice/{no:[0-9]+}/update", method = RequestMethod.PUT)
    public String noticeUpdate(@PathVariable int no, Notice update, HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        Notice notice = noticeService.getNotice(no);
        if (user == null || notice == null) {
            return "redirect:/error";
        } else if (!user.isAdmin()) {
            ra.addFlashAttribute(SessionAttribute.MSG, "공지사항 수정 권한이 없습니다.");
            return "redirect:/notice/" + no;
        }
        // 이미지 업로드 임시 파일 이동
        List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
        String tempFolder = File.separator + "upload" + File.separator;
        String folderName = File.separator + "notice" + File.separator + no + File.separator;
        fileUtil.moveUploadedFiles(update.getContent(), tempFolder, folderName, files);
        files.clear();

        // local로 복사
        String realPath = session.getServletContext().getRealPath(""); // 기본 경로
        fileUtil.copyFolder(realPath + Path.IMAGE.getPath() + folderName, Path.IMAGE.getLocalPath(folderName));

        // 본문 내용 수정
        String content = update.getContent().replace("/img/upload", "/img/notice/" + no);
        update.setContent(content);

        update.setNo(no);
        if (noticeService.updateNotice(update)) {
            ra.addFlashAttribute(SessionAttribute.MSG, "공지사항 수정이 완료 되었습니다");
        } else {
            ra.addFlashAttribute(SessionAttribute.MSG, "공지사항 수정이 실패 하였습니다.");
        }
        return "redirect:/notice/" + no;
    }

    // 공지사항 삭제
    @RequestMapping(value = "/notice/{no:[0-9]+}/delete", method = RequestMethod.DELETE)
    public String noticeDelete(@PathVariable int no, HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        if (user == null) {
            return "redirect:/error";
        } else if (!user.isAdmin()) {
            ra.addFlashAttribute(SessionAttribute.MSG, "공지사항 삭제 권한이 없습니다.");
            return "redirect:/notice/" + no;
        }

        if (noticeService.deleteNotice(no)) {
            // 해당 게시글의 이미지, 첨부파일 삭제
            String realPath = session.getServletContext().getRealPath(""); // 기본 경로
            String folderName = File.separator + "notice" + File.separator + no;
            fileUtil.deleteFolder(realPath + Path.IMAGE.getPath() + folderName);

            // local 파일 삭제
            fileUtil.deleteFolder(Path.IMAGE.getLocalPath(folderName));

            ra.addFlashAttribute(SessionAttribute.MSG, "공지사항 삭제가 완료 되었습니다");
        } else {
            ra.addFlashAttribute(SessionAttribute.MSG, "공지사항 삭제가 실패 하였습니다.");
        }
        return "redirect:/notice";
    }

}