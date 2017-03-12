package com.gt.board.enums;

/** xml 설정 파일 열거 **/
public enum SettingFile {
    BASE("setting-base.xml"), // 사이트 기본 정보 설정
    BOARD("setting-board.xml"), // 게시판 설정
    MENU("setting-menu.xml"); // 메뉴 설정

    private SettingFile() {
    }

    private SettingFile(String name) {
        this.name = name;
    }

    private String name;

    public String getName() {
        return name;
    }
}
