package com.gt.board.dao;

import java.util.List;
import java.util.Map;

import com.gt.board.vo.AttachFile;

public interface AttachFilesDAO {
    /** 첨부파일 추가
     *  @param file boardNo, name, size, newName, fullPath **/
    public int insert(AttachFile file);

    /** 첨부파일 1개 취득
     *  @param map boardNo, newName **/
    public AttachFile selectOne(Map<String, Object> map);

    /** 해당 게시글의 첨부파일 목록
     *  @param boardNo 게시글 번호 **/
    public List<AttachFile> selectList(int boardNo);

    /** 첨부파일 1개 삭제
     *  @param map boardNo, newName **/
    public int deleteByName(Map<String, Object> map);

    /** 해당 게시글의 첨부파일 삭제
     *  @param boardNo 게시글 번호 **/
    public int deleteByBoard(int boardNo);
    
    /** 첨부파일 다운로드 로그 기록
     *  @param map userNo, fileNo **/
    public int insertLog(Map<String, Object> map);

    /** 첨부파일 다운로드 로그 확인
     *  @param map userNo, fileNo **/
    public int selectCountLog(Map<String, Object> map);
}
