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
<link rel="stylesheet" href="/resources/css/skin/join-complete.css">

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
		<c:param name="pageDesc">'${baseSetting.title}'의 회원으로 가입합니다.</c:param>
	</c:import>

	<%-- main article --%>
	<section>
		<div class="box step">
			<span class="clear">약관 동의</span>
			<span class="clear">정보 입력</span>
			<span class="clear">이메일 인증</span>
			<span class="complete now">가입 완료</span>
		</div>
		<!-- // .box.step -->

		<c:choose>
			<%-- 인증 완료 상태 --%>
			<c:when test="${loginUser.active}">
				<div class="box complete">
					<div class="box msg">
						<p class="email">${loginUser.email}</p>
						<p class="nickname">${loginUser.nickname}</p>
						<p>귀하의 계정이 활성화 되었습니다.</p>
						<p>회원 정보 관리 및 변경은 상단 메뉴에서 가능 합니다.</p>
					</div>
					<!-- // .box.msg -->

					<div class="box btn">
						<a href="/login" class="btn">
							<i class="fa fa-home"></i>
							메인 페이지 이동
						</a>
					</div>
					<!-- // .box.btn-->
				</div>
				<!-- // .box.complete -->
			</c:when>

			<%-- 인증 코드 확인 --%>
			<c:otherwise>
				<form action="/join/complete" method="post" id="joinForm">
					<fieldset>
						<legend class="screen_out">회원가입 '이메일 인증' 폼</legend>
						<input type="hidden" name="CSRFToken" value="${CSRFToken}" />
						<input type="hidden" name="_method" value="PUT" />

						<div class="box code">
							<label for="code">이메일 인증 코드</label>
							<input type="text" id="code" name="joinCode" autocomplete="off" required />
						</div>
						<!-- // .box.code -->

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
								<i class="fa fa-unlock"></i>
								계정 활성화
							</button>
						</div>
						<!-- .box.btn -->

						<div class="box link">
							<a href="#">
								<i class="fa fa-envelope"></i>
								인증 코드 다시 받기
							</a>
						</div>
						<!-- // .box.link -->
					</fieldset>
				</form>
				<form action="/join/complete" method="post" id="hiddenForm">
					<fieldset>
						<input type="hidden" name="CSRFToken" value="${CSRFToken}" />
						<input type="hidden" name="_method" value="PUT" />
						<input type="hidden" name="joinCode" />
						<input type="hidden" name="captcha" />
					</fieldset>
				</form>
			</c:otherwise>
		</c:choose>
	</section>
	<%-- // main article --%>

	<%-- footer Template --%>
	<c:import url="template/footer.jsp"></c:import>

	<script src="/resources/js/rsa/jsbn.js"></script>
	<script src="/resources/js/rsa/prng4.js"></script>
	<script src="/resources/js/rsa/rng.js"></script>
	<script src="/resources/js/rsa/rsa.js"></script>

	<%-- 인증 코드 확인시 RSA 적용 --%>
	<c:if test="${!loginUser.active}">
		<script>
			var rsa = new RSAKey();
			rsa.setPublic("${modulus}", "${exponent}");

			// 계정 활성화
			$("#joinForm").submit(function(e) {
				e.preventDefault();
				var $joinCode = $("#hiddenForm").find("input[name='joinCode']");
				var $captcha = $("#hiddenForm").find("input[name='captcha']");
				$joinCode.val(rsa.encrypt($(this).find("#code").val()));
				$captcha.val(rsa.encrypt($(this).find("#captcha").val()));
				$("#hiddenForm").submit();
			});

			// captcha 새로고침
			$(".box.captcha img").click(function() {
				var $loader = $(this).siblings(".loading");
				$loader.show();
				$(this).attr("src", "/captcha?ran=" + Math.random());
				$loader.fadeOut(500);
			});
		</script>
	</c:if>
</body>

</html>