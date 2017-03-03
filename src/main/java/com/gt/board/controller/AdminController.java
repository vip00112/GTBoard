package com.gt.board.controller;

import java.io.File;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gt.board.enums.Path;
import com.gt.board.enums.SettingFile;
import com.gt.board.service.other.SettingService;
import com.gt.board.vo.xml.BaseSetting;
import com.gt.board.vo.xml.BoardSetting;
import com.gt.board.vo.xml.BoardType;

@Controller
public class AdminController {
    private SettingService settingService;

    public void setSettingService(SettingService settingService) {
        this.settingService = settingService;
    }

    // admin 페이지 진입
    @RequestMapping(value = "/admin", method = RequestMethod.GET)
    public String admin(HttpSession session) {
        return "admin";
    }

    // baseSetting 정보 요청 json 반환
    @RequestMapping(value = "/admin/setting/base", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public BaseSetting basicSetting(HttpSession session) {
        return settingService.getBaseSetting();
    }

    // baseSetting 정보 수정
    @RequestMapping(value = "/admin/setting/base/update", method = RequestMethod.POST)
    public String baseSettingUpdate(HttpSession session, BaseSetting baseSetting) {
        String path = session.getServletContext().getRealPath(Path.SETTING.getPath());
        settingService.setBaseSetting(baseSetting);
        settingService.writeSettingXML(path, SettingFile.BASE);

        // 실제 프로젝트 폴더 절대 경로
        path = Path.SETTING.getLocalPath();
        if (new File(path).exists()) {
            settingService.writeSettingXML(path, SettingFile.BASE);
        }
        return "redirect:/admin";
    }

    // boardSetting 정보 요청 json 반환
    @RequestMapping(value = "/admin/setting/board", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public BoardType boardSetting(HttpSession session, @RequestParam int no) {
        BoardSetting boardSetting = settingService.getBoardSetting();
        return boardSetting.getBoardType(no);
    }

    // baseSetting 정보 수정
    @RequestMapping(value = "/admin/setting/board/update", method = RequestMethod.POST)
    public String boardSettingUpdate(HttpSession session, @RequestParam int no, BoardType boardSetting) {
        String path = session.getServletContext().getRealPath(Path.SETTING.getPath());
        settingService.setBoardSetting(boardSetting);
        settingService.writeSettingXML(path, SettingFile.BOARD);

        // 실제 프로젝트 폴더 절대 경로
        path = Path.SETTING.getLocalPath();
        if (new File(path).exists()) {
            settingService.writeSettingXML(path, SettingFile.BOARD);
        }
        return "redirect:/admin";
    }
}
