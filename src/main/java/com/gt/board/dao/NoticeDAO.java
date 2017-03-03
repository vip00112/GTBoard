package com.gt.board.dao;

import java.util.List;
import java.util.Map;

import com.gt.board.vo.Notice;

public interface NoticeDAO {

    /** 게시글 작성
     *  @param notice userNo, nickname, title, content **/
    public int insert(Notice notice);

    /** 게시글 삭제
     *  @param no 게시글 번호 **/
    public int delete(int no);

    /** 게시글 수정
     *  @param notice title, content **/
    public int update(Notice notice);

    /** 게시글 1개 취득
     *  @param no 게시글 번호 **/
    public Notice selectOne(int no);

    /** 조회수 증가
     *  @param no 게시글 번호 **/
    public int updateHit(int no);

    /** 공지사항 최신글 x개
     *  @param max 취득할 최대 갯수 **/
    public List<Notice> selectListByRecent(int max);

    /** 조건에 맞는 게시글 갯수
     *  @param map typeNoList, searchType, search **/
    public int selectCount(Map<String, Object> map);

    /** 조건에 맞는 페이징 처리된 게시글 목록
     *  @param map searchType, search, order, PagingVO **/
    public List<Notice> selectList(Map<String, Object> map);

}
