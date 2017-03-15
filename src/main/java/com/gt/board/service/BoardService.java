package com.gt.board.service;

import java.util.List;
import java.util.Map;

import com.gt.board.vo.Board;

public interface BoardService {

    /** 게시글 작성
     *  @param board typeNo, userNo, nickname, title, content, group **/
    public boolean writeBoardTX(Board board);

    /** 게시글 삭제
     *  @param board 게시글 **/
    public boolean deleteBoardTX(Board board);

    /** 해당 게시판 분류의 전체 게시글 삭제
     *  @param typeNo BoardType.no **/
    public boolean deleteBoardTX(int typeNo);

    /** 게시글 수정
     *  @param board typeNo, title, content, group **/
    public boolean updateBoard(Board board);

    /** 게시글 내용만 수정
     *  @param board no, content **/
    public boolean updateBoardContent(Board board);

    /** 게시글 1개 취득
     *  @param no 게시글 번호 **/
    public Board getBoard(int no);

    /** 조회수 증가
     *  @param no 게시글 번호 **/
    public boolean addHit(int no);

    /** 해당 게시판 분류의 최신글 x개
     *  @param typeNo BoardType.no
     *  @param max 취득할 최대 갯수 **/
    public List<Board> getRecentList(int typeNo, int max);

    /** 해당 게시판 분류 리스트의 최신글 x개
     *  @param typeNoList BoardType.no List
     *  @param max 취득할 최대 갯수 **/
    public List<Board> getRecentList(List<Integer> typeNoList, int max);

    /** 조건에 맞는 페이징 처리된 게시글 목록
     *  @param typeNoList BoardType.no List
     *  @param url BoardType.url
     *  @param searchType 검색 기준: 제목, 제목+내용, 닉네임, 아이디
     *  @param search 검색어
     *  @param pageNo 현재 페이지
     *  @param numPage 페이지당 게시글 갯수
     *  @param order 정렬 방법
     *  @param popularThumb 최소 추천 수
     *  @return Map<String, Object> boardList, paginateHtml **/
    public Map<String, Object> getBoardList(List<Integer> typeNoList, String url, String searchType, String search, int pageNo, int numPage, String order, int popularThumb);

    /** 조건에 맞는 페이징 처리된 해당 유저의 게시글 목록
     *  @param userNo 유저 번호
     *  @param typeNoList BoardType.no List
     *  @param url BoardType.url
     *  @param searchType 검색 기준: 제목, 제목+내용, 닉네임, 아이디
     *  @param search 검색어
     *  @param pageNo 현재 페이지
     *  @param numPage 페이지당 게시글 갯수
     *  @param order 정렬 방법
     *  @return Map<String, Object> boardList, paginateHtml **/
    public Map<String, Object> getBoardList(int userNo, List<Integer> typeNoList, String url, String searchType, String search, int pageNo, int numPage, String order);

    /** 해당 게시판의 공지 게시글 목록
     *  @param typeNo BoardType.no **/
    public List<Board> getNoticeList(int typeNo);

    /** 해당 게시판의 광고 게시글 목록
     *  @param typeNo BoardType.no **/
    public List<Board> getAdList(int typeNo);

    /** 게시판 이동
     *  @param typeNo 게시판 분류 번호 
     *  @param boardNoList 이동할 게시글 번호 리스트 **/
    public boolean changeBoardType(int typeNo, List<Integer> boardNoList);
}
