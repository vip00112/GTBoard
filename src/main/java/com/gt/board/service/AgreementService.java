package com.gt.board.service;

import java.util.List;

import com.gt.board.vo.Agreement;

public interface AgreementService {
    /** 해당 내용 취득
     *  @param no **/
    public Agreement getAgreement(int no);

    /** 해당 type의 최신 내용 취득
     *  @param type terms, privacy **/
    public Agreement getAgreementRecent(String type);

    /** 해당 type의 모든 내용 취득
     *  @param type terms, privacy **/
    public List<Agreement> getAgreementList(String type);

    /** 새로운 내용 추가
     *  @param agreement type, content **/
    public boolean addAgreement(Agreement agreement);

    /** 내용 수정
     *  @param agreement no, content, regdate **/
    public boolean updateAgreement(Agreement agreement);
}
