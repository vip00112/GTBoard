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
	<c:param name="title"></c:param>
	<c:param name="thumbnail">${baseSetting.title} | 회원가입</c:param>
</c:import>

<title>${baseSetting.title}-회원가입</title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/join-agreement.css">

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
								 약관을 충분히 숙지 후 동의 해주세요.
		</c:param>
	</c:import>

	<%-- main article --%>
	<section>
		<div class="box step">
			<span class="now">약관 동의</span>
			<span>정보 입력</span>
			<span>이메일 인증</span>
			<span class="complete">가입 완료</span>
		</div>
		<!-- // .box.step -->

		<form action="/join/agreement" method="post" id="joinForm">
			<fieldset>
				<legend class="screen_out">회원가입 '약관 동의' 폼</legend>
				<input type="hidden" name="isAgree" />

				<div class="box">
					<input type="checkbox" id="agreement" />
					<label for="agreement">'이용약관'에 동의 합니다.</label>
					<div class="text"></div>
					<!-- // .text -->
				</div>
				<!-- // .box -->

				<div class="box">
					<input type="checkbox" id="privacy" />
					<label for="privacy">'개인정보 취급 방침'에 동의 합니다.</label>
					<div class="text"></div>
					<!-- // .text -->
				</div>
				<!-- // .box -->

				<div class="box btn">
					<a href="/index" class="btn prev">동의 하지 않습니다.</a>
					<button type="submit" class="btn next">
						<i class="fa fa-check-square-o"></i>
						동의 합니다.
					</button>
				</div>
				<!-- // .box.btn-->

				<div class="box link">
					<a href="/find/password/verify">
						<i class="fa fa-caret-right"></i>
						비밀번호 찾기
					</a>
					<a href="/login">
						<i class="fa fa-caret-right"></i>
						로그인
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
		$(".box.btn .next").click(function() {
			var agreementChecked = $("#agreement").prop("checked");
			var privactChecked = $("#privacy").prop("checked");
			if (!agreementChecked || !privactChecked) {
				alert("약관을 충분히 숙지한 후 동의 해주세요.");
				return false;
			}

			$("input[name='isAgree']").val(agreementChecked && privactChecked);
		});
	</script>
</body>

</html>