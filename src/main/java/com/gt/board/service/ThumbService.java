package com.gt.board.service;

import com.gt.board.vo.Board;
import com.gt.board.vo.Thumb;

public interface ThumbService {

    /** 해당 유저의 해당 게시글 추천 여부
     *  @param map boardNo, userNo **/
    public boolean isAdded(int boardNo, int userNo);

    /** 게시글 추천
     *  @param thumb boardNo, userNo
     *  @param board 추천 받은 게시글 **/
    public boolean addThumbTX(Thumb thumb, Board board);

}
