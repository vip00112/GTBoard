package com.gt.board.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.gt.board.dao.BoardsDAO;
import com.gt.board.dao.ThumbsDAO;
import com.gt.board.enums.Point;
import com.gt.board.vo.Board;
import com.gt.board.vo.Thumb;

@Service
public class ThumbServiceImpl implements ThumbService {
    private BoardsDAO boardsDAO;
    private ThumbsDAO thumbsDAO;
    private UserService userService;

    public void setBoardsDAO(BoardsDAO boardsDAO) {
        this.boardsDAO = boardsDAO;
    }

    public void setThumbsDAO(ThumbsDAO thumbsDAO) {
        this.thumbsDAO = thumbsDAO;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Override
    public boolean isAdded(int boardNo, int userNo) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("boardNo", boardNo);
        paramMap.put("userNo", userNo);
        return thumbsDAO.selectCount(paramMap) > 0;
    }

    @Override
    public boolean addThumbTX(Thumb thumb, Board board) {
        int thumbPoint = board.getBoardType().getThumbPoint();
        if (thumbPoint > 0) {
            userService.updatePointTX(board.getUserNo(), thumbPoint, Point.ADD_THUMB); // 포인트 지급
        }
        boardsDAO.updateThumb(thumb.getBoardNo());
        return thumbsDAO.insert(thumb) == 1;
    }
}
