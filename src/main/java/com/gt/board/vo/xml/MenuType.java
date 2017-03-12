package com.gt.board.vo.xml;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "MenuType")
@XmlAccessorType(XmlAccessType.FIELD)
public class MenuType {
    @XmlAttribute(name = "No") private int no; // 고유 번호
    @XmlAttribute(name = "Order") private int order; // 순서
    @XmlAttribute(name = "Name") private String name; // 메뉴 이름
    @XmlAttribute(name = "Url") private String url; // 이동될 URL
    @XmlElement(name = "SubMenu") private List<MenuTypeSub> subMenuList;

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public List<MenuTypeSub> getSubMenuList() {
        return subMenuList;
    }

    public void setSubMenuList(List<MenuTypeSub> subMenuList) {
        Collections.sort(subMenuList, new AscCompare());
        this.subMenuList = subMenuList;
    }

    /** MenuTypeSub List를 order값 정렬 **/
    public void sortSubMenuList() {
        if (subMenuList != null) {
            Collections.sort(subMenuList, new AscCompare());
        }
    }

    // MenuType의 order값 오름차순 정렬
    private class AscCompare implements Comparator<MenuTypeSub> {
        @Override
        public int compare(MenuTypeSub value1, MenuTypeSub value2) {
            int one = value1.getOrder();
            int two = value2.getOrder();
            return one < two ? -1 : one > two ? 1 : 0;
        }
    }
}
