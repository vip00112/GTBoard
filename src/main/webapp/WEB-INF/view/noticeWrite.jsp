<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8" />

<%-- meta Template --%>
<c:import url="template/meta.jsp">
	<c:param name="author"></c:param>
	<c:param name="reply"></c:param>
	<c:param name="keyword"></c:param>
	<c:param name="description">${baseSetting.title}의 새로운 소식과 공지사항 입니다.</c:param>
	<c:param name="robots">noindex, nofollow</c:param>
	<c:param name="ogType"></c:param>
	<c:param name="title">${baseSetting.title} | 공지사항</c:param>
	<c:param name="thumbnail"></c:param>
</c:import>

<title>${baseSetting.title}-공지사항</title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/noticeWrite.css">
<link rel="stylesheet" href="/resources/css/global/jquery-ui-timepicker-addon.css" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />

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
		<c:choose>
			<%-- 글 작성 --%>
			<c:when test="${type eq 'write'}">
				<form action="/notice/write" id="writeForm" method="post">
					<fieldset>
						<legend class="screen_out">공지사항 작성 폼</legend>
						<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

						<div class="box title">
							<label for="title">제목</label>
							<div class="variable">
								<input type="text" id="title" name="title" autofocus autocomplete="off" required />
							</div>
						</div>
						<!-- // .box.title -->

						<div class="box content">
							<textarea name="content" id="editor"></textarea>
						</div>
						<!-- // .box.content -->

						<div class="box button">
							<a href="/notice" class="btn cancel">취소</a>
							<button type="submit" class="btn write">작성 완료</button>
						</div>
					</fieldset>
				</form>
			</c:when>

			<%-- 글 수정 --%>
			<c:when test="${type eq 'update'}">
				<form action="/notice/${notice.no}/update" id="writeForm" method="post">
					<fieldset>
						<legend class="screen_out">공지사항 수정 폼</legend>
						<input type="hidden" name="_method" value="PUT" />
						<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

						<div class="box admin">
							<div class="line hit">
								<label for="hit">조회수</label>
								<div class="variable">
									<input value="${notice.hit}" type="text" id="hit" name="hit" autocomplete="off" required />
								</div>
							</div>
							<!-- // .line -->

							<div class="line regdate">
								<label for="regdate">작성일자</label>
								<div class="variable">
									<input value="${notice.viewRegdateFull}" type="text" id="regdate" name="regdate" readonly autocomplete="off" required />
								</div>
							</div>
							<!-- // .line -->
						</div>
						<!-- // .box.admin -->

						<div class="box title">
							<label for="title">제목</label>
							<div class="variable">
								<input value="<c:out value="${notice.title}" />" type="text" id="title" name="title" autofocus autocomplete="off" required />
							</div>
						</div>
						<!-- // .box.title -->

						<div class="box content">
							<textarea name="content" id="editor"><c:out value="${notice.content}" /></textarea>
						</div>
						<!-- // .box.content -->

						<div class="box button">
							<a href="/notice/${notice.no}" class="btn cancel">취소</a>
							<button type="submit" class="btn write">수정 완료</button>
						</div>
					</fieldset>
				</form>
			</c:when>

			<%-- 글 작성 --%>
			<c:otherwise>
				<h2>요청이 올바르지 않습니다.</h2>
			</c:otherwise>
		</c:choose>
	</section>
	<%-- // main article --%>

	<%-- footer Template --%>
	<c:import url="template/footer.jsp"></c:import>

	<%-- CKEditor 설정 --%>
	<script src="/ckeditor/ckeditor.js" charset="utf-8"></script>
	<script src="/resources/js/ckeditor.js"></script>
	<script>
		$(window).load(function() {
			createCKEditor("File");
		});
	</script>

	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
	<script src="/resources/js/jquery-ui-timepicker.min.js"></script>

	<script>
		// 작성일자 datepicket 설정
		$("#regdate").datetimepicker({
			dateFormat: 'yy-mm-dd',
			monthNamesShort: [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
			dayNamesMin: [ '일', '월', '화', '수', '목', '금', '토' ],
			changeMonth: true,
			changeYear: true,
			showMonthAfterYear: true,

			// timepicker 설정
			timeFormat: 'HH:mm:ss',
			controlType: 'select',
			oneLine: true,
		});
	</script>
</body>

</html>