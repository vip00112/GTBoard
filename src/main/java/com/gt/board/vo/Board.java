package com.gt.board.vo;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.gt.board.vo.xml.BoardType;

public class Board {
    private int no; // 각 게시글의 고유 번호
    private int typeNo; // BoardType.no
    @JsonIgnore private int userNo; // 작성자 유저 번호
    private String nickname; // 작성자 닉네임
    private String title; // 제목
    private String content; // 내용
    @JsonIgnore private String ip; // 글 작성 IP
    private int commentCount; // 댓글 갯수
    private int hit; // 조회수
    private int thumb; // 추천수
    private boolean isNotice; // 게시판 공지 여부
    private Timestamp regdate; // 등록일자
    private Timestamp lastUpdate; // 최종 수정일자

    private BoardType boardType; // 게시판 분류
    private List<AttachFile> downloadFiles; // 다운로드 가능한 첨부파일 목록
    private String text; // HTML 태그를 제거한 내용(meta 태그 표기를 위함)
    @JsonIgnore private String captcha; // 자동 방지 코드
    @JsonIgnore private SimpleDateFormat sdf; // viewDate 표기를 위한 변수 선언

    public Board() {
    }

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public int getTypeNo() {
        return typeNo;
    }

    public void setTypeNo(int typeNo) {
        this.typeNo = typeNo;
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

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public int getHit() {
        return hit;
    }

    public void setHit(int hit) {
        this.hit = hit;
    }

    public int getThumb() {
        return thumb;
    }

    public void setThumb(int thumb) {
        this.thumb = thumb;
    }

    public boolean isNotice() {
        return isNotice;
    }

    public void setNotice(boolean isNotice) {
        this.isNotice = isNotice;
    }

    public Timestamp getRegdate() {
        return regdate;
    }

    public void setRegdate(Timestamp regdate) {
        this.regdate = regdate;
    }

    public Timestamp getLastUpdate() {
        return lastUpdate;
    }

    public void setLastUpdate(Timestamp lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

    public BoardType getBoardType() {
        return boardType;
    }

    public void setBoardType(BoardType boardType) {
        this.boardType = boardType;
    }

    public List<AttachFile> getDownloadFiles() {
        return downloadFiles;
    }

    public void setDownloadFiles(List<AttachFile> downloadFiles) {
        this.downloadFiles = downloadFiles;
    }

    public String getText() {
        return text;
    }

    public String getCaptcha() {
        return captcha;
    }

    public void setCaptcha(String captcha) {
        this.captcha = captcha;
    }

    /** 게시글 수정/삭제 권한 여부 확인
     *  @param user 게시글 수정/삭제를 시도한 유저 **/
    public boolean isEditable(User user) {
        if (user == null || boardType == null || !boardType.isWritableBoard(user)) {
            return false;
        }
        return user.isAdmin() || user.getGrade() == boardType.getAdminGrade() || user.getNo() == userNo;
    }

    /** 인기글 여부
     *  @return true:인기글, false:일반 **/
    public boolean isPopular() {
        return boardType != null && boardType.getPopularThumb() > 0 && thumb >= boardType.getPopularThumb();
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

    /** 최종 수정일자 표기(년-월-일 시:분:초)
     *  @return yyyy-MM-dd HH:mm:ss **/
    public String getViewLastUpdate() {
        if (lastUpdate == null) {
            return "-";
        }

        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(lastUpdate.getTime());
    }

    /** 첨부파일이 포함된 게시글 여부
     *  @return true:다운로드 가능한 첨부파일 있음, false:첨부파일 없음 **/
    public boolean isIncludeAttachFile() {
        return downloadFiles != null && downloadFiles.size() > 0;
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
     *  @return n:새글, h:인기글, c:댓글, f:첨부파일 포함, i:이미지 포함, v:동영상 포함 **/
    public String getTitleClass() {
        StringBuilder sb = new StringBuilder();
        if (isRecent()) {
            sb.append("n ");
        } else if (isPopular()) {
            sb.append("h ");
        }
        if (commentCount > 0) {
            sb.append("c ");
        }
        if (isIncludeAttachFile()) {
            sb.append("f ");
        }
        if (isIncludeImg()) {
            sb.append("i ");
        }
        return sb.toString().trim();
    }

}
