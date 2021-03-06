package com.gt.board.service.other;

import java.io.File;

import org.springframework.stereotype.Service;

import com.gt.board.enums.SettingFile;
import com.gt.board.util.XMLUtil;
import com.gt.board.vo.xml.BaseSetting;
import com.gt.board.vo.xml.BoardSetting;
import com.gt.board.vo.xml.BoardType;
import com.gt.board.vo.xml.MenuSetting;
import com.gt.board.vo.xml.MenuType;

@Service
public class SettingServiceImpl implements SettingService {
    private BaseSetting baseSetting; // 사이트 기본 정보 설정
    private BoardSetting boardSetting; // 게시판 설정
    private MenuSetting menuSetting; // 메뉴 설정

    private XMLUtil xmlUtil;

    public void setXmlUtil(XMLUtil xmlUtil) {
        this.xmlUtil = xmlUtil;
    }

    @Override
    public void readAllSettingXML(String folderPath) {
        for (SettingFile file : SettingFile.values()) {
            String path = folderPath + File.separator + file.getName();
            switch (file) {
            case BASE: // 사이트 기본 정보 설정 객체
                baseSetting = (BaseSetting) xmlUtil.getUnmarshalObject(BaseSetting.class, path);
                break;
            case BOARD: // 게시판 설정 객체
                boardSetting = (BoardSetting) xmlUtil.getUnmarshalObject(BoardSetting.class, path);
                break;
            case MENU: // 메뉴 설정 객체
                menuSetting = (MenuSetting) xmlUtil.getUnmarshalObject(MenuSetting.class, path);
                break;
            }
        }
    }

    @Override
    public void writeSettingXML(String folderPath, SettingFile file) {
        String path = folderPath + File.separator + file.getName();
        switch (file) {
        case BASE: // 사이트 기본 정보 설정 객체
            xmlUtil.setMarshalObject(BaseSetting.class, baseSetting, path);
            break;
        case BOARD: // 게시판 설정 객체
            xmlUtil.setMarshalObject(BoardSetting.class, boardSetting, path);
            break;
        case MENU: // 메뉴 설정 객체
            xmlUtil.setMarshalObject(MenuSetting.class, menuSetting, path);
            break;
        }
    }

    @Override
    public BaseSetting getBaseSetting() {
        return baseSetting;
    }

    @Override
    public void setBaseSetting(BaseSetting baseSetting) {
        this.baseSetting = baseSetting;
    }

    @Override
    public MenuSetting getMenuSetting() {
        return menuSetting;
    }

    @Override
    public void setMenuSetting(MenuType menuType) {
        menuSetting.setMenuType(menuType);
    }

    @Override
    public void removeMenuSetting(int no) {
        menuSetting.removeItem(no);
    }

    @Override
    public BoardSetting getBoardSetting() {
        return boardSetting;
    }

    @Override
    public void setBoardSetting(BoardType boardType) {
        boardSetting.setBoardType(boardType);
    }

    @Override
    public void removeBoardSetting(int no) {
        boardSetting.removeItem(no);
    }
}
