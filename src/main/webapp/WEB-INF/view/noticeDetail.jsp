<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8" />

<%-- meta Template --%>
<c:import url="template/meta.jsp">
	<c:param name="author">${notice.nickname}</c:param>
	<c:param name="reply">-</c:param>
	<c:param name="keyword"></c:param>
	<c:param name="description">
		<c:out value="${notice.text}" />
	</c:param>
	<c:param name="robots"></c:param>
	<c:param name="ogType">article</c:param>
	<c:param name="title">${baseSetting.title} | <c:out value="${board.title}" />
	</c:param>
	<c:param name="thumbnail">${notice.thumbnail}</c:param>
</c:import>

<title>${baseSetting.title}-<c:out value="${notice.title}" /></title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/noticeDetail.css">
<link rel="stylesheet" href="/ckeditor/plugins/prism/lib/prism/prism_patched.min.css">

<%-- IE8 이하 link Template --%>
<c:import url="template/ltIE9.jsp"></c:import>

<style>
</style>
</head>

<body>
	<%-- top template --%>
	<c:import url="template/top.jsp"></c:import>

	<%-- header Template --%>
	<c:import url="template/header.jsp"></c:import>

	<%-- wide-paper Template --%>
	<c:import url="template/wide-paper.jsp">
		<c:param name="pageTitle">공지사항</c:param>
		<c:param name="pageDesc">${baseSetting.title}의 새로운 소식과 공지사항 입니다.</c:param>
	</c:import>

	<%-- main article --%>
	<section>
		<div class="box title">
			<dl>
				<dt>제목</dt>
				<dd class="title" title="<c:out value="${notice.title}"/>">
					<c:out value="${notice.title}" />
				</dd>

				<dt>글쓴이</dt>
				<dd class="nickname">${notice.nickname}</dd>

				<dt>작성일</dt>
				<dd class="date">${notice.viewRegdateFull}</dd>

				<dt>조회</dt>
				<dd class="hit">${notice.hit}</dd>
			</dl>
		</div>
		<!-- // .box.title -->

		<div class="box content">
			<article class="text">${notice.content}</article>
			<!-- // .text -->
		</div>
		<!-- // .box.content -->

		<div class="box button">
			<c:if test="${loginUser != null && loginUser.admin}">
				<a href="/notice/${notice.no}/update" class="btn update">
					<i class="fa fa-pencil"></i>
					수정
				</a>
				<form action="/notice/${notice.no}/delete" method="post" class="form_delete">
					<fieldset>
						<legend class="screen_out">게시글 삭제 폼</legend>
						<input type="hidden" name="_method" value="DELETE" />
						<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

						<button class="btn delete">
							<i class="fa fa-trash"></i>
							삭제
						</button>
					</fieldset>
				</form>
			</c:if>
			<a href="/notice?order=${order}&searchType=${searchType}&search=${search}&numPage=${numPage}&pageNo=${pageNo}" class="btn list">
				<i class="fa fa-bars"></i>
				목록
			</a>
		</div>
		<!-- // .box.button -->
	</section>

	<section>
		<div class="board_frame notice">
			<div class="box_option">
				<div class="view_count option">
					<ul title="게시글 갯수">
						<li data-value="10" <c:if test="${numPage == 10}">class="on"</c:if>>10개</li>
						<li data-value="30" <c:if test="${numPage == 30}">class="on"</c:if>>30개</li>
						<li data-value="50" <c:if test="${numPage == 50}">class="on"</c:if>>50개</li>
					</ul>
				</div>
				<!-- // .view_count -->

				<div class="view_order option">
					<ul title="게시글 정렬">
						<li data-value="regdate_DESC" <c:if test="${order eq 'regdate_DESC'}">class="on"</c:if>>최신순</li>
						<li data-value="hit_DESC" <c:if test="${order eq 'hit_DESC'}">class="on"</c:if>>조회순</li>
					</ul>
				</div>
				<!-- // .view_order-->
			</div>
			<!-- // .box_option -->

			<ul class="line top">
				<li class="no">번호</li>
				<li class="title">제목</li>
				<li class="nickname">글쓴이</li>
				<li class="date">작성일</li>
				<li class="hit">조회</li>
			</ul>

			<div class="box_item">
				<c:choose>
					<c:when test="${fn:length(boardList) > 0}">
						<c:set var="boardNo">${notice.no}</c:set>
						<c:forEach items="${boardList}" var="board">
							<ul class="line item <c:if test="${board.no == boardNo}">now</c:if>">
								<li class="no">
									<c:choose>
										<c:when test="${board.no == boardNo}">
											<i class="fa fa-caret-right"></i>
										</c:when>
										<c:otherwise>${board.no}</c:otherwise>
									</c:choose>
								</li>
								<li class="title" title="<c:out value="${board.title}"/>">
									<c:if test="${board.recent}">
										<span class="new" title="신규 글"></span>
									</c:if>
									<a href="/notice/${board.no}?order=${order}&searchType=${searchType}&search=${search}&numPage=${numPage}&pageNo=${pageNo}" class="${board.titleClass}">
										<c:out value="${board.title}" />
									</a>
									<c:if test="${board.includeImg}">
										<span class="image" title="이미지 포함"></span>
									</c:if>
									<c:if test="${board.includeVideo}">
										<span class="video" title="동영상 포함"></span>
									</c:if>
								</li>
								<li class="nickname">${board.nickname}</li>
								<li class="date" title="${board.viewRegdateFull}">${board.viewRegdate}</li>
								<li class="hit">${board.hit}</li>
							</ul>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<ul class="line item">
							<li class="w100per">등록된 글이 없습니다.</li>
						</ul>
					</c:otherwise>
				</c:choose>
			</div>
			<!-- // .box_item -->

			<div class="box_link">
				<a href="/board/${boardType.url}" class="all">
					<i class="fa fa-bars"></i>
					목록
				</a>
				<c:if test="${loginUser != null && loginUser.admin}">
					<a href="/notice/write" class="write">
						<i class="fa fa-pencil"></i>
						글 작성
					</a>
				</c:if>
			</div>
			<!-- // .box_bottom -->

			<div class="paginate">${paginateHtml}</div>
			<!-- // .paginate -->

			<form action="/notice" class="form_search" method="get">
				<fieldset>
					<legend class="screen_out">검색 폼</legend>

					<input type="hidden" name="pageNo" />
					<input type="hidden" name="numPage" />
					<input type="hidden" name="order" />

					<select name="searchType">
						<option value="title" <c:if test="${searchType eq 'title'}">selected</c:if>>글 제목</option>
						<option value="content" <c:if test="${searchType eq 'content'}">selected</c:if>>글 내용</option>
						<option value="title_content" <c:if test="${searchType eq 'title_content'}">selected</c:if>>글 제목 + 글 내용</option>
					</select>
					<div class="box search">
						<input type="search" name="search" value="${search}" placeholder="검색어" />
					</div>
					<button type="submit" class="btn search">
						<i class="fa fa-search"></i>
					</button>
				</fieldset>
			</form>
		</div>
		<!-- // .board_frame -->
	</section>
	<%-- // main article --%>

	<%-- footer Template --%>
	<c:import url="template/footer.jsp"></c:import>

	<!-- CKEditor CodeSnippet Plugin -->
	<script src="/ckeditor/plugins/prism/lib/prism/prism_patched.min.js"></script>

	<script>
		// 페이지네이트 설정
		var boardPaginate = new Paginate(".board_frame .paginate");

		$(".form_delete").submit(function() {
			if (!confirm("해당 게시글을 정말 삭제 하시겠습니까?")) {
				return false;
			}
		});
	</script>
</body>

</html>