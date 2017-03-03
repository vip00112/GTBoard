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
	<c:param name="description">이메일 인증 후 새로운 비밀번호로 변경</c:param>
	<c:param name="robots"></c:param>
	<c:param name="ogType"></c:param>
	<c:param name="title">${baseSetting.title} | 비밀번호찾기</c:param>
	<c:param name="thumbnail"></c:param>
</c:import>

<title>${baseSetting.title}-비밀번호찾기</title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/findPassword-verify.css">

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
		<c:param name="pageTitle">비밀번호 찾기</c:param>
		<c:param name="pageDesc">이메일 인증 후 새로운 비밀번호로 변경</c:param>
	</c:import>

	<%-- main article --%>
	<section>
		<div class="main loading"></div>
		<!-- // .loading -->

		<form action="/find/password/verify" id="findForm" method="post">
			<fieldset>
				<legend class="screen_out">비밀번호 찾기 폼</legend>

				<div class="box email">
					<label for="email">이메일</label>
					<input type="text" id="email" name="email" autofocus autocomplete="off" required />
				</div>
				<!-- // .box.email -->

				<div class="box captcha">
					<div class="loading"></div>
					<!-- // .loading -->

					<label for="captcha">자동 방지 코드</label>
					<div class="variable">
						<input type="text" id="captcha" name="captcha" autocomplete="off" required />
					</div>
					<img src="/captcha" alt="캡차 이미지" title="클릭시 새로고침" />
				</div>
				<!-- // .box.captcha -->

				<div class="box btn">
					<button type="submit">
						<i class="fa fa-envelope"></i>
						인증 코드 받기
					</button>
				</div>
				<!-- // .box.btn -->

				<div class="box link">
					<a href="/login">
						<i class="fa fa-caret-right"></i>
						로그인
					</a>
					<a href="/join/agreement">
						<i class="fa fa-caret-right"></i>
						회원가입
					</a>
				</div>
				<!-- // .box.link -->
			</fieldset>
		</form>
	</section>
	<%-- // main article --%>

	<%-- footer Template --%>
	<c:import url="template/footer.jsp"></c:import>

	<script>
		var working = false;

		$("#findForm").submit(function() {
			if (working) {
				return false;
			}
			working = true;

			$(".main.loading").show();
		});

		// captcha 새로고침
		$(".box.captcha img").click(function() {
			if (working) {
				return false;
			}
			var $loader = $(this).siblings(".loading");
			$loader.show();
			$(this).attr("src", "/captcha?ran=" + Math.random());
			$loader.fadeOut(500);
		});
	</script>
</body>

</html>