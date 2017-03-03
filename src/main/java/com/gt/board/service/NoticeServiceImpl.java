package com.gt.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.gt.board.dao.NoticeDAO;
import com.gt.board.util.PaginateUtil;
import com.gt.board.vo.Notice;
import com.gt.board.vo.other.PagingVO;

@Service
public class NoticeServiceImpl implements NoticeService {
    private NoticeDAO noticeDAO;
    private PaginateUtil paginateUtil;

    public void setNoticeDAO(NoticeDAO noticeDAO) {
        this.noticeDAO = noticeDAO;
    }

    public void setPaginateUtil(PaginateUtil paginateUtil) {
        this.paginateUtil = paginateUtil;
    }

    @Override
    public boolean writeNotice(Notice notice) {
        return noticeDAO.insert(notice) == 1;
    }

    @Override
    public boolean deleteNotice(int no) {
        return noticeDAO.delete(no) == 1;
    }

    @Override
    public boolean updateNotice(Notice notice) {
        return noticeDAO.update(notice) == 1;
    }

    @Override
    public boolean addHit(int no) {
        return noticeDAO.updateHit(no) == 1;
    }

    @Override
    public Notice getNotice(int no) {
        return noticeDAO.selectOne(no);
    }

    @Override
    public List<Notice> getNoticeListRecent(int max) {
        return noticeDAO.selectListByRecent(max);
    }

    @Override
    public Map<String, Object> getNoticeList(String searchType, String search, int pageNo, int numPage, String order) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("searchType", searchType);
        paramMap.put("search", search);
        paramMap.put("order", order.replace("_", " "));
        paramMap.put("page", new PagingVO(pageNo, numPage));

        int total = noticeDAO.selectCount(paramMap);
        List<Notice> list = noticeDAO.selectList(paramMap);

        // 기존 페이지 옵션 저장
        resultMap.put("searchType", searchType);
        resultMap.put("search", search);
        resultMap.put("pageNo", pageNo);
        resultMap.put("numPage", numPage);
        resultMap.put("order", order);

        // 공지사항 리스트
        resultMap.put("boardList", list);

        // 페이지네이션 Html
        resultMap.put("paginateHtml", paginateUtil.getPaginate(pageNo, total, numPage, 10, "/notice"));
        return resultMap;
    }
}
