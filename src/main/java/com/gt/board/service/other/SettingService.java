package com.gt.board.service.other;

import com.gt.board.enums.SettingFile;
import com.gt.board.vo.xml.BaseSetting;
import com.gt.board.vo.xml.BoardSetting;
import com.gt.board.vo.xml.BoardType;
import com.gt.board.vo.xml.MenuSetting;
import com.gt.board.vo.xml.MenuType;

public interface SettingService {

    /** 모든 setting xml 파일 read
     *  @param folderPath setting xml 파일들이 있는 폴더 경로 **/
    public void readAllSettingXML(String folderPath);

    /** 해당 setting xml 파일 write
     *  @param folderPath setting xml 파일들이 있는 폴더 경로
     *  @param file SettingFile enum **/
    public void writeSettingXML(String folderPath, SettingFile file);

    /** 사이트 기본 정보 설정 객체 반환
     *  @return BaseSetting **/
    public BaseSetting getBaseSetting();

    /** 사이트 기본 정보 설정 객체 수정
     *  @param baseSetting 기본 정보 **/
    public void setBaseSetting(BaseSetting baseSetting);

    /** 메뉴 설정 객체 반환
     *  @return MenuSetting **/
    public MenuSetting getMenuSetting();

    /** 메뉴 설정 객체 추가/수정
     *  @param menuType 메뉴 정보 **/
    public void setMenuSetting(MenuType menuType);

    /** 메뉴 설정 객체 삭제
     *  @param no 메뉴 no **/
    public void removeMenuSetting(int no);

    /** 게시판 설정 객체 반환
     *  @return BoardSetting **/
    public BoardSetting getBoardSetting();

    /** 게시판 설정 객체 추가/수정
     *  @param boardType 게시판 정보 **/
    public void setBoardSetting(BoardType boardType);

    /** 게시판 설정 객체 삭제
     *  @param no 메뉴 no **/
    public void removeBoardSetting(int no);
}
