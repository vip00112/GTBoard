package com.gt.board.service;

import java.util.Map;

import com.gt.board.vo.Board;
import com.gt.board.vo.Comment;

public interface CommentService {

    /** 댓글 작성
     *  @param comment boardNo, userNo, nickname, content
     *  @param board 해당 댓글이 달린 게시글 **/
    public boolean writeCommentTX(Comment comment, Board board);

    /** 댓글 삭제
     *  @param no 댓글 번호
     *  @param board 해당 댓글이 달린 게시글 **/
    public boolean deleteCommentTX(int no, Board board);

    /** 게시글 삭제에 의한 댓글 삭제
     *  @param boardNo 게시글 번호 **/
    public boolean deleteCommentList(int boardNo);

    /** 댓글 1개 취득
     *  @param no 댓글 번호 **/
    public Comment getComment(int no);

    /** 조건에 맞는 페이징 처리된 댓글 목록
     *  @param board 댓글 목록을 소유한 게시글
     *  @param pageNo 현재 페이지
     *  @param numPage 페이지당 게시글 갯수
     *  @return Map<String, Object> list, paginateHtml **/
    public Map<String, Object> getCommentList(Board board, int pageNo, int numPage);

    /** 조건에 맞는 페이징 처리된 해당 유저의 댓글 목록
     *  @param userNo 유저 번호
     *  @param pageNo 현재 페이지
     *  @param numPage 페이지당 게시글 갯수
     *  @return Map<String, Object> list, paginateHtml **/
    public Map<String, Object> getCommentListByUser(int userNo, int pageNo, int numPage);

}
