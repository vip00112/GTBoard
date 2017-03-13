package com.gt.board.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gt.board.config.SessionAttribute;
import com.gt.board.enums.Path;
import com.gt.board.enums.Point;
import com.gt.board.service.AttachFileService;
import com.gt.board.service.BoardService;
import com.gt.board.service.CommentService;
import com.gt.board.service.ThumbService;
import com.gt.board.service.UserService;
import com.gt.board.service.other.SettingService;
import com.gt.board.util.CommonUtil;
import com.gt.board.util.CookieUtil;
import com.gt.board.util.FileUtil;
import com.gt.board.vo.AttachFile;
import com.gt.board.vo.Board;
import com.gt.board.vo.Comment;
import com.gt.board.vo.Thumb;
import com.gt.board.vo.User;
import com.gt.board.vo.xml.BoardSetting;
import com.gt.board.vo.xml.BoardType;
import com.gt.board.vo.xml.MenuType;
import com.gt.board.vo.xml.MenuTypeSub;

@Controller
public class BoardController {
    private static final Logger logger = Logger.getLogger(BoardController.class);

    private BoardService boardService;
    private CommentService commentService;
    private ThumbService thumbService;
    private SettingService settingService;
    private AttachFileService attachFileService;
    private UserService userService;
    private CommonUtil commonUtil;
    private CookieUtil cookieUtil;
    private FileUtil fileUtil;

    public void setBoardService(BoardService boardService) {
        this.boardService = boardService;
    }

    public void setCommentService(CommentService commentService) {
        this.commentService = commentService;
    }

    public void setThumbService(ThumbService thumbService) {
        this.thumbService = thumbService;
    }

    public void setSettingService(SettingService settingService) {
        this.settingService = settingService;
    }

    public void setAttachFileService(AttachFileService attachFileService) {
        this.attachFileService = attachFileService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public void setCommonUtil(CommonUtil commonUtil) {
        this.commonUtil = commonUtil;
    }

    public void setCookieUtil(CookieUtil cookieUtil) {
        this.cookieUtil = cookieUtil;
    }

    public void setFileUtil(FileUtil fileUtil) {
        this.fileUtil = fileUtil;
    }

    // 메뉴 별 게시판 전체보기 목록 페이지 진입
    @RequestMapping(value = "/board/all/{menuNo:[0-9]+}", method = RequestMethod.GET)
    public String boardList(@PathVariable int menuNo, Model model,
            @RequestParam(defaultValue = "title") String searchType,
            @RequestParam(defaultValue = "") String search,
            @RequestParam(defaultValue = "1") int pageNo,
            @RequestParam(defaultValue = "30") int numPage,
            @RequestParam(defaultValue = "regdate_DESC") String order,
            @RequestParam(defaultValue = "0") int popularThumb) {

        // 유효한 정렬 방식 확인: 입력 값 그대로 쿼리로 들어가기 때문
        if (!order.equals("regdate_DESC") && !order.equals("hit_DESC") && !order.equals("thumb_DESC") && !order.equals("commentCount_DESC")) {
            order = "regdate_DESC";
        }

        // 유효한 메뉴 확인
        MenuType menu = settingService.getMenuSetting().getMenuType(menuNo);
        if (menu == null || menu.getSubMenuList() == null || menu.getSubMenuList().size() == 0) {
            return "redirect:/error";
        }

        // 하위 메뉴중 게시판 typeNo 취득
        List<Integer> typeNoList = new ArrayList<Integer>();
        BoardSetting boardSetting = settingService.getBoardSetting();
        for (MenuTypeSub subMenu : menu.getSubMenuList()) {
            if (subMenu.getUrl().startsWith("/board/")) {
                String url = subMenu.getUrl().substring(7);
                BoardType boardType = boardSetting.getBoardType(url);
                if (boardType != null && boardType.isUse()) {
                    typeNoList.add(boardType.getNo());
                }
            }
        }

        // 하위 메뉴중 게시판이 없을 경우 처리
        if (typeNoList.size() == 0) {
            return "redirect:/error";
        }

        String name = menu.getName().replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
        model.addAttribute("boardType", new BoardType(0, name, "'" + name + "' 메뉴의 모든 게시글을 볼 수 있는 공간 입니다.", "all/" + menuNo));

        // 일반 게시글 리스트
        model.addAllAttributes(boardService.getBoardList(typeNoList, "all/" + menuNo, searchType, search, pageNo, numPage, order, popularThumb));
        return "boardList";
    }

    // 게시판 목록 페이지 진입
    @RequestMapping(value = "/board/{url:[a-z-]+}", method = RequestMethod.GET)
    public String boardList(@PathVariable String url, Model model,
            @RequestParam(defaultValue = "title") String searchType,
            @RequestParam(defaultValue = "") String search,
            @RequestParam(defaultValue = "1") int pageNo,
            @RequestParam(defaultValue = "30") int numPage,
            @RequestParam(defaultValue = "regdate_DESC") String order,
            @RequestParam(defaultValue = "0") int popularThumb) {

        // 유효한 정렬 방식 확인: 입력 값 그대로 쿼리로 들어가기 때문
        if (!order.equals("regdate_DESC") && !order.equals("hit_DESC") && !order.equals("thumb_DESC") && !order.equals("commentCount_DESC")) {
            order = "regdate_DESC";
        }

        // 유효한 게시판 분류 확인
        List<Integer> typeNoList = new ArrayList<Integer>();
        if (url.equals("all")) { // 전체 게시글 목록
            List<BoardType> boardTypeList = settingService.getBoardSetting().getBoardTypeList();
            for (BoardType boardType : boardTypeList) {
                if (boardType.isUse()) {
                    typeNoList.add(boardType.getNo());
                }
            }

            model.addAttribute("boardType", new BoardType(0, "전체 보기", "모든 게시판의 글을 볼 수 있는 공간 입니다.", "all"));
        } else { // 게시판 분류에 맞는 목록
            BoardType boardType = settingService.getBoardSetting().getBoardType(url);
            if (boardType == null || !boardType.isUse()) {
                return "redirect:/error";
            }
            typeNoList.add(boardType.getNo());

            model.addAttribute("boardType", boardType);
            model.addAttribute("noticeList", boardService.getNoticeList(boardType.getNo())); // 공지로 등록된 게시글 리스트
            model.addAttribute("adList", boardService.getAdList(boardType.getNo())); // 광고로 등록된 게시글 리스트
        }

        // 일반 게시글 리스트
        model.addAllAttributes(boardService.getBoardList(typeNoList, url, searchType, search, pageNo, numPage, order, popularThumb));
        return "boardList";
    }

    // 게시글 상세 페이지 진입
    @RequestMapping(value = "/board/{no:[0-9]+}", method = RequestMethod.GET)
    public String boardDetail(@PathVariable int no, Model model, HttpServletRequest req, HttpServletResponse res, RedirectAttributes ra,
            @RequestParam(defaultValue = "all") String url,
            @RequestParam(defaultValue = "title") String searchType,
            @RequestParam(defaultValue = "") String search,
            @RequestParam(defaultValue = "1") int pageNo,
            @RequestParam(defaultValue = "30") int numPage,
            @RequestParam(defaultValue = "regdate_DESC") String order,
            @RequestParam(defaultValue = "0") int popularThumb) {
        User user = (User) req.getSession().getAttribute("loginUser");
        Board board = boardService.getBoard(no);
        if (board == null || board.getBoardType() == null || !board.getBoardType().isUse()) {
            return "redirect:/error";
        } else if (!board.getBoardType().isReadableBoard(user, board)) {
            ra.addFlashAttribute(SessionAttribute.MSG, "해당 게시글의 열람 권한이 없습니다.");
            return "redirect:/board/" + board.getBoardType().getUrl();
        }

        // 유효한 정렬 방식 확인: 입력 값 그대로 쿼리로 들어가기 때문
        if (!order.equals("regdate_DESC") && !order.equals("hit_DESC") && !order.equals("thumb_DESC") && !order.equals("commentCount_DESC")) {
            order = "regdate_DESC";
        }

        // 조회수 증가
        String value = String.valueOf(no);
        Cookie cookie = cookieUtil.getCookie(req, CookieUtil.BOARD_HIT);
        if (!cookieUtil.isHasCookie(cookie, value)) {
            cookieUtil.addValue(res, cookie, value);
            boardService.addHit(no); // DB 값 증가
            board.setHit(board.getHit() + 1);
        }

        // 게시글 추천 여부
        boolean isAddedThumb = (user != null) ? thumbService.isAdded(no, user.getNo()) : false;
        model.addAttribute("isAddedThumb", isAddedThumb);

        // 유효한 게시판 분류 확인
        List<Integer> typeNoList = new ArrayList<Integer>();
        if (url.equals("all")) { // 전체 게시글 목록
            List<BoardType> boardTypeList = settingService.getBoardSetting().getBoardTypeList();
            for (BoardType boardType : boardTypeList) {
                if (boardType.isUse()) {
                    typeNoList.add(boardType.getNo());
                }
            }

            model.addAttribute("boardType", new BoardType(0, "전체 보기", "모든 게시판의 글을 볼 수 있는 공간 입니다.", "all"));
        } else { // 게시판 분류에 맞는 목록
            url = board.getBoardType().getUrl();
            typeNoList.add(board.getBoardType().getNo());

            model.addAttribute("boardType", board.getBoardType());
            model.addAttribute("noticeList", boardService.getNoticeList(board.getBoardType().getNo())); // 공지로 등록된 게시글 리스트
            model.addAttribute("adList", boardService.getAdList(board.getBoardType().getNo())); // 광고로 등록된 게시글 리스트
        }

        // 일반 게시글 리스트
        model.addAllAttributes(boardService.getBoardList(typeNoList, url, searchType, search, pageNo, numPage, order, popularThumb));

        // 게시글 상세 정보
        model.addAttribute("board", board);
        return "boardDetail";
    }

    // 게시글 작성 페이지 진입
    @RequestMapping(value = "/board/{url:[a-z-]+}/write", method = RequestMethod.GET)
    public String boardWriteForm(@PathVariable String url, Model model, HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        BoardType boardType = settingService.getBoardSetting().getBoardType(url);
        if (user == null || boardType == null || !boardType.isUse()) {
            return "redirect:/error";
        } else if (!boardType.isWritableBoard(user)) {
            ra.addFlashAttribute(SessionAttribute.MSG, "게시글 작성 권한이 없습니다.");
            return "redirect:/board/" + url;
        }
        model.addAttribute("type", "write");
        model.addAttribute("boardType", boardType);
        return "boardWrite";
    }

    // 게시글 작성
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/board/{url:[a-z-]+}/write", method = RequestMethod.POST)
    public String boardWrite(@PathVariable String url, Board board, HttpServletRequest req, RedirectAttributes ra) {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute(SessionAttribute.USER);
        BoardType boardType = settingService.getBoardSetting().getBoardType(url);
        if (user == null || boardType == null || !boardType.isUse() || board.getTypeNo() != boardType.getNo()) {
            return "redirect:/error";
        } else if (!boardType.isWritableBoard(user)) {
            ra.addFlashAttribute(SessionAttribute.MSG, "게시글 작성 권한이 없습니다.");
            return "redirect:/board/" + url;
        } else if (commonUtil.isEmptyText(board.getTitle())) {
            ra.addFlashAttribute(SessionAttribute.MSG, "제목을 입력 해주세요.");
            return "redirect:/board/" + url + "/write";
        } else if (commonUtil.isEmptyText(board.getContent())) {
            ra.addFlashAttribute(SessionAttribute.MSG, "내용을 입력 해주세요.");
            return "redirect:/board/" + url + "/write";
        } else if (boardType.isUseWriteCode()) {
            String captcha = (String) session.getAttribute(SessionAttribute.CAPTCHA);
            if (captcha == null || !captcha.equals(board.getCaptcha())) {
                ra.addFlashAttribute(SessionAttribute.MSG, "자동 방지 코드가 일치하지 않습니다.");
                return "redirect:/board/" + url + "/write";
            }
        }

        board.setUserNo(user.getNo());
        board.setNickname(user.getNickname());
        board.setBoardType(boardType);
        board.setIp(commonUtil.getIp(req));

        // 최고 관리자, 게시판 지기가 아닐경우 옵션 불가
        if (!user.isAdmin() && user.getGrade() != boardType.getAdminGrade()) {
            board.setGroupName(Board.NORMAL);
        }

        if (boardService.writeBoardTX(board)) {
            String content = board.getContent();

            // 이미지/첨부파일 업로드 임시 파일 이동, DB 저장
            List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
            attachFileService.addFiles(board, files);

            // local로 복사
            String realPath = session.getServletContext().getRealPath(""); // 기본 경로
            String folderName = File.separator + "board" + File.separator + board.getNo();
            fileUtil.copyFolder(realPath + Path.IMAGE.getPath() + folderName, Path.IMAGE.getLocalPath(folderName));
            fileUtil.copyFolder(realPath + Path.ATTACH.getPath() + folderName, Path.ATTACH.getLocalPath(folderName));

            // 본문 내용 수정시 DB 업데이트
            if (!content.equals(board.getContent())) {
                boardService.updateBoardContent(board);
            }

            ra.addFlashAttribute(SessionAttribute.MSG, "게시글 작성이 완료 되었습니다");
            return "redirect:/board/" + board.getNo() + "?url=" + url;
        } else {
            ra.addFlashAttribute(SessionAttribute.MSG, "게시글 작성이 실패 하였습니다.");
            return "redirect:/board/" + url + "/write";
        }
    }

    // 게시글 수정 페이지 진입
    @RequestMapping(value = "/board/{no:[0-9]+}/update", method = RequestMethod.GET)
    public String boardUpdateForm(@PathVariable int no, Model model, HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        Board board = boardService.getBoard(no);
        if (user == null || board == null || board.getBoardType() == null || !board.getBoardType().isUse()) {
            return "redirect:/error";
        } else if (!board.isEditable(user)) {
            ra.addFlashAttribute(SessionAttribute.MSG, "게시글 수정 권한이 없습니다.");
            return "redirect:/board/" + no + "?url=" + board.getBoardType().getUrl();
        }
        model.addAttribute("type", "update");
        model.addAttribute("boardType", board.getBoardType());
        model.addAttribute("board", board);

        // 기존 이미지/첨부파일 목록 취득
        model.addAttribute(SessionAttribute.ATTACH_FILES, attachFileService.getFileList(no));
        return "boardWrite";
    }

    // 게시글 수정
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/board/{no:[0-9]+}/update", method = RequestMethod.PUT)
    public String boardUpdate(@PathVariable int no, Board update, HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        Board board = boardService.getBoard(no);
        if (user == null || board == null || board.getBoardType() == null || !board.getBoardType().isUse() || board.getTypeNo() != board.getBoardType().getNo()) {
            return "redirect:/error";
        } else if (!board.isEditable(user)) {
            ra.addFlashAttribute(SessionAttribute.MSG, "게시글 수정 권한이 없습니다.");
            return "redirect:/board/" + no + "?url=" + board.getBoardType().getUrl();
        } else if (commonUtil.isEmptyText(update.getTitle())) {
            ra.addFlashAttribute(SessionAttribute.MSG, "제목을 입력 해주세요.");
            return "redirect:/board/" + no + "/update";
        } else if (commonUtil.isEmptyText(update.getContent())) {
            ra.addFlashAttribute(SessionAttribute.MSG, "내용을 입력 해주세요.");
            return "redirect:/board/" + no + "/update";
        } else if (board.getBoardType().isUseWriteCode()) {
            String captcha = (String) session.getAttribute(SessionAttribute.CAPTCHA);
            if (captcha == null || !captcha.equals(update.getCaptcha())) {
                ra.addFlashAttribute(SessionAttribute.MSG, "자동 방지 코드가 일치하지 않습니다.");
                return "redirect:/board/" + no + "/update";
            }
        }

        // 최고 관리자, 게시판 지기가 아닐경우 옵션 불가
        if (!user.isAdmin() && user.getGrade() != board.getBoardType().getAdminGrade()) {
            update.setGroupName(board.getGroupName());
            update.setHit(board.getHit());
            update.setRegdate(board.getRegdate());
        }

        String content = update.getContent();

        // 이미지/첨부파일 업로드 임시 파일 이동, DB 저장
        update.setBoardType(board.getBoardType());
        List<AttachFile> files = (List<AttachFile>) session.getAttribute(SessionAttribute.ATTACH_FILES);
        attachFileService.addFiles(update, files);

        // local로 복사
        String realPath = session.getServletContext().getRealPath(""); // 기본 경로
        String folderName = File.separator + "board" + File.separator + board.getNo();
        fileUtil.copyFolder(realPath + Path.IMAGE.getPath() + folderName, Path.IMAGE.getLocalPath(folderName));
        fileUtil.copyFolder(realPath + Path.ATTACH.getPath() + folderName, Path.ATTACH.getLocalPath(folderName));

        // 본문 내용 수정시 DB 업데이트
        if (!content.equals(update.getContent())) {
            boardService.updateBoardContent(update);
        }

        update.setNo(no);
        if (boardService.updateBoard(update)) {
            ra.addFlashAttribute(SessionAttribute.MSG, "게시글 수정이 완료 되었습니다");
        } else {
            ra.addFlashAttribute(SessionAttribute.MSG, "게시글 수정이 실패 하였습니다.");
        }
        return "redirect:/board/" + no + "?url=" + board.getBoardType().getUrl();
    }

    // 게시글 삭제
    @RequestMapping(value = "/board/{no:[0-9]+}/delete", method = RequestMethod.DELETE)
    public String boardDelete(@PathVariable int no, HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        Board board = boardService.getBoard(no);
        if (user == null || board == null || board.getBoardType() == null || !board.getBoardType().isUse()) {
            return "redirect:/error";
        } else if (!board.isEditable(user)) {
            ra.addFlashAttribute(SessionAttribute.MSG, "게시글 삭제 권한이 없습니다.");
            return "redirect:/board/" + no;
        }

        if (boardService.deleteBoardTX(board)) {
            // 해당 게시글의 이미지, 첨부파일 삭제
            String realPath = session.getServletContext().getRealPath(""); // 기본 경로
            String folderName = File.separator + "board" + File.separator + no;
            fileUtil.deleteFolder(realPath + Path.IMAGE.getPath() + folderName);
            fileUtil.deleteFolder(realPath + Path.ATTACH.getPath() + folderName);

            // local 파일 삭제
            fileUtil.deleteFolder(Path.IMAGE.getLocalPath(folderName));
            fileUtil.deleteFolder(Path.ATTACH.getLocalPath(folderName));

            ra.addFlashAttribute(SessionAttribute.MSG, "게시글 삭제가 완료 되었습니다");
        } else {
            ra.addFlashAttribute(SessionAttribute.MSG, "게시글 삭제가 실패 하였습니다.");
        }
        return "redirect:/board/" + board.getBoardType().getUrl();
    }

    // 게시글 추천 ajax 요청 json 반환
    @RequestMapping(value = "/board/{no:[0-9]+}/thumb", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public boolean thumb(@PathVariable int no, HttpSession session) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        Board board = boardService.getBoard(no);
        if (user == null || board == null || board.getBoardType() == null) {
            return false;
        } else if (thumbService.isAdded(no, user.getNo())) {
            return false;
        }
        return thumbService.addThumbTX(new Thumb(no, user.getNo()), board);
    }

    // 댓글 목록 ajax 요청 json 반환
    @RequestMapping(value = "/board/{no:[0-9]+}/comment", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public Map<String, Object> commentList(@PathVariable int no, HttpSession session, @RequestParam(defaultValue = "1") int pageNo) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        Board board = boardService.getBoard(no);
        if (board == null || board.getBoardType() == null) {
            return null;
        } else if (!board.getBoardType().isReadableComment(user)) {
            return null;
        }
        return commentService.getCommentList(board, pageNo, 15);
    }

    // 댓글 작성 ajax 요청 json 반환
    @RequestMapping(value = "/board/{no:[0-9]+}/comment/write", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public boolean commentWrite(@PathVariable int no, Comment comment, HttpServletRequest req) {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute(SessionAttribute.USER);
        Board board = boardService.getBoard(no);
        if (user == null || board == null || board.getBoardType() == null) {
            return false;
        } else if (!board.getBoardType().isWritableComment(user)) {
            return false;
        } else if (commonUtil.isEmptyText(comment.getContent())) {
            return false;
        } else if (board.getBoardType().isUseCommentCode()) {
            String captcha = (String) session.getAttribute(SessionAttribute.CAPTCHA);
            if (captcha == null || !captcha.equals(comment.getCaptcha())) {
                return false;
            }
        }

        comment.setUserNo(user.getNo());
        comment.setBoardNo(no);
        comment.setNickname(user.getNickname());
        comment.setIp(commonUtil.getIp(req));
        return commentService.writeCommentTX(comment, board);
    }

    // 댓글 삭제 ajax 요청 json 반환
    @RequestMapping(value = "/board/{no:[0-9]+}/comment/{commentNo:[0-9]+}/delete", method = RequestMethod.DELETE, produces = "application/json")
    @ResponseBody
    public boolean commentDelete(@PathVariable int no, @PathVariable int commentNo, HttpSession session) {
        User user = (User) session.getAttribute(SessionAttribute.USER);
        Board board = boardService.getBoard(no);
        Comment comment = commentService.getComment(commentNo);
        if (user == null || board == null || board.getBoardType() == null || comment == null || board.getNo() != comment.getBoardNo()) {
            return false;
        } else if (!comment.isEditable(board.getBoardType(), user)) {
            return false;
        }
        return commentService.deleteCommentTX(commentNo, board);
    }

    // 게시글의 첨부파일 다운로드
    @RequestMapping(value = "/board/{no:[0-9]+}/download/{fileNo:[0-9]+}", method = RequestMethod.GET)
    public void downloadAttachFile(@PathVariable int no, @PathVariable int fileNo, HttpSession session, HttpServletRequest req, HttpServletResponse res) throws IOException {
        String error = null;
        InputStream is = null;
        OutputStream os = null;
        try {
            os = res.getOutputStream();
            User user = (User) session.getAttribute(SessionAttribute.USER);
            Board board = boardService.getBoard(no);
            if (board == null || board.getBoardType() == null || !board.getBoardType().isUse()) {
                error = "<script>alert('Attach file download error');window.close();</script>";
                os.write(error.getBytes(Charset.forName("UTF-8")));
                return;
            } else if (!board.getBoardType().isDownloadable(user)) {
                error = "<script>alert('첨부파일 다운로드 권한이 없습니다.');window.close();</script>";
                os.write(error.getBytes(Charset.forName("UTF-8")));
                return;
            }

            AttachFile attachFile = attachFileService.getFile(no, fileNo);
            if (attachFile != null) {
                File file = new File(attachFile.getFullPath());
                if (file.exists()) {
                    // 한글 파일명 처리
                    String name = attachFile.getName();
                    if (req.getHeader("User-Agent").contains("MSIE")) {
                        name = URLEncoder.encode(name, "UTF-8");
                    } else {
                        name = new String(name.getBytes("UTF-8"), "ISO-8859-1");
                    }
                    res.setContentType("application/octet-stream");
                    res.setHeader("Content-Disposition", String.format("attachment; filename=\"" + name + "\""));
                    res.setContentLength((int) file.length());

                    is = new BufferedInputStream(new FileInputStream(file));
                    FileCopyUtils.copy(is, os);

                    // 다운로드 포인트 감소
                    int downloadPoint = board.getBoardType().getDownloadPoint();
                    if (downloadPoint > 0 && !attachFileService.isDownloaded(user.getNo(), fileNo)) {
                        attachFileService.addDownloadLog(user.getNo(), fileNo);
                        userService.updatePointTX(user.getNo(), downloadPoint, Point.DOWNLOAD_FILE);
                    }
                } else {
                    error = "<script>alert('존재하지 않는 파일 입니다.');window.close();</script>";
                    os.write(error.getBytes(Charset.forName("UTF-8")));
                }
            } else {
                error = "<script>alert('존재하지 않는 파일 입니다.');window.close();</script>";
                os.write(error.getBytes(Charset.forName("UTF-8")));
            }
        } catch (Exception e) {
            logger.warn("downloadAttachFile", e);
        } finally {
            if (os != null) {
                os.close();
            }
            if (is != null) {
                is.close();
            }
        }
    }
}
