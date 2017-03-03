package com.gt.board.dao;

import java.util.Map;

import com.gt.board.vo.Thumb;

public interface ThumbsDAO {

    /** 해당 유저의 해당 게시글 추천 여부
     *  @param map boardNo, userNo **/
    public int selectCount(Map<String, Object> map);

    /** 게시글 추천
     *  @param thumb boardNo, userNo **/
    public int insert(Thumb thumb);

    /** 게시글 삭제에 의한 추천 기록 삭제
     *  @param boardNo 게시글 번호 **/
    public int delete(int boardNo);

}
