package com.gt.board.vo.xml;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "SubMenu")
@XmlAccessorType(XmlAccessType.FIELD)
public class MenuTypeSub {
    @XmlElement(name = "Order") private int order; // 순서
    @XmlElement(name = "Name") private String name; // 메뉴 이름
    @XmlElement(name = "Url") private String url; // 이동될 URL

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
}
