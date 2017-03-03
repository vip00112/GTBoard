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
<link rel="stylesheet" href="/resources/css/skin/findPassword-complete.css">

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

		<form action="/find/password/${code}" id="findForm" method="post">
			<fieldset>
				<legend class="screen_out">비밀번호 찾기 폼</legend>
				<input type="hidden" name="_method" value="PUT" />

				<div class="box password">
					<label for="password">새로운 비밀번호</label>
					<input type="password" id="password" name="password" autocomplete="off" required />
					<span class="msg error on">영문+숫자+특수문자 8~20</span>
					<span class="msg done">사용 가능 합니다.</span>
					<span class="msg error icon on">
						<i class="fa fa-times-circle"></i>
					</span>
					<span class="msg done icon">
						<i class="fa fa-check-circle"></i>
					</span>
				</div>
				<!-- // .box.password -->

				<div class="box check">
					<label for="check">비밀번호 확인</label>
					<input type="password" id="check" name="check" autocomplete="off" required />
					<span class="msg error on">불일치</span>
					<span class="msg done">일치 합니다.</span>
					<span class="msg error icon on">
						<i class="fa fa-times-circle"></i>
					</span>
					<span class="msg done icon">
						<i class="fa fa-check-circle"></i>
					</span>
				</div>
				<!-- // .box.check -->

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
						<i class="fa fa-refresh"></i>
						비밀번호 변경
					</button>
				</div>
				<!-- .box.btn -->

				<div class="box link">
					<a href="/find/password/verify">
						<i class="fa fa-envelope"></i>
						인증 코드 다시 받기
					</a>
				</div>
				<!-- // .box.link -->
			</fieldset>
		</form>
		<form action="/find/password/${code}" method="post" id="hiddenForm">
			<fieldset>
				<input type="hidden" name="_method" value="PUT" />
				<input type="hidden" name="password" />
				<input type="hidden" name="captcha" />
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
		var $pw = $("#findForm #password");
		var $check = $("#findForm #check");

		var isOK_password = false;
		var isOK_checkPassword = false;

		var rsa = new RSAKey();
		rsa.setPublic("${modulus}", "${exponent}");

		// msg view
		function viewMsg($input, className) {
			$input.siblings(".msg").removeClass("on");
			$input.siblings(".msg." + className).addClass("on");
			if (className == "overlap") {
				$input.siblings(".msg.error.icon").addClass("on");
			}
		}

		// 비밀번호 유효성 검사
		$pw.focusout(function(e) {
			if (regexCheck(/^[A-Za-z0-9!@#$%^&*]{8,20}$/, $(this).val())) {
				isOK_password = true;
				viewMsg($pw, "done");
			} else {
				isOK_password = false;
				viewMsg($pw, "error");
			}
			$check.val("");
			viewMsg($check, "error");
		});

		// 비밀번호 확인
		$check.focusout(function(e) {
			if ($check.val() != "" && $check.val() == $pw.val()) {
				isOK_checkPassword = true;
				viewMsg($check, "done");
			} else {
				isOK_checkPassword = false;
				viewMsg($check, "error");
			}
		});

		// submit 전 확인
		$("#findForm").submit(function(e) {
			// 비밀번호 확인
			if (!isOK_password) {
				$pw.focus();
				return false;
			}
			if (!isOK_checkPassword) {
				$check.focus();
				return false;
			}

			e.preventDefault();
			var $hPassword = $("#hiddenForm").find("input[name='password']");
			var $hCaptcha = $("#hiddenForm").find("input[name='captcha']");
			$hPassword.val(rsa.encrypt($pw.val()));
			$hCaptcha.val(rsa.encrypt($(this).find("#captcha").val()));
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
</body>

</html>