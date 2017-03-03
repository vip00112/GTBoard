package com.gt.board.vo.other;

public class PagingVO {
    private int start;
    private int end;

    public PagingVO() {
    }

    public PagingVO(int pageNo, int numPage) {
        end = pageNo * numPage;
        start = end - numPage;
        end = numPage;
    }

    public int getStart() {
        return start;
    }

    public void setStart(int start) {
        this.start = start;
    }

    public int getEnd() {
        return end;
    }

    public void setEnd(int end) {
        this.end = end;
    }
}
