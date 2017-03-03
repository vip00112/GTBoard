package com.gt.board.service;

import java.util.List;
import java.util.Map;

import com.gt.board.vo.Notice;

public interface NoticeService {

    /** 게시글 작성
     *  @param notice userNo, nickname, title, content **/
    public boolean writeNotice(Notice notice);

    /** 게시글 삭제
     *  @param no 게시글 번호 **/
    public boolean deleteNotice(int no);

    /** 게시글 수정
     *  @param notice title, content **/
    public boolean updateNotice(Notice notice);

    /** 게시글 1개 취득
     *  @param no 게시글 번호 **/
    public Notice getNotice(int no);

    /** 조회수 증가
     *  @param no 게시글 번호 **/
    public boolean addHit(int no);

    /** 공지사항 최신글 x개
     *  @param max 취득할 최대 갯수 **/
    public List<Notice> getNoticeListRecent(int max);

    /** 조건에 맞는 페이징 처리된 게시글 목록
     *  @param searchType 검색 기준: 제목, 제목+내용
     *  @param search 검색어
     *  @param pageNo 현재 페이지
     *  @param numPage 페이지당 게시글 갯수
     *  @param order 정렬 방법
     *  @return Map<String, Object> boardList, paginateHtml **/
    public Map<String, Object> getNoticeList(String searchType, String search, int pageNo, int numPage, String order);

}
