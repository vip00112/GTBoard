<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8" />

<%-- meta Template --%>
<c:import url="template/meta.jsp">
	<c:param name="author"></c:param>
	<c:param name="reply"></c:param>
	<c:param name="keyword"></c:param>
	<c:param name="description"></c:param>
	<c:param name="robots"></c:param>
	<c:param name="ogType"></c:param>
	<c:param name="title"></c:param>
	<c:param name="thumbnail"></c:param>
</c:import>

<title>${baseSetting.title}</title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/index.css">

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
	<c:import url="template/wide-paper.jsp"></c:import>

	<%-- main article --%>
	<section class="notice">
		<div class="board_frame notice">
			<h3>
				<a href="/notice" title="클릭시 전체 보기">
					<i class="fa fa-caret-right"></i>
					공지사항
				</a>
			</h3>

			<ul class="line top">
				<li class="no">번호</li>
				<li class="title">제목</li>
				<li class="nickname">글쓴이</li>
				<li class="date">작성일</li>
				<li class="hit">조회</li>
			</ul>

			<div class="box_item">
				<c:choose>
					<c:when test="${fn:length(noticeList) > 0}">
						<c:forEach items="${noticeList}" var="notice">
							<ul class="line item">
								<li class="no">${notice.no}</li>
								<li class="title" title=<c:out value="${notice.title}"/>>
									<c:if test="${notice.recent}">
										<span class="new" title="신규 글"></span>
									</c:if>
									<a href="/notice/${notice.no}" class="${notice.titleClass}">
										<c:out value="${notice.title}" />
									</a>
									<c:if test="${notice.includeImg}">
										<span class="image" title="이미지 포함"></span>
									</c:if>
									<c:if test="${notice.includeVideo}">
										<span class="video" title="동영상 포함"></span>
									</c:if>
								</li>
								<li class="nickname">${notice.nickname}</li>
								<li class="date" title="${notice.viewRegdateFull}">${notice.viewRegdate}</li>
								<li class="hit">${notice.hit}</li>
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
		</div>
		<!-- // .board_frame.notice -->
	</section>

	<section class="all">
		<div class="board_frame all">
			<h3>
				<a href="/board/all" title="클릭시 전체 보기">
					<i class="fa fa-caret-right"></i>
					전체 게시판
				</a>
			</h3>

			<ul class="line top">
				<li class="type">구분</li>
				<li class="no">번호</li>
				<li class="title">제목</li>
				<li class="nickname">글쓴이</li>
				<li class="date">작성일</li>
				<li class="hit">조회</li>
				<li class="thumb">추천</li>
			</ul>

			<div class="box_item">
				<c:choose>
					<c:when test="${fn:length(boardList['0']) > 0}">
						<c:forEach items="${boardList['0']}" var="board">
							<ul class="line item">
								<li class="type">
									<a href="/board/${board.boardType.url}">${board.boardType.name}</a>
								</li>
								<li class="no">${board.no}</li>
								<li class="title <c:if test="${board.popular}">popular</c:if>" title="<c:out value="${board.title}"/>">
									<c:choose>
										<c:when test="${board.recent}">
											<span class="new" title="신규 글"></span>
										</c:when>
										<c:when test="${board.popular}">
											<span class="hot" title="인기 글"></span>
										</c:when>
									</c:choose>
									<a href="/board/${board.no}" class="${board.titleClass}">
										<c:out value="${board.title}" />
									</a>
									<c:if test="${board.boardType.useAttachFile && board.includeAttachFile}">
										<span class="file" title="첨부파일 포함"></span>
									</c:if>
									<c:if test="${board.includeImg}">
										<span class="image" title="이미지 포함"></span>
									</c:if>
									<c:if test="${board.includeVideo}">
										<span class="video" title="동영상 포함"></span>
									</c:if>
									<c:if test="${board.boardType.useComment && board.commentCount > 0}">
										<span class="count_comment" title="댓글 수">${board.commentCount}</span>
									</c:if>
								</li>
								<li class="nickname">${board.nickname}</li>
								<li class="date" title="${board.viewRegdateFull}">${board.viewRegdate}</li>
								<li class="hit">${board.hit}</li>
								<li class="thumb">${board.thumb}</li>
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
		</div>
		<!-- // .board_frame -->
	</section>

	<c:forEach items="${useableBoardTypeList}" var="boardType" varStatus="status">
		<section class="normal">
			<div class="board_frame ${boardType.url}">
				<h3>
					<a href="/board/${boardType.url}" title="클릭시 전체 보기">
						<i class="fa fa-caret-right"></i>
						${boardType.name}
					</a>
				</h3>

				<ul class="line top">
					<li class="no">번호</li>
					<li class="title">제목</li>
					<li class="nickname">글쓴이</li>
					<li class="date">작성일</li>
					<li class="hit">조회</li>
					<li class="thumb">추천</li>
				</ul>

				<div class="box_item">
					<c:set var="typeNo">${boardType.no}</c:set>
					<c:choose>
						<c:when test="${fn:length(boardList[typeNo]) > 0}">
							<c:forEach items="${boardList[typeNo]}" var="board">
								<ul class="line item">
									<li class="no">${board.no}</li>
									<li class="title <c:if test="${board.popular}">popular</c:if>" title=<c:out value="${board.title}"/>>
										<c:choose>
											<c:when test="${board.recent}">
												<span class="new" title="신규 글"></span>
											</c:when>
											<c:when test="${board.popular}">
												<span class="hot" title="인기 글"></span>
											</c:when>
										</c:choose>
										<a href="/board/${board.no}?url=${board.boardType.url}" class="${board.titleClass}">
											<c:out value="${board.title}" />
										</a>
										<c:if test="${board.boardType.useAttachFile && board.includeAttachFile}">
											<span class="file" title="첨부파일 포함"></span>
										</c:if>
										<c:if test="${board.includeImg}">
											<span class="image" title="이미지 포함"></span>
										</c:if>
										<c:if test="${board.includeVideo}">
											<span class="video" title="동영상 포함"></span>
										</c:if>
										<c:if test="${board.boardType.useComment && board.commentCount > 0}">
											<span class="count_comment" title="댓글 수">${board.commentCount}</span>
										</c:if>
									</li>
									<li class="nickname">${board.nickname}</li>
									<li class="date" title="${board.viewRegdateFull}">${board.viewRegdate}</li>
									<li class="hit">${board.hit}</li>
									<li class="thumb">${board.thumb}</li>
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
			</div>
			<!-- // .board_frame -->
		</section>
	</c:forEach>
	<%-- // main article --%>

	<%-- footer Template --%>
	<c:import url="template/footer.jsp"></c:import>

	<script>
		
	</script>

	<!-- IE 10 미만 브라우저에 알림 -->
	<!--[if lt IE 10]>
        <script>
        	var msg = "저희 사이트는 IE 10이상 또는 크롬 브라우저에 최적화 되어 있습니다.";
        	msg += "\n사이트 이용이 원할하지 않을시 IE 버전 업그레이드 또는 크롬 브라우저를 이용해주세요.";
        	msg += "\n\n";
        	msg += "본 알림창은 IE 10 미만 브라우저에서만 표기 됩니다.";
        	alert(msg);
        </script>
    <![endif]-->
</body>

</html>