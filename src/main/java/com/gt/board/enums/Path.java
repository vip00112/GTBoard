package com.gt.board.enums;

import java.io.File;

import com.gt.board.config.Config;

/** 각종 파일이 저장될 폴더 경로 열거 **/
public enum Path {
    IMAGE("/resources/img"),
    ATTACH("/WEB-INF/attachFiles"),
    SETTING("/WEB-INF/config/setting");

    private Path() {
    }

    private Path(String path) {
        this.path = path.replace("/", File.separator);
    }

    private String path;

    /** 폴더 경로 반환 **/
    public String getPath() {
        return path;
    }

    /** 로컬 폴더 경로 반환 **/
    public String getLocalPath() {
        String path = Config.LOCAL_ROOT + this.path;
        path = path.replace("/", File.separator);
        return path;
    }

    /** 로컬 폴더 경로에 지정 경로 추가 하여 반환
     *  @param folder 추가 경로 **/
    public String getLocalPath(String folderName) {
        return getLocalPath() + File.separator + folderName + File.separator;
    }

}
