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
	<c:param name="description"></c:param>
	<c:param name="robots">noindex, nofollow</c:param>
	<c:param name="ogType"></c:param>
	<c:param name="title">${baseSetting.title} | 사이트관리</c:param>
	<c:param name="thumbnail"></c:param>
</c:import>

<title>${baseSetting.title}-사이트관리</title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/admin.css">
<link rel="stylesheet" href="/resources/css/global/jquery-ui-timepicker-addon.css" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />

<%-- IE8 이하 link Template --%>
<c:import url="template/ltIE9.jsp"></c:import>

<!-- script load -->
<script src="/resources/js/jquery.min.js"></script>
<script src="/resources/js/underscore-min.js"></script>
<script src="/resources/js/moment.min.js"></script>
<script src="/resources/js/moment-with-locales.min.js"></script>
<script src="/resources/js/gtboard.js?ver=0001"></script>
<script src="/resources/js/common.js?ver=0001"></script>
<script src="/resources/js/fix.js?ver=0001"></script>
<script src="/resources/js/board.js?ver=0001"></script>
<script src="/resources/js/comment.js?ver=0001"></script>
<script src="/resources/js/paginate.js?ver=0001"></script>

<!-- underscore setting -->
<script>
	_.templateSettings = {
		interpolate: /\<\@\=(.+?)\@\>/gim,
		evaluate: /\<\@(.+?)\@\>/gim,
		escape: /\<\@\-(.+?)\@\>/gim
	};
</script>
</head>

<body>
	<div class="loading"></div>
	<!-- // .loading -->

	<aside class="menu">
		<button class="on">
			<i class="fa fa-caret-left fa-fw fa-2x"></i>
		</button>

		<a href="/index">
			<i class="fa fa-home fa-lg"></i>
			Home
		</a>

		<ul>
			<li class="base on">기본 정보 설정</li>
			<li class="agreement">운영방침 설정</li>
			<li class="menuType">메뉴 설정</li>
			<li class="boardType">게시판 설정</li>
			<li class="board">게시글 관리</li>
			<li class="comment">댓글 관리</li>
		</ul>
	</aside>

	<section class="content">
		Server :
		<%=application.getServerInfo()%>
		<br />
		Servlet :
		<%=application.getMajorVersion()%>.<%=application.getMinorVersion()%>
		<br />
		JSP :
		<%=JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion()%>
		<br />

		<div class="box base on">
			<c:import url="template/admin/base.jsp" />
		</div>
		<!-- // .box.base -->

		<div class="box agreement">
			<c:import url="template/admin/agreement.jsp" />
		</div>
		<!-- // .box.menuType -->

		<div class="box menuType">
			<c:import url="template/admin/menuType.jsp" />
		</div>
		<!-- // .box.menuType -->

		<div class="box boardType">
			<c:import url="template/admin/boardType.jsp" />
		</div>
		<!-- // .box.boardType -->

		<div class="box board">
			<c:import url="template/admin/board.jsp" />
		</div>
		<!-- // .box.board -->

		<div class="box comment">
			<h2>댓글 관리</h2>
		</div>
		<!-- // .box.comment -->
	</section>

	<!-- 공통 -->
	<script>
		var $menu = $(".menu");
		var $content = $(".content");
		var $loader = $("body>.loading");

		$(window).load(function() {
			if ($(".content .box.base").hasClass("on")) {
				getBaseInfo();
			} else if ($(".content .box.menuType").hasClass("on")) {
				getMenuTypeInfo();
			} else if ($(".content .box.boardType").hasClass("on")) {
				getBoardTypeInfo();
			}
		});

		// 메뉴 펼침/닫힘
		$(".menu button").click(function() {
			var $btn = $(this);
			$btn.toggleClass("on");
			var $icon = $btn.find(".fa");

			if ($btn.hasClass("on")) {
				$icon.removeClass("fa-caret-right");
				$icon.addClass("fa-caret-left");
				$menu.animate({
					left: 0
				}, 200);
				$content.animate({
					left: 150
				}, 200, function() {
					gtBoard.board.resizeTitle();
				});
			} else {
				$icon.removeClass("fa-caret-left");
				$icon.addClass("fa-caret-right");
				$menu.animate({
					left: -150
				}, 200);
				$content.animate({
					left: 0
				}, 200, function() {
					gtBoard.board.resizeTitle();
				});
			}
		});

		// 메뉴 변경
		$(".menu li").click(function() {
			$(".menu li").removeClass("on");
			$(".content .box").removeClass("on");

			var className = $(this).attr("class");
			$(this).addClass("on");
			$(".content .box." + className).addClass("on");

			if (className == "base") {
				getBaseInfo();
			} else if (className == "agreement") {
				getAgreementInfo();
			} else if (className == "menuType") {
				getMenuTypeInfo();
			} else if (className == "boardType") {
				getBoardTypeInfo();
			} else if (className == "board") {
				getBoardList();
			}
		});

		// form 전송 전 confirm
		$(".content .box .form_update").submit(function() {
			if (!confirm("저장 하시겠습니까?")) {
				return false;
			}
		});

		// form에 정보 입력
		function setValue($form, infoObj) {
			for (attr in infoObj) {
				if (typeof infoObj[attr] === "boolean") {
					$select = $form.find("select[name='" + attr + "']");
					$select.val(infoObj[attr].toString());
				} else {
					var $input = $form.find("input[name='" + attr + "']");
					$input.val(infoObj[attr]);
				}
			}
		}

		// 검증이 필요한 input 확인
		$(".form_update").on("keydown", "input[data-regex]", function(e) {
			var regex = new RegExp($(this).attr("data-regex"));
			return regexCheck(regex, e.key);
		})
	</script>
</body>

</html>