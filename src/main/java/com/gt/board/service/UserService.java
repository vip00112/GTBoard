package com.gt.board.service;

import com.gt.board.vo.User;

public interface UserService {
    public static final String POINT_REASON_WRITE_BOARD = "게시글 작성: 게시글 작성 포인트 지급";
    public static final String POINT_REASON_DELETE_BOARD = "게시글 삭제: 게시글 작성 포인트 회수";
    public static final String POINT_REASON_ADD_THUMB = "게시글 추천: 게시글 추천 포인트 지급";
    public static final String POINT_REASON_REMOVE_THUMB = "게시글 삭제: 게시글 추천 포인트 회수";
    public static final String POINT_REASON_WRITE_COMMENT = "댓글 작성: 댓글 작성 포인트 지급";
    public static final String POINT_REASON_DELETE_COMMENT = "댓글 삭제: 댓글 작성 포인트 회수";

    /** 유저 정보 취득: 로그인, 비밀번호 찾기
     *  @param email 가입시 작성한 이메일 **/
    public User getUser(String email);

    /** 유저 정보 취득: 내정보
     *  @param no 유저 번호 **/
    public User getUser(int no);

    /** 회원가입
     *  @param user email, password, nickname **/
    public boolean join(User user);

    /** 계정 활성화
     *  @param no 유저 번호 **/
    public boolean setActive(int no);

    /** email, nickname 중복 검사
     *  @param no 유저 번호
     *  @param type email, nickname
     *  @param value 검사할 값 **/
    public boolean isOverlap(int no, String type, String value);

    /** 닉네임 변경
     *  @param no 유저 번호
     *  @param nickname 변경할 비밀번호 **/
    public boolean updateNickname(int no, String nickname);

    /** 비밀번호 변경
     *  @param email 유저 아이디(이메일)
     *  @param password 변경할 비밀번호 **/
    public boolean updatePassword(String email, String password);

    /** 포인트 증가/감소
     *  @param no 유저 번호
     *  @param type 'I':Increase 증가, 'D':Decrease 감소
     *  @param point 증가/감소할 포인트 수치
     *  @param reason 증가/감소의 원인 **/
    public boolean updatePointTX(int no, char type, int point, String reason);

}
