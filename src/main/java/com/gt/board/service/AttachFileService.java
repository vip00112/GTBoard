package com.gt.board.service;

import java.util.List;

import com.gt.board.vo.AttachFile;
import com.gt.board.vo.Board;

public interface AttachFileService {
    /** 첨부파일 추가 (DB입력, 파일이동, 본문내용 수정까지 관할)
     *  @param board 첨부될 게시글
     *  @param files 업로드된 첨부파일 목록 **/
    public boolean addFiles(Board board, List<AttachFile> files);

    /** 첨부파일 1개 취득
     *  @param boardNo 게시글 번호
     *  @param fileNo 파일 번호 **/
    public AttachFile getFile(int boardNo, int fileNo);

    /** 해당 게시글의 첨부파일 목록
     *  @param boardNo 게시글 번호 **/
    public List<AttachFile> getFileList(int boardNo);

    /** 해당 게시글의 다운로드 가능한 첨부파일 목록
     *  @param boardNo 게시글 번호 **/
    public List<AttachFile> getDownloadFileList(int boardNo);

    /** 첨부파일 1개 삭제
     *  @param boardNo 게시글 번호
     *  @param newName 새로운 파일명 **/
    public boolean removeFile(int boardNo, String newName);

    /** 해당 게시글의 첨부파일 삭제
     *  @param boardNo 게시글 번호 **/
    public boolean removeFileList(int boardNo);
}
