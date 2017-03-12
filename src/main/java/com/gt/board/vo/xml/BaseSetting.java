package com.gt.board.vo.xml;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/** 사이트 기본 정보 설정 객체 **/
@XmlRootElement(name = "BaseSetting")
@XmlAccessorType(XmlAccessType.FIELD)
public class BaseSetting {
    @XmlElement(name = "Title") private String title; // 사이트 이름: title, meta, footer
    @XmlElement(name = "Logo") private String logo; // 로고 이미지 경로
    @XmlElement(name = "Author") private String author; // 사이트 제작자: meta
    @XmlElement(name = "Reply") private String reply; // 사이트 제작자 이메일: meta
    @XmlElement(name = "Keyword") private String keyword; // 사이트 키워드: meta
    @XmlElement(name = "Description") private String description; // 사이트 설명: meta
    @XmlElement(name = "BusinessName") private String businessName; // 회사명(상호명): footer
    @XmlElement(name = "BusinessNumber") private String businessNumber; // 사업자 등록 번호: footer
    @XmlElement(name = "Ceo") private String ceo; // 대표자 성명: footer
    @XmlElement(name = "Address") private String address; // 사업지 주소: footer
    @XmlElement(name = "Tel") private String tel; // 연락처: footer
    @XmlElement(name = "Fax") private String fax; // 팩스: footer
    @XmlElement(name = "Email") private String email; // 이메일: footer
    @XmlElement(name = "StartYear") private String startYear; // 설립년도: footer
    @XmlElement(name = "IndexViewCount") private int indexViewCount; // index 페이지에 보여질 공지사항, 각 게시판별 최신글 갯수
    @XmlElement(name = "IndexViewCountTotal") private int indexViewCountTotal; // index 페이지에 보여질 전체 게시판 최신글 갯수

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getBusinessNumber() {
        return businessNumber;
    }

    public void setBusinessNumber(String businessNumber) {
        this.businessNumber = businessNumber;
    }

    public String getCeo() {
        return ceo;
    }

    public void setCeo(String ceo) {
        this.ceo = ceo;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStartYear() {
        return startYear;
    }

    public void setStartYear(String startYear) {
        this.startYear = startYear;
    }

    public int getIndexViewCount() {
        return indexViewCount;
    }

    public void setIndexViewCount(int indexViewCount) {
        this.indexViewCount = indexViewCount;
    }

    public int getIndexViewCountTotal() {
        return indexViewCountTotal;
    }

    public void setIndexViewCountTotal(int indexViewCountTotal) {
        this.indexViewCountTotal = indexViewCountTotal;
    }
}
