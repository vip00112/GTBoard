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
<link rel="stylesheet" href="/resources/css/skin/join-profile.css">

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
		<c:param name="pageTitle">신규 회원 가입</c:param>
		<c:param name="pageDesc">'${baseSetting.title}'의 회원으로 가입합니다.<br />
			<br />
								 이메일 인증이 필요하므로 유효한 이메일을 작성 바랍니다.
		</c:param>
	</c:import>

	<%-- main article --%>
	<section>
		<div class="box step">
			<span class="clear">약관 동의</span>
			<span class="now">정보 입력</span>
			<span>이메일 인증</span>
			<span class="complete">가입 완료</span>
		</div>
		<!-- // .box.step -->

		<form action="/join/profile" method="post" id="joinForm">
			<fieldset>
				<legend class="screen_out">회원가입 '정보 입력' 폼</legend>

				<div class="box email">
					<label for="email">이메일 (아이디)</label>
					<input type="text" id="email" name="email" autofocus autocomplete="off" required />
					<span class="msg error on">유효한 이메일 형식을 입력 하세요.</span>
					<span class="msg overlap">이미 사용중 입니다.</span>
					<span class="msg done">사용 가능 합니다.</span>
					<span class="msg error icon on">
						<i class="fa fa-times-circle"></i>
					</span>
					<span class="msg done icon">
						<i class="fa fa-check-circle"></i>
					</span>
				</div>
				<!-- // .box.email -->

				<div class="box nickname">
					<label for="nickname">닉네임</label>
					<input type="text" id="nickname" name="nickname" autocomplete="off" required />
					<span class="msg error on">한글/영문/숫자로 1~6자만 가능 합니다.</span>
					<span class="msg overlap">이미 사용중 입니다.</span>
					<span class="msg done">사용 가능 합니다.</span>
					<span class="msg error icon on">
						<i class="fa fa-times-circle"></i>
					</span>
					<span class="msg done icon">
						<i class="fa fa-check-circle"></i>
					</span>
				</div>
				<!-- // .box.nickname -->

				<div class="box password">
					<label for="password">비밀번호</label>
					<input type="password" id="password" name="password" autocomplete="off" required />
					<span class="msg error on">영문+숫자+특수문자로 8~20자만 가능 합니다.</span>
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
					<span class="msg error on">비밀번호 불일치</span>
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
					<a href="/join/agreement" class="btn prev">
						<i class="fa fa-undo"></i>
						이전
					</a>
					<button type="submit" class="btn next">
						<i class="fa fa-user-plus"></i>
						회원 가입
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
		<form action="/join/profile" method="post" id="hiddenForm">
			<fieldset>
				<input type="hidden" name="email" />
				<input type="hidden" name="nickname" />
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
		var $email = $("#joinForm #email");
		var $nickname = $("#joinForm #nickname");
		var $pw = $("#joinForm #password");
		var $check = $("#joinForm #check");
		var $captchaLoader = $("#joinForm .box.captcha .loading");
		var $captchaImg = $("#joinForm .box.captcha img");

		var isOK_email = false;
		var isOK_nickname = false;
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

		// 이메일 유효성 검사 및 중복 확인
		$email.focusout(function(e) {
			if (regexCheck(/^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[a-zA-Z]+){1,2}$/, $email.val())) {
				$.ajax("/join/check/email", {
					type: "POST",
					dataType: "json",
					data: {
						value: rsa.encrypt($email.val())
					}
				}).fail(function(xhr, error, code) {
					alert(error + " : " + code);
					console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
				}).done(function(isOverlap) {
					isOK_email = !isOverlap;

					if (isOverlap) {
						viewMsg($email, "overlap");
					} else {
						viewMsg($email, "done");
					}
				});
			} else {
				isOK_email = false;
				viewMsg($email, "error");
			}
		});

		// 닉네임 유효성 검사 및 중복 확인
		$nickname.focusout(function(e) {
			if (regexCheck(/^[A-Za-z0-9가-힣ㄱ-ㅎㅏ-ㅣ]{1,6}$/, $nickname.val())) {
				$.ajax("/join/check/nickname", {
					type: "POST",
					dataType: "json",
					data: {
						value: rsa.encrypt($nickname.val())
					}
				}).fail(function(xhr, error, code) {
					alert(error + " : " + code);
					console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
				}).done(function(isOverlap) {
					isOK_nickname = !isOverlap;

					if (isOverlap) {
						viewMsg($nickname, "overlap");
					} else {
						viewMsg($nickname, "done");
					}
				});
			} else {
				isOK_nickname = false;
				viewMsg($nickname, "error");
			}
		});

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

		// joinForm submit 전 확인
		$("#joinForm").submit(function(e) {
			// 이메일 확인
			if (!isOK_email) {
				$email.focus();
				return false;
			}

			// 닉네임 확인
			if (!isOK_nickname) {
				$nickname.focus();
				return false;
			}

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
			var $hEmail = $("#hiddenForm").find("input[name='email']");
			var $hNickname = $("#hiddenForm").find("input[name='nickname']");
			var $hPassword = $("#hiddenForm").find("input[name='password']");
			var $hCaptcha = $("#hiddenForm").find("input[name='captcha']");
			$hEmail.val(rsa.encrypt($email.val()));
			$hNickname.val(rsa.encrypt($nickname.val()));
			$hPassword.val(rsa.encrypt($pw.val()));
			$hCaptcha.val(rsa.encrypt($(this).find("#captcha").val()));
			$("#hiddenForm").submit();
		});

		// captcha 새로고침
		$captchaImg.click(function() {
			$captchaLoader.show();
			$(this).attr("src", "/captcha?ran=" + Math.random());
			$captchaLoader.fadeOut(500);
		});
	</script>
</body>

</html>