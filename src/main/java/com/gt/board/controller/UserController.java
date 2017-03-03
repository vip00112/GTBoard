package com.gt.board.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gt.board.config.SessionAttribute;
import com.gt.board.service.BoardService;
import com.gt.board.service.CommentService;
import com.gt.board.service.UserService;
import com.gt.board.service.other.SettingService;
import com.gt.board.vo.Board;
import com.gt.board.vo.Comment;
import com.gt.board.vo.User;
import com.gt.board.vo.xml.BoardType;

@Controller
public class UserController {
    private UserService userService;
    private BoardService boardService;
    private CommentService commentService;
    private SettingService settingService;

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public void setBoardService(BoardService boardService) {
        this.boardService = boardService;
    }

    public void setCommentService(CommentService commentService) {
        this.commentService = commentService;
    }

    public void setSettingService(SettingService settingService) {
        this.settingService = settingService;
    }

    // myPage 진입
    @RequestMapping(value = "/user/{no:[0-9]+}", method = RequestMethod.GET)
    public String myPage(@PathVariable int no, HttpSession session, RedirectAttributes ra) {
        User user = (User) userService.getUser(no);
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (user == null || loginUser == null || user.getNo() != loginUser.getNo()) {
            ra.addFlashAttribute("존재 하지 않는 유저 이거나 권한이 없습니다.");
            return "redirect:/error";
        }
        return "myPage";
    }

    // myPage 게시글 관리: 게시글 목록 취득 ajax 요청 json 반환
    @RequestMapping(value = "/user/{no:[0-9]+}/board/list", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public Map<String, Object> myPageBoardList(@PathVariable int no, HttpSession session,
            @RequestParam(defaultValue = "title") String searchType,
            @RequestParam(defaultValue = "") String search,
            @RequestParam(defaultValue = "1") int pageNo,
            @RequestParam(defaultValue = "30") int numPage,
            @RequestParam(defaultValue = "regdate_DESC") String order) {
        User user = (User) userService.getUser(no);
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (user == null || loginUser == null || user.getNo() != loginUser.getNo()) {
            return null;
        }

        // 유효한 정렬 방식 확인: 입력 값 그대로 쿼리로 들어가기 때문
        if (!order.equals("regdate_DESC") && !order.equals("hit_DESC") && !order.equals("thumb_DESC") && !order.equals("commentCount_DESC")) {
            order = "regdate_DESC";
        }

        List<Integer> typeNoList = new ArrayList<Integer>();
        List<BoardType> boardTypeList = settingService.getBoardSetting().getBoardTypeList();
        for (BoardType boardType : boardTypeList) {
            if (boardType.isUse()) {
                typeNoList.add(boardType.getNo());
            }
        }
        return boardService.getBoardList(loginUser.getNo(), typeNoList, "all", searchType, search, pageNo, numPage, order);
    }

    // myPage 게시글 관리: 선택 항목 삭제 ajax 요청 json 반환
    @RequestMapping(value = "/user/{no:[0-9]+}/board/delete", method = RequestMethod.DELETE, produces = "application/json")
    @ResponseBody
    public boolean myPageBoardDelete(@PathVariable int no, HttpSession session, @RequestParam(value = "boardNo") String boardNo) {
        User user = (User) userService.getUser(no);
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (user == null || loginUser == null || user.getNo() != loginUser.getNo()) {
            return false;
        } else if (boardNo == null) {
            return false;
        }

        String[] boardNos = boardNo.split(",");
        for (String noStr : boardNos) {
            // 게시글 검증
            Board board = boardService.getBoard(Integer.parseInt(noStr));
            if (board == null || board.getUserNo() != loginUser.getNo()) {
                return false;
            }

            // 게시글 삭제
            if (!boardService.deleteBoardTX(board)) {
                return false;
            }
        }
        return true;
    }

    // myPage 댓글 관리: 댓글 목록 취득 ajax 요청 json 반환
    @RequestMapping(value = "/user/{no:[0-9]+}/comment/list", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public Map<String, Object> myPageCommentList(@PathVariable int no, HttpSession session,
            @RequestParam(defaultValue = "1") int pageNo,
            @RequestParam(defaultValue = "15") int numPage) {
        User user = (User) userService.getUser(no);
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (user == null || loginUser == null || user.getNo() != loginUser.getNo()) {
            return null;
        }

        return commentService.getCommentListByUser(loginUser.getNo(), pageNo, numPage);
    }

    // myPage 댓글 관리: 선택 항목 삭제 ajax 요청 json 반환
    @RequestMapping(value = "/user/{no:[0-9]+}/comment/delete", method = RequestMethod.DELETE, produces = "application/json")
    @ResponseBody
    public boolean myPageCommentDelete(@PathVariable int no, HttpSession session, @RequestParam(value = "commentNo") String commentNo) {
        User user = (User) userService.getUser(no);
        User loginUser = (User) session.getAttribute(SessionAttribute.USER);
        if (user == null || loginUser == null || user.getNo() != loginUser.getNo()) {
            return false;
        } else if (commentNo == null) {
            return false;
        }

        String[] commentNos = commentNo.split(",");
        for (String noStr : commentNos) {
            // 댓글 검증
            Comment comment = commentService.getComment(Integer.parseInt(noStr));
            Board board = null;
            if (comment == null || comment.getUserNo() != loginUser.getNo()) {
                return false;
            } else if ((board = boardService.getBoard(comment.getBoardNo())) == null || board.getBoardType() == null) {
                return false;
            }

            // 댓글 삭제
            if (!commentService.deleteCommentTX(Integer.parseInt(noStr), board)) {
                return false;
            }
        }
        return true;
    }

}