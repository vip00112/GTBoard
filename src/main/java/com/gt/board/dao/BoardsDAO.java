package com.gt.board.dao;

import java.util.List;
import java.util.Map;

import com.gt.board.vo.Board;

public interface BoardsDAO {

    /** 게시글 작성
     *  @param board typeNo, userNo, nickname, title, content, notice **/
    public int insert(Board board);

    /** 게시글 삭제
     *  @param no 게시글 번호 **/
    public int delete(int no);

    /** 게시글 수정
     *  @param board no, typeNo, title, content, notice **/
    public int update(Board board);

    /** 게시글 내용만 수정
     *  @param board no, content **/
    public int updateContent(Board board);

    /** 게시글 1개 취득
     *  @param no 게시글 번호 **/
    public Board selectOne(int no);

    /** 조회수 증가
     *  @param no 게시글 번호 **/
    public int updateHit(int no);

    /** 댓글 수 증가/감소
     *  @param map type, no **/
    public int updateCommentCount(Map<String, Object> map);

    /** 추천 수 증가
     *  @param no 게시글 번호 **/
    public int updateThumb(int no);

    /** 해당 게시판 분류의 최신글 x개
     *  @param map typeNo, max **/
    public List<Board> selectListByRecent(Map<String, Object> map);

    /** 조건에 맞는 게시글 갯수
     *  @param map typeNoList, searchType, search **/
    public int selectCount(Map<String, Object> map);

    /** 조건에 맞는 페이징 처리된 게시글 목록
     *  @param map typeNoList, searchType, search, order, PagingVO **/
    public List<Board> selectList(Map<String, Object> map);

    /** 해당 게시판의 공지 게시글 목록
     *  @param typeNo BoardType.no **/
    public List<Board> selectListByNotice(int typeNo);

}
