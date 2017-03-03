package com.gt.board.util;

public class PaginateUtil {

    public PaginateUtil() {
    }

    /** 페이지네이트  
     *  @param pageNo 현재 페이지
     *  @param total 전체 게시글 수
     *  @param numPage 페이지당 게시글 수
     *  @param numBlock 페이지 블럭 수
     *  @param url 이동될 페이지 주소
     *  @return html code **/
    public String getPaginate(int pageNo, int total, int numPage, int numBlock, String url) {
        if (total == 0) {
            return "";
        }

        int totalPage = (int) Math.ceil((double) total / numPage); // 총 페이지 수
        int totalBlock = (int) Math.ceil((double) totalPage / numBlock); // 총 블럭 수
        int nowBlock = (int) Math.ceil((double) pageNo / numBlock); // 현재 페이지 블럭

        StringBuilder sb = new StringBuilder();
        sb.append("<ul class='normal'>");
        if (pageNo > totalPage) {
            sb.append("<li><a href='" + url + "&pageNo=1' title='처음으로' data-no='1'><i class='fa fa-angle-double-left'></i></a></li>");
            sb.append("<li><a href='' class='now' title='잘못된 페이지'>" + pageNo + "</a></li>");
            sb.append("<li><a href='" + url + "&pageNo=" + totalPage + "' title='마지막 페이지' data-no='" + totalPage + "'><i class='fa fa-angle-double-right'></i></a></li>");
        } else {
            if (pageNo <= numBlock) {
                sb.append("<li><a href='' class='max' title='이전 페이지 없음'><i class='fa fa-angle-double-left'></i></a></li>");
                sb.append("<li><a href='' class='max' title='이전 페이지 없음'><i class='fa fa-angle-left'></i></a></li>");
            } else {
                int prev = ((nowBlock - 1) * numBlock);
                sb.append("<li><a href='" + url + "&pageNo=1' title='처음으로' data-no='1'><i class='fa fa-angle-double-left'></i></a></li>");
                sb.append("<li><a href='" + url + "&pageNo=" + prev + "' title='이전 " + numBlock + " 페이지' data-no='" + prev + "'><i class='fa fa-angle-left'></i></a></li>");
            }

            if (totalPage > 0) {
                for (int i = 0; i < numBlock; i++) {
                    int printNum = (nowBlock * numBlock) - (numBlock - 1) + i;

                    if (pageNo == printNum) {
                        sb.append("<li><a href='' class='page now' title='현재 페이지' data-no='" + printNum + "'>" + printNum + "</a></li>");
                    } else {
                        sb.append("<li><a href='" + url + "&pageNo=" + printNum + "' title='" + printNum + " 페이지' class='page' data-no='" + printNum + "'>" + printNum + "</a></li>");
                    }

                    if (printNum >= totalPage) {
                        break;
                    }
                }
            }

            if (nowBlock >= totalBlock) {
                sb.append("<li><a href='' class='max' title='다음 페이지 없음'><i class='fa fa-angle-right'></i></a></li>");
                sb.append("<li><a href='' class='max' title='다음 페이지 없음'><i class='fa fa-angle-double-right'></i></a></li>");
            } else {
                int next = ((nowBlock * numBlock) + 1);
                sb.append("<li><a href='" + url + "&pageNo=" + next + "' title='다음 " + numBlock + " 페이지' data-no='" + next + "'><i class='fa fa-angle-right'></i></a></li>");
                sb.append("<li><a href='" + url + "&pageNo=" + totalPage + "' title='마지막 페이지' data-no='" + totalPage + "'><i class='fa fa-angle-double-right'></i></a></li>");
            }
        }
        sb.append("</ul>");

        // Mobile
        sb.append("<ul class='mobile'>");
        if (pageNo > totalPage) {
            sb.append("<li><a href='" + url + "&pageNo=1' title='첫 페이지' data-no='1'><i class='fa fa-angle-double-left'></i></a></li>");
            sb.append("<li><a href='' class='now' title='잘못된 페이지'>" + pageNo + "</a></li>");
            sb.append("<li><a href='" + url + "&pageNo=" + totalPage + "' title='마지막 페이지' data-no='" + totalPage + "'><i class='fa fa-angle-double-right'></i></a></li>");
        } else {
            int prev = pageNo - 1;
            int next = pageNo + 1;

            if (prev < 1) {
                sb.append("<li><a href='' class='max' title='이전 페이지 없음'><i class='fa fa-angle-double-left'></i></a></li>");
                sb.append("<li><a href='' class='max' title='이전 페이지 없음'><i class='fa fa-angle-left'></i></a></li>");
            } else {
                sb.append("<li><a href='" + url + "&pageNo=1' title='첫 페이지' data-no='1'><i class='fa fa-angle-double-left'></i></a></li>");
                sb.append("<li><a href='" + url + "&pageNo=" + prev + "' title='" + prev + " 페이지' data-no='" + prev + "'><i class='fa fa-angle-left'></i></a></li>");
            }

            sb.append("<li><a href='' class='page now' title='현재 페이지' data-no='" + pageNo + "'>" + pageNo + " / " + totalPage + "</a></li>");

            if (next > totalPage) {
                sb.append("<li><a href='' class='max' title='다음 페이지 없음'><i class='fa fa-angle-right'></i></a></li>");
                sb.append("<li><a href='' class='max' title='다음 페이지 없음'><i class='fa fa-angle-double-right'></i></a></li>");
            } else {
                sb.append("<li><a href='" + url + "&pageNo=" + next + "' title='" + next + " 페이지' data-no='" + next + "'><i class='fa fa-angle-right'></i></a></li>");
                sb.append("<li><a href='" + url + "&pageNo=" + totalPage + "' title='마지막 페이지' data-no='" + totalPage + "'><i class='fa fa-angle-double-right'></i></a></li>");
            }
        }
        sb.append("</ul>");

        return sb.toString();
    }

}
