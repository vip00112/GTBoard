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
	<c:param name="description">회원가입시 입력한 이메일과 비밀번호로 로그인</c:param>
	<c:param name="robots"></c:param>
	<c:param name="ogType"></c:param>
	<c:param name="title">${baseSetting.title} | 로그인</c:param>
	<c:param name="thumbnail"></c:param>
</c:import>

<title>${baseSetting.title}-로그인</title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/login.css">

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
		<c:param name="pageTitle">로그인</c:param>
		<c:param name="pageDesc">회원가입시 입력한 이메일과 비밀번호로 로그인</c:param>
	</c:import>

	<%-- main article --%>
	<section>
		<form action="/login" method="post" id="loginForm">
			<fieldset>
				<legend class="screen_out">로그인 폼</legend>

				<div class="box email">
					<label for="email">이메일</label>
					<input type="text" id="email" name="email" autofocus autocomplete="off" required />
				</div>
				<!-- // .box.email -->

				<div class="box password">
					<label for="password">비밀번호</label>
					<input type="password" id="password" name="password" autocomplete="off" required />
				</div>
				<!-- // .box.password -->

				<div class="box btn">
					<button type="submit">
						<i class="fa fa-sign-in"></i>
						로그인
					</button>
				</div>
				<!-- // .box.btn-->

				<div class="box link">
					<a href="/find/password/verify">
						<i class="fa fa-caret-right"></i>
						비밀번호 찾기
					</a>
					<a href="/join/agreement">
						<i class="fa fa-caret-right"></i>
						회원가입
					</a>
				</div>
				<!-- // .box.link -->
			</fieldset>
		</form>
		<form action="/login" method="post" id="hiddenForm">
			<fieldset>
				<input type="hidden" name="email" />
				<input type="hidden" name="password" />
			</fieldset>
		</form>
	</section>
	<%-- // main article --%>

	<%-- footer Template --%>
	<c:import url="template/footer.jsp"></c:import>

	<script src="/resources/js/rsa/jsbn.js"></script>
	<script src="/resources/js/rsa/prng4.js"></script>
	<script src="/resources/js/rsa/rng.js"></script>
	<script src="/resources/js/rsa/rsa.js"></script>

	<script>
		var $email = $("#hiddenForm input[name='email']");
		var $password = $("#hiddenForm input[name='password']");

		var rsa = new RSAKey();
		rsa.setPublic("${modulus}", "${exponent}");

		$("#loginForm").submit(function(e) {
			e.preventDefault();

			var email = $(this).find("#email").val();
			var password = $(this).find("#password").val();
			$email.val(rsa.encrypt(email));
			$password.val(rsa.encrypt(password));
			$("#hiddenForm").submit();
		});
	</script>
</body>

</html>