package com.gt.board.vo.xml;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/** 게시판 설정 객체 **/
@XmlRootElement(name = "BoardSetting")
@XmlAccessorType(XmlAccessType.FIELD)
public class BoardSetting {
    @XmlElement(name = "BoardType") private List<BoardType> boardTypeList;

    public List<BoardType> getBoardTypeList() {
        return boardTypeList;
    }

    public void setBoardTypeList(List<BoardType> boardTypeList) {
        Collections.sort(boardTypeList, new AscCompare());
        this.boardTypeList = boardTypeList;
    }

    /** 해당 boardType 추가/수정
     *  @param boardType 게시판 정보 **/
    public void setBoardType(BoardType boardType) {
        if (boardType.getNo() == 0) { // 추가
            boardType.setNo(getNewNo());
        } else { // 수정
            removeItem(boardType.getNo());
        }
        boardTypeList.add(boardType);
        Collections.sort(boardTypeList, new AscCompare());
    }

    /** 해당 no의 BoardType 반환
     *  @param typeNo BoardType.no **/
    public BoardType getBoardType(int typeNo) {
        for (BoardType boardType : boardTypeList) {
            if (boardType.getNo() == typeNo) {
                return boardType;
            }
        }
        return null;
    }

    /** 해당 url의 BoardType 반환
     *  @param url BoardType.url **/
    public BoardType getBoardType(String url) {
        for (BoardType boardType : boardTypeList) {
            if (boardType.getUrl().equals(url)) {
                return boardType;
            }
        }
        return null;
    }

    /** 해당 no의 기존 아이템 삭제
     *  @param no 게시판 no **/
    public void removeItem(int no) {
        for (BoardType boardType : boardTypeList) {
            if (boardType.getNo() == no) {
                boardTypeList.remove(boardType);
                break;
            }
        }
    }

    // 새로운 no 취득
    private int getNewNo() {
        int maxNo = 0;
        for (BoardType boardType : boardTypeList) {
            if (boardType.getNo() > maxNo) {
                maxNo = boardType.getNo();
            }
        }
        return maxNo += 1;
    }

    // BoardType의 order값 오름차순 정렬
    private class AscCompare implements Comparator<BoardType> {
        @Override
        public int compare(BoardType value1, BoardType value2) {
            int one = value1.getMainOrder();
            int two = value2.getMainOrder();
            return one < two ? -1 : one > two ? 1 : 0;
        }
    }

}
