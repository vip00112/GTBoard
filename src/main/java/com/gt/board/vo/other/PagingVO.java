package com.gt.board.vo.other;

public class PagingVO {
    private int offset; // 시작 지점
    private int limit; // 최대 갯수

    /** 페이지네이션
     *  @param pageNo 페이지 번호
     *  @param numPage 페이지당 보여줄 게시글 갯수 **/
    public PagingVO(int pageNo, int numPage) {
        offset = (pageNo * numPage) - numPage;
        limit = numPage;
    }

    public int getOffset() {
        return offset;
    }

    public int getLimit() {
        return limit;
    }
}
