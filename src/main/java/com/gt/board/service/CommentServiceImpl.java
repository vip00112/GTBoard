package com.gt.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.gt.board.dao.BoardsDAO;
import com.gt.board.dao.CommentsDAO;
import com.gt.board.util.PaginateUtil;
import com.gt.board.vo.Board;
import com.gt.board.vo.Comment;
import com.gt.board.vo.other.PagingVO;

@Service
public class CommentServiceImpl implements CommentService {
    private BoardsDAO boardsDAO;
    private CommentsDAO commentsDAO;
    private UserService userService;
    private PaginateUtil paginateUtil;

    public void setBoardsDAO(BoardsDAO boardsDAO) {
        this.boardsDAO = boardsDAO;
    }

    public void setCommentsDAO(CommentsDAO commentsDAO) {
        this.commentsDAO = commentsDAO;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public void setPaginateUtil(PaginateUtil paginateUtil) {
        this.paginateUtil = paginateUtil;
    }

    @Override
    public boolean writeCommentTX(Comment comment, Board board) {
        int commentPoint = board.getBoardType().getCommentPoint();
        if (commentPoint > 0) {
            userService.updatePointTX(board.getUserNo(), 'I', commentPoint, UserService.POINT_REASON_WRITE_COMMENT); // 포인트 지급
        }
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("type", "add");
        paramMap.put("no", comment.getBoardNo());
        boardsDAO.updateCommentCount(paramMap);
        return commentsDAO.insert(comment) == 1;
    }

    @Override
    public boolean deleteCommentTX(int no, Board board) {
        int commentPoint = board.getBoardType().getCommentPoint();
        if (commentPoint > 0) {
            userService.updatePointTX(board.getUserNo(), 'D', commentPoint, UserService.POINT_REASON_DELETE_COMMENT); // 포인트 회수
        }
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("type", "remove");
        paramMap.put("no", board.getNo());
        boardsDAO.updateCommentCount(paramMap);
        return commentsDAO.delete(no) == 1;
    }

    @Override
    public boolean deleteCommentList(int boardNo) {
        return commentsDAO.deleteByBoard(boardNo) > 0;
    }

    @Override
    public Comment getComment(int no) {
        return commentsDAO.selectOne(no);
    }

    @Override
    public Map<String, Object> getCommentList(Board board, int pageNo, int numPage) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("boardNo", board.getNo());
        paramMap.put("page", new PagingVO(pageNo, numPage));

        int total = commentsDAO.selectCount(paramMap);
        List<Comment> list = commentsDAO.selectList(paramMap);

        // 익명 게시판일시 댓글도 익명 처리
        if (board.getBoardType().isAnonymous()) {
            for (Comment comment : list) {
                comment.setUserNo(0);
                comment.setNickname("익명");
            }
        }

        resultMap.put("list", list);
        resultMap.put("paginateHtml", paginateUtil.getPaginate(pageNo, total, numPage, 10, ""));
        return resultMap;
    }

    @Override
    public Map<String, Object> getCommentListByUser(int userNo, int pageNo, int numPage) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("userNo", userNo);
        paramMap.put("page", new PagingVO(pageNo, numPage));

        int total = commentsDAO.selectCount(paramMap);
        List<Comment> list = commentsDAO.selectList(paramMap);

        resultMap.put("list", list);
        resultMap.put("paginateHtml", paginateUtil.getPaginate(pageNo, total, numPage, 10, ""));
        return resultMap;
    }

}
