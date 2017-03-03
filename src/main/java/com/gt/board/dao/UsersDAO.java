package com.gt.board.dao;

import java.util.Map;

import com.gt.board.vo.User;

public interface UsersDAO {
    /** 유저 정보 취득: 로그인, 비밀번호 찾기
     *  @param email 가입시 작성한 이메일 **/
    public User selectOneByEmail(String email);

    /** 유저 정보 취득: 내정보
     *  @param no 유저 번호 **/
    public User selectOneByNo(int no);

    /** 회원가입
     *  @param user email, password, nickname **/
    public int insert(User user);

    /** 계정 활성화
     *  @param no 유저 번호 **/
    public int updateActive(int no);

    /** email 중복 검사
     *  @param map no, value(id) **/
    public int selectCountByEmail(Map<String, Object> map);

    /** nickname 중복 검사
     *  @param map no, value(nickname) **/
    public int selectCountByNickname(Map<String, Object> map);

    /** 닉네임 변경
     *  @param map no, nickname **/
    public int updateNickname(Map<String, Object> map);

    /** 비밀번호 변경
     *  @param map email, password **/
    public int updatePassword(Map<String, Object> map);

    /** 포인트 증가/감소
     *  @param map no, type('I','D'), point **/
    public int updatePoint(Map<String, Object> map);

    /** 포인트 증가/감소 기록
     *  @param map no, type('I','D'), point, reason **/
    public int insertPointHistory(Map<String, Object> map);

}
