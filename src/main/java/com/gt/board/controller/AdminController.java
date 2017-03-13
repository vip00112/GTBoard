package com.gt.board.controller;

import java.io.File;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gt.board.enums.Path;
import com.gt.board.enums.SettingFile;
import com.gt.board.service.BoardService;
import com.gt.board.service.other.SettingService;
import com.gt.board.vo.xml.BaseSetting;
import com.gt.board.vo.xml.BoardSetting;
import com.gt.board.vo.xml.BoardType;
import com.gt.board.vo.xml.MenuSetting;
import com.gt.board.vo.xml.MenuType;

@Controller
public class AdminController {
    private SettingService settingService;
    private BoardService boardService;

    public void setSettingService(SettingService settingService) {
        this.settingService = settingService;
    }

    public void setBoardService(BoardService boardService) {
        this.boardService = boardService;
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
    @RequestMapping(value = "/admin/setting/base", method = RequestMethod.PUT)
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

    // menuSetting 정보 요청 json 반환
    @RequestMapping(value = "/admin/setting/menuType/{no:[0-9]+}", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public MenuType menuSetting(HttpSession session, @PathVariable int no) {
        MenuSetting menuSetting = settingService.getMenuSetting();
        return menuSetting.getMenuType(no);
    }

    // menuSetting 정보 추가/수정
    @RequestMapping(value = "/admin/setting/menuType/{no:[0-9]+}", method = { RequestMethod.POST, RequestMethod.PUT })
    public String menuSettingUpdate(HttpSession session, @PathVariable int no, MenuType menuType) {
        if (no != menuType.getNo()) {
            return "redirect:/error";
        }

        String path = session.getServletContext().getRealPath(Path.SETTING.getPath());
        settingService.setMenuSetting(menuType);
        settingService.writeSettingXML(path, SettingFile.MENU);

        // 실제 프로젝트 폴더 절대 경로
        path = Path.SETTING.getLocalPath();
        if (new File(path).exists()) {
            settingService.writeSettingXML(path, SettingFile.MENU);
        }
        return "redirect:/admin";
    }

    // menuSetting 정보 삭제
    @RequestMapping(value = "/admin/setting/menuType/{no:[0-9]+}", method = RequestMethod.DELETE)
    public String menuSettingDelete(HttpSession session, @PathVariable int no) {
        String path = session.getServletContext().getRealPath(Path.SETTING.getPath());
        settingService.removeMenuSetting(no);
        settingService.writeSettingXML(path, SettingFile.MENU);

        // 실제 프로젝트 폴더 절대 경로
        path = Path.SETTING.getLocalPath();
        if (new File(path).exists()) {
            settingService.writeSettingXML(path, SettingFile.MENU);
        }
        return "redirect:/admin";
    }

    // boardSetting 정보 요청 json 반환
    @RequestMapping(value = "/admin/setting/boardType/{no:[0-9]+}", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public BoardType boardSetting(HttpSession session, @PathVariable int no) {
        BoardSetting boardSetting = settingService.getBoardSetting();
        return boardSetting.getBoardType(no);
    }

    // boardSetting 정보 추가/수정
    @RequestMapping(value = "/admin/setting/boardType/{no:[0-9]+}", method = { RequestMethod.POST, RequestMethod.PUT })
    public String boardSettingUpdate(HttpSession session, @PathVariable int no, BoardType boardType) {
        if (no != boardType.getNo()) {
            return "redirect:/error";
        }

        String path = session.getServletContext().getRealPath(Path.SETTING.getPath());
        settingService.setBoardSetting(boardType);
        settingService.writeSettingXML(path, SettingFile.BOARD);

        // 실제 프로젝트 폴더 절대 경로
        path = Path.SETTING.getLocalPath();
        if (new File(path).exists()) {
            settingService.writeSettingXML(path, SettingFile.BOARD);
        }
        return "redirect:/admin";
    }

    // boardSetting 정보 삭제
    @RequestMapping(value = "/admin/setting/boardType/{no:[0-9]+}", method = RequestMethod.DELETE)
    public String boardSettingDelete(HttpSession session, @PathVariable int no) {
        String path = session.getServletContext().getRealPath(Path.SETTING.getPath());
        boardService.deleteBoardTX(no);
        settingService.removeBoardSetting(no);
        settingService.writeSettingXML(path, SettingFile.BOARD);

        // 실제 프로젝트 폴더 절대 경로
        path = Path.SETTING.getLocalPath();
        if (new File(path).exists()) {
            settingService.writeSettingXML(path, SettingFile.BOARD);
        }
        return "redirect:/admin";
    }
}
