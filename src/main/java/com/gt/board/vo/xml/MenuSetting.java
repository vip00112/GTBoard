package com.gt.board.vo.xml;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/** Nav 메뉴 설정 객체 **/
@XmlRootElement(name = "MenuSetting")
@XmlAccessorType(XmlAccessType.FIELD)
public class MenuSetting {
    @XmlElement(name = "MenuType") private List<MenuType> menuTypeList;

    public List<MenuType> getMenuTypeList() {
        return menuTypeList;
    }

    public void setMenuTypeList(List<MenuType> menuTypeList) {
        Collections.sort(menuTypeList, new AscCompare());
        this.menuTypeList = menuTypeList;
    }

    /** 해당 menuType 추가/수정
     *  @param menuType 게시판 정보 **/
    public void setMenuType(MenuType menuType) {
        if (menuType.getNo() == 0) { // 추가
            menuType.setNo(getNewNo());
        } else { // 수정
            removeItem(menuType.getNo());
        }
        menuType.sortSubMenuList();
        menuTypeList.add(menuType);
        Collections.sort(menuTypeList, new AscCompare());
    }

    /** 해당 no의 MenuType 반환
     *  @param typeNo MenuType.no **/
    public MenuType getMenuType(int typeNo) {
        for (MenuType menuType : menuTypeList) {
            if (menuType.getNo() == typeNo) {
                return menuType;
            }
        }
        return null;
    }

    /** 해당 no의 기존 아이템 삭제
     *  @param no 메뉴 no **/
    public void removeItem(int no) {
        for (MenuType menuType : menuTypeList) {
            if (menuType.getNo() == no) {
                menuTypeList.remove(menuType);
                break;
            }
        }
    }

    // 새로운 no 취득
    private int getNewNo() {
        int maxNo = 0;
        for (MenuType menuType : menuTypeList) {
            if (menuType.getNo() > maxNo) {
                maxNo = menuType.getNo();
            }
        }
        return maxNo += 1;
    }

    // MenuType의 order값 오름차순 정렬
    private class AscCompare implements Comparator<MenuType> {
        @Override
        public int compare(MenuType value1, MenuType value2) {
            int one = value1.getOrder();
            int two = value2.getOrder();
            return one < two ? -1 : one > two ? 1 : 0;
        }
    }
}
