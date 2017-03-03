<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8" />

<%-- meta Template --%>
<c:import url="template/meta.jsp">
	<c:param name="author"></c:param>
	<c:param name="reply"></c:param>
	<c:param name="keyword"></c:param>
	<c:param name="description">'${baseSetting.title}'의 회원으로 가입합니다.</c:param>
	<c:param name="robots"></c:param>
	<c:param name="ogType"></c:param>
	<c:param name="title">${baseSetting.title} | 회원가입</c:param>
	<c:param name="thumbnail"></c:param>
</c:import>

<title>${baseSetting.title}-회원가입</title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/join-verify.css">

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
		<c:param name="pageTitle">신규 회원 가입</c:param>
		<c:param name="pageDesc">'${baseSetting.title}'의 회원으로 가입합니다.<br />
			<br />
								 이메일 인증 후 계정이 활성화 됩니다.
		</c:param>
	</c:import>

	<%-- main article --%>
	<section>
		<div class="main loading"></div>
		<!-- // .loading -->

		<div class="box step">
			<span class="clear">약관 동의</span>
			<span class="clear">정보 입력</span>
			<span class="now">이메일 인증</span>
			<span class="complete">가입 완료</span>
		</div>
		<!-- // .box.step -->

		<div class="box msg">
			<p class="email">${loginUser.email}</p>
			<p class="nickname">${loginUser.nickname}</p>
			<p>입력하신 회원 정보가 저장 되었습니다.</p>
			<p>이메일 인증을 완료해야 계정이 활성화 됩니다.</p>
			<p>계정 활성화 단계는 입력하신 회원정보로 로그인시 언제든지 가능 합니다.</p>
			<p>&nbsp;</p>
			<p>'인증 코드 받기'를 클릭 하시면 귀하의 이메일로 인증 코드가 발송 됩니다.</p>
		</div>
		<!-- // .box.msg -->

		<form action="/join/verify" method="post" id="joinForm">
			<fieldset>
				<legend class="screen_out">회원가입 '코드 받기' 폼</legend>
				<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

				<div class="box captcha">
					<div class="loading"></div>
					<!-- // .loading -->

					<label for="captcha">자동방지 코드</label>
					<div class="variable">
						<input type="text" id="captcha" name="captcha" autocomplete="off" required />
					</div>
					<img src="/captcha" alt="캡차 이미지" title="클릭시 새로고침" />
				</div>
				<!-- // .box.captcha -->

				<div class="box btn">
					<button type="submit" class="btn">
						<i class="fa fa-envelope"></i>
						인증 코드 받기
					</button>
				</div>
				<!-- // .box.btn-->
			</fieldset>
		</form>
	</section>
	<%-- // main article --%>

	<%-- footer Template --%>
	<c:import url="template/footer.jsp"></c:import>

	<script>
		var working = false;

		$("#joinForm").submit(function() {
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