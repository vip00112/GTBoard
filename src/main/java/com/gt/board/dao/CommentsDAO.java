package com.gt.board.dao;

import java.util.List;
import java.util.Map;

import com.gt.board.vo.Comment;

public interface CommentsDAO {

    /** 댓글 작성
     *  @param comment boardNo, userNo, nickname, content **/
    public int insert(Comment comment);

    /** 댓글 삭제
     *  @param no 댓글 번호 **/
    public int delete(int no);

    /** 게시글 삭제에 의한 댓글 삭제
     *  @param boardNo 게시글 번호 **/
    public int deleteByBoard(int boardNo);

    /** 댓글 1개 취득
     *  @param no 댓글 번호 **/
    public Comment selectOne(int no);

    /** 조건에 맞는 댓글 갯수
     *  @param map no:게시글 번호, 유저 번호 **/
    public int selectCount(Map<String, Object> map);

    /** 조건에 맞는 페이징 처리된 댓글 목록
     *  @param map boardNo, pagingVO **/
    public List<Comment> selectList(Map<String, Object> map);
}
