package com.gt.board.dao;

import java.util.List;

import com.gt.board.vo.Agreement;

public interface AgreementDAO {
    /** 해당 내용 취득
     *  @param no **/
    public Agreement selectOne(int no);

    /** 해당 type의 모든 내용 취득
     *  @param type terms, privacy **/
    public List<Agreement> selectList(String type);

    /** 새로운 내용 추가
     *  @param agreement type, content **/
    public int insert(Agreement agreement);

    /** 내용 수정
     *  @param agreement no, content, regdate **/
    public int update(Agreement agreement);
}
