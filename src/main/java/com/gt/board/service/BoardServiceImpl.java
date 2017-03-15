package com.gt.board.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.gt.board.dao.BoardsDAO;
import com.gt.board.dao.CommentsDAO;
import com.gt.board.dao.ThumbsDAO;
import com.gt.board.enums.Point;
import com.gt.board.service.other.SettingService;
import com.gt.board.util.PaginateUtil;
import com.gt.board.vo.Board;
import com.gt.board.vo.other.PagingVO;
import com.gt.board.vo.xml.BoardSetting;
import com.gt.board.vo.xml.BoardType;

@Service
public class BoardServiceImpl implements BoardService {
    private BoardsDAO boardsDAO;
    private CommentsDAO commentsDAO;
    private ThumbsDAO thumbsDAO;
    private UserService userService;
    private AttachFileService attachFileService;
    private SettingService settingService;
    private PaginateUtil paginateUtil;

    public void setBoardsDAO(BoardsDAO boardsDAO) {
        this.boardsDAO = boardsDAO;
    }

    public void setCommentsDAO(CommentsDAO commentsDAO) {
        this.commentsDAO = commentsDAO;
    }

    public void setThumbsDAO(ThumbsDAO thumbsDAO) {
        this.thumbsDAO = thumbsDAO;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public void setAttachFileService(AttachFileService attachFileService) {
        this.attachFileService = attachFileService;
    }

    public void setSettingService(SettingService settingService) {
        this.settingService = settingService;
    }

    public void setPaginateUtil(PaginateUtil paginateUtil) {
        this.paginateUtil = paginateUtil;
    }

    @Override
    public boolean writeBoardTX(Board board) {
        int writePoint = board.getBoardType().getWritePoint();
        if (writePoint > 0) {
            userService.updatePointTX(board.getUserNo(), writePoint, Point.WRITE_BOARD); // 포인트 지급
        }
        return boardsDAO.insert(board) == 1;
    }

    @Override
    public boolean deleteBoardTX(Board board) {
        int no = board.getNo();
        int writePoint = board.getBoardType().getWritePoint();
        int thumbPoint = board.getBoardType().getThumbPoint() * board.getThumb(); // 추천수 * 추천포인트
        if (writePoint > 0) {
            userService.updatePointTX(board.getUserNo(), writePoint, Point.DELETE_BOARD); // 포인트 회수
        }
        if (thumbPoint > 0) {
            userService.updatePointTX(board.getUserNo(), thumbPoint, Point.REMOVE_THUMB); // 포인트 회수
        }
        commentsDAO.deleteByBoard(no); // 댓글 삭제
        thumbsDAO.delete(no); // 추천 기록 삭제
        attachFileService.removeFileList(no); // 첨부파일 삭제
        return boardsDAO.delete(no) == 1;
    }

    @Override
    public boolean deleteBoardTX(int typeNo) {
        List<Board> boardList = boardsDAO.selectListByBoardType(typeNo);
        BoardSetting setting = settingService.getBoardSetting();
        BoardType boardType = setting.getBoardType(typeNo);
        for (Board board : boardList) {
            board.setBoardType(boardType);
            deleteBoardTX(board);
        }
        return false;
    }

    @Override
    public boolean updateBoard(Board board) {
        return boardsDAO.update(board) == 1;
    }

    @Override
    public boolean updateBoardContent(Board board) {
        return boardsDAO.updateContent(board) == 1;
    }

    @Override
    public Board getBoard(int no) {
        Board board = boardsDAO.selectOne(no);
        if (board != null) {
            BoardSetting setting = settingService.getBoardSetting();
            BoardType boardType = setting.getBoardType(board.getTypeNo());
            board.setBoardType(boardType);
            board.setDownloadFiles(attachFileService.getDownloadFileList(no));

            // 닉네임 처리
            if (board.isNormal() && boardType.isAnonymous()) {
                board.setNickname("익명");
            } else if (board.isAd()) {
                board.setNickname("광고");
            }
        }
        return board;
    }

    @Override
    public boolean addHit(int no) {
        return boardsDAO.updateHit(no) == 1;
    }

    @Override
    public List<Board> getRecentList(int typeNo, int max) {
        List<Integer> typeNoList = new ArrayList<Integer>();
        typeNoList.add(typeNo);
        return getRecentList(typeNoList, max);
    }

    @Override
    public List<Board> getRecentList(List<Integer> typeNoList, int max) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("typeNoList", typeNoList);
        paramMap.put("max", max);
        List<Board> list = boardsDAO.selectListByRecent(paramMap);

        BoardSetting setting = settingService.getBoardSetting();
        for (Board board : list) {
            BoardType boardType = setting.getBoardType(board.getTypeNo());
            board.setBoardType(boardType);
            board.setDownloadFiles(attachFileService.getDownloadFileList(board.getNo()));

            // 닉네임 처리
            if (boardType.isAnonymous()) {
                board.setNickname("익명");
            }
        }
        return list;
    }

