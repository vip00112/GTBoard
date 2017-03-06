package com.gt.board.vo;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Notice {
    private int no;
    private int userNo;
    private String nickname;
    private String title;
    private String content;
    private int hit;
    private Timestamp regdate;

    private String text; // HTML 태그를 제거한 내용(meta 태그 표기를 위함)
    private SimpleDateFormat sdf; // viewDate 표기를 위한 변수 선언

    public Notice() {
    }

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public int getUserNo() {
        return userNo;
    }

    public void setUserNo(int userNo) {
        this.userNo = userNo;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
        text = content.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
    }

    public int getHit() {
        return hit;
    }

    public void setHit(int hit) {
        this.hit = hit;
    }

    public Timestamp getRegdate() {
        return regdate;
    }

    public void setRegdate(Timestamp regdate) {
        this.regdate = regdate;
    }

    public String getText() {
        return text;
    }

    /** 최신글 아이콘 표기 여부
     *  @return true:작성된지 24시간 이내, false:그 외 **/
    public boolean isRecent() {
        if (regdate == null) {
            return false;
        }
        int nowTime = (int) (System.currentTimeMillis() / 1000);
        int regTime = (int) (regdate.getTime() / 1000);
        return nowTime - regTime <= 60 * 60 * 24;
    }

    /** 등록일자 표기(최신글과 일반글의 분기)
     *  @return isResent ? HH:mm:ss : yyyy-MM-dd **/
    public String getViewRegdate() {
        if (regdate == null) {
            return "-";
        }

        sdf = isRecent() ? new SimpleDateFormat("HH:mm:ss") : new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(regdate.getTime());
    }

    /** 등록일자 표기(년-월-일 시:분:초)
     *  @return yyyy-MM-dd HH:mm:ss **/
    public String getViewRegdateFull() {
        if (regdate == null) {
            return "-";
        }

        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(regdate.getTime());
    }

    /** 이미지가 포함된 게시글 여부
     *  @return true:img 태그 포함, false:미포함 **/
    public boolean isIncludeImg() {
        if (content != null) {
            Pattern p = Pattern.compile("<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>");
            Matcher m = p.matcher(content);
            return m.find();
        }
        return false;
    }

    /** 기본 썸네일 이미지 URL 취득
     *  @return noimage.png 경로**/
    public String getDefaultThumbnail() {
        return "/resources/img/noimage.png";
    }

    /** 썸네일 이미지 URL 취득
     *  @return 이미지 있을시:이미지 경로, 이미지 없을시:noimage.png 경로**/
    public String getThumbnail() {
        if (content != null) {
            Pattern p = Pattern.compile("<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>");
            Matcher m = p.matcher(content);
            if (m.find()) {
                return m.group(1);
            }
        }
        return null;
    }

    /** a태그 제목의 max-width설정을 위한 claa 표기
     *  @return n:새글, i:이미지 포함, v:동영상 포함 **/
    public String getTitleClass() {
        StringBuilder sb = new StringBuilder();
        if (isRecent()) {
            sb.append("n ");
        }
        if (isIncludeImg()) {
            sb.append("i ");
        }
        return sb.toString().trim();
    }

}
