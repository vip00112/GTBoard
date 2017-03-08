package com.gt.board.vo.xml;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.gt.board.vo.Board;
import com.gt.board.vo.User;

@XmlRootElement(name = "BoardType")
@XmlAccessorType(XmlAccessType.FIELD)
public class BoardType {
    @XmlElement(name = "No") private int no; // 고유 번호
    @XmlElement(name = "Order") private int order; // 순서
    @XmlElement(name = "Name") private String name; // 게시판 이름
    @XmlElement(name = "Description") private String description; // 게시판 설명(생략 가능)
    @XmlElement(name = "Url") private String url; // 브라우저 주소창에 표기/구분 될 URL
    @XmlElement(name = "IsUse") private boolean isUse; // 게시판 사용 여부
    @XmlElement(name = "IsAnonymous") private boolean isAnonymous; // 익명 여부
    @XmlElement(name = "IsSecret") private boolean isSecret; // 비밀글 여부
    @XmlElement(name = "IsAlbum") private boolean isAlbum; // 앨범 형식 여부
    @XmlElement(name = "IsUseComment") private boolean isUseComment; // 게시판 내 댓글 사용 여부
    @XmlElement(name = "IsUseWriteCode") private boolean isUseWriteCode; // 글 작성시 자동 방지 코드 사용 여부
    @XmlElement(name = "IsUseCommentCode") private boolean isUseCommentCode; // 댓글 작성시 자동 방지 코드 사용 여부
    @XmlElement(name = "IsUseAttachFile") private boolean isUseAttachFile; // 첨부파일 사용 여부
    @XmlElement(name = "WritePoint") private int writePoint; // 글 작성시 지급 포인트
    @XmlElement(name = "CommentPoint") private int commentPoint; // 댓글 작성시 지급 포인트
    @XmlElement(name = "ThumbPoint") private int thumbPoint; // 추천 받을시 지급 포인트
    @XmlElement(name = "DownloadPoint") private int downloadPoint; // 첨부파일 다운로드시 필요한 포인트
    @XmlElement(name = "PopularThumb") private int popularThumb; // 인기글이 되기위한 추천 갯수
    @XmlElement(name = "WriteGrade") private int writeGrade; // 글 작성 가능 등급
    @XmlElement(name = "ReadGrade") private int readGrade; // 글 읽기 가능 등급
    @XmlElement(name = "CommentGrade") private int commentGrade; // 댓글 작성 가능 등급
    @XmlElement(name = "DownloadGrade") private int downloadGrade; // 첨부파일 다운로드 가능 등급
    @XmlElement(name = "AdminGrade", defaultValue = "9999") private int adminGrade; // 게시판 관리 등급: 해당 등급 이상부터 가능

    public BoardType() {
    }

    public BoardType(int no, String name, String description, String url) {
        this.no = no;
        this.name = name;
        this.description = description;
        this.url = url;
    }

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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public boolean isUse() {
        return isUse;
    }

    public void setUse(boolean isUse) {
        this.isUse = isUse;
    }

    public boolean isAnonymous() {
        return isAnonymous;
    }

    public void setAnonymous(boolean isAnonymous) {
        this.isAnonymous = isAnonymous;
    }

    public boolean isSecret() {
        return isSecret;
    }

    public void setSecret(boolean isSecret) {
        this.isSecret = isSecret;
    }

    public boolean isAlbum() {
        return isAlbum;
    }

    public void setAlbum(boolean isAlbum) {
        this.isAlbum = isAlbum;
    }

    public boolean isUseComment() {
        return isUseComment;
    }

    public void setUseComment(boolean isUseComment) {
        this.isUseComment = isUseComment;
    }

    public boolean isUseWriteCode() {
        return isUseWriteCode;
    }

    public void setUseWriteCode(boolean isUseWriteCode) {
        this.isUseWriteCode = isUseWriteCode;
    }

    public boolean isUseCommentCode() {
        return isUseCommentCode;
    }

    public void setUseCommentCode(boolean isUseCommentCode) {
        this.isUseCommentCode = isUseCommentCode;
    }

    public boolean isUseAttachFile() {
        return isUseAttachFile;
    }