    @Override
    public Map<String, Object> getBoardList(List<Integer> typeNoList, String url, String searchType, String search, int pageNo, int numPage, String order, int popularThumb) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("typeNoList", typeNoList);
        paramMap.put("searchType", searchType);
        paramMap.put("search", search);
        paramMap.put("order", order.replace("_", " "));
        paramMap.put("popularThumb", popularThumb);
        paramMap.put("page", new PagingVO(pageNo, numPage));

        int total = boardsDAO.selectCount(paramMap);
        String param = "order=" + order + "&searchType=" + searchType + "&search=" + search + "&numPage=" + numPage;

        List<Board> list = boardsDAO.selectList(paramMap);
        BoardSetting setting = settingService.getBoardSetting();
        for (Board board : list) {
            BoardType boardType = setting.getBoardType(board.getTypeNo());
            board.setBoardType(boardType);
            board.setDownloadFiles(attachFileService.getDownloadFileList(board.getNo()));

            // 닉네임 처리
            if (boardType.isAnonymous()) {
                board.setNickname("익명");
            }
        }

        // 기존 페이지 옵션 저장
        resultMap.put("searchType", searchType);
        resultMap.put("search", search);
        resultMap.put("pageNo", pageNo);
        resultMap.put("numPage", numPage);
        resultMap.put("order", order);

        // 게시글 리스트
        resultMap.put("boardList", list);

        // 페이지네이션 Html
        resultMap.put("paginateHtml", paginateUtil.getPaginate(pageNo, total, numPage, 10, "/board/" + url + "?" + param));
        return resultMap;
    }

    @Override
    public Map<String, Object> getBoardList(int userNo, List<Integer> typeNoList, String url, String searchType, String search, int pageNo, int numPage, String order) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("userNo", userNo);
        paramMap.put("typeNoList", typeNoList);
        paramMap.put("searchType", searchType);
        paramMap.put("search", search);
        paramMap.put("order", order.replace("_", " "));
        paramMap.put("page", new PagingVO(pageNo, numPage));

        int total = boardsDAO.selectCount(paramMap);
        String param = "order=" + order + "&searchType=" + searchType + "&search=" + search + "&numPage=" + numPage;

        List<Board> list = boardsDAO.selectList(paramMap);
        BoardSetting setting = settingService.getBoardSetting();
        for (Board board : list) {
            board.setBoardType(setting.getBoardType(board.getTypeNo()));
            board.setDownloadFiles(attachFileService.getDownloadFileList(board.getNo()));
        }
        resultMap.put("boardList", list);
        resultMap.put("paginateHtml", paginateUtil.getPaginate(pageNo, total, numPage, 10, "/board/" + url + "?" + param));
        return resultMap;
    }

    @Override
    public List<Board> getNoticeList(int typeNo) {
        List<Board> list = boardsDAO.selectListByNotice(typeNo);
        BoardSetting setting = settingService.getBoardSetting();
        BoardType boardType = setting.getBoardType(typeNo);
        for (Board board : list) {
            board.setBoardType(boardType);
            board.setDownloadFiles(attachFileService.getDownloadFileList(board.getNo()));
        }
        return list;
    }

    @Override
    public List<Board> getAdList(int typeNo) {
        List<Board> list = boardsDAO.selectListByAd(typeNo);
        BoardSetting setting = settingService.getBoardSetting();
        BoardType boardType = setting.getBoardType(typeNo);
        for (Board board : list) {
            board.setBoardType(boardType);
            board.setDownloadFiles(attachFileService.getDownloadFileList(board.getNo()));

            // 닉네임 처리
            board.setNickname("광고");
        }
        return list;
    }

    @Override
    public boolean changeBoardType(int typeNo, List<Integer> boardNoList) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("typeNo", typeNo);
        paramMap.put("boardNoList", boardNoList);
        return boardsDAO.updateTypeNo(paramMap) == boardNoList.size();
    }
}