    public void setUseAttachFile(boolean isUseAttachFile) {
        this.isUseAttachFile = isUseAttachFile;
    }

    public int getWritePoint() {
        return writePoint;
    }

    public void setWritePoint(int writePoint) {
        this.writePoint = writePoint;
    }

    public int getCommentPoint() {
        return commentPoint;
    }

    public void setCommentPoint(int commentPoint) {
        this.commentPoint = commentPoint;
    }

    public int getThumbPoint() {
        return thumbPoint;
    }

    public void setThumbPoint(int thumbPoint) {
        this.thumbPoint = thumbPoint;
    }

    public int getDownloadPoint() {
        return downloadPoint;
    }

    public void setDownloadPoint(int downloadPoint) {
        this.downloadPoint = downloadPoint;
    }

    public int getPopularThumb() {
        return popularThumb;
    }

    public void setPopularThumb(int popularThumb) {
        this.popularThumb = popularThumb;
    }

    public int getWriteGrade() {
        return writeGrade;
    }

    public void setWriteGrade(int writeGrade) {
        this.writeGrade = writeGrade;
    }

    public int getReadGrade() {
        return readGrade;
    }

    public void setReadGrade(int readGrade) {
        this.readGrade = readGrade;
    }

    public int getCommentGrade() {
        return commentGrade;
    }

    public void setCommentGrade(int commentGrade) {
        this.commentGrade = commentGrade;
    }

    public int getDownloadGrade() {
        return downloadGrade;
    }

    public void setDownloadGrade(int downloadGrade) {
        this.downloadGrade = downloadGrade;
    }

    public int getAdminGrade() {
        return adminGrade;
    }

    public void setAdminGrade(int adminGrade) {
        this.adminGrade = adminGrade;
    }

    /** 게시글 읽기 권한 여부 확인
     *  @param user 게시글 읽기를 시도한 유저
     *  @param board 읽으려는 게시글 **/
    public boolean isReadableBoard(User user, Board board) {
        if (!isUse) {
            return false;
        } else if (readGrade > 0 || isSecret) {
            if (user == null) {
                return false;
            }
            int grade = user.getGrade();

            // 비밀글은 등급과 상관없이 본인의 글은 읽기 가능
            if (isSecret) {
                return user.isAdmin() || grade == adminGrade || user.getNo() == board.getUserNo();
            }
            return user.isAdmin() || grade == adminGrade || grade >= readGrade;
        }
        return true;
    }

    /** 게시글 작성 권한 여부 확인
     *  @param user 게시글 작성을 시도한 유저 **/
    public boolean isWritableBoard(User user) {
        if (user == null || !isUse) {
            return false;
        }
        int grade = user.getGrade();
        return user.isAdmin() || grade == adminGrade || (grade >= readGrade && grade >= writeGrade);
    }

    /** 댓글 읽기 권한 여부 확인
     *  @param user 댓글 읽기를 시도한 유저 **/
    public boolean isReadableComment(User user) {
        if (!isUse || !isUseComment) {
            return false;
        } else if (readGrade > 0) {
            if (user == null) {
                return false;
            }
            int grade = user.getGrade();
            return user.isAdmin() || grade == adminGrade || grade >= readGrade;
        }
        return true;
    }

    /** 댓글 작성 권한 여부 확인
     *  @param user 댓글 작성을 시도한 유저 **/
    public boolean isWritableComment(User user) {
        if (user == null || !isUse || !isUseComment) {
            return false;
        }
        int grade = user.getGrade();
        return user.isAdmin() || grade == adminGrade || (grade >= readGrade && grade >= commentGrade);
    }

    /** 첨부파일 다운로드 권한 여부
     *  @param user 첨부파일 다운로드를 시도한 유저 **/
    public boolean isDownloadable(User user) {
        if (!isUse || !isUseAttachFile) {
            return false;
        } else if (readGrade > 0 || downloadPoint > 0 || downloadGrade > 0) {
            if (user == null) {
                return false;
            } else if (user.getPoint() < downloadPoint) {
                return false;
            }
            int grade = user.getGrade();
            return user.isAdmin() || grade == adminGrade || (grade >= readGrade && grade >= downloadGrade);
        }
        return true;
    }
}
