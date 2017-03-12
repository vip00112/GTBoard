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

<%-- IE8 이하 link Template --%>
<c:import url="template/ltIE9.jsp"></c:import>

<style>
</style>
</head>

<body>
	<div class="loading"></div>
	<!-- // .loading -->

	<aside class="menu">
		<button class="on">
			<i class="fa fa-caret-left fa-fw fa-2x"></i>
		</button>

		<ul>
			<li class="base on">기본 정보 설정</li>
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

		<div class="box menuType">
			<c:import url="template/admin/menuType.jsp" />
		</div>
		<!-- // .box.menuType -->

		<div class="box boardType">
			<c:import url="template/admin/boardType.jsp" />
		</div>
		<!-- // .box.boardType -->

		<div class="box board">
			<h2>게시글 관리</h2>
		</div>
		<!-- // .box.board -->

		<div class="box comment">
			<h2>댓글 관리</h2>
		</div>
		<!-- // .box.comment -->
	</section>

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
				}, 200);
			} else {
				$icon.removeClass("fa-caret-left");
				$icon.addClass("fa-caret-right");
				$menu.animate({
					left: -150
				}, 200);
				$content.animate({
					left: 0
				}, 200);
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
			} else if (className == "menuType") {
				getMenuTypeInfo();
			} else if (className == "boardType") {
				getBoardTypeInfo();
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
	</script>

	<!-- 기본 정보 설정 -->
	<script>
		// 기본 정보 취득
		function getBaseInfo() {
			$.ajax("/admin/setting/base", {
				type: "GET",
				dataType: "json",
				beforeSend: function() {
					$loader.show();
				}
			}).always(function() {
				$loader.fadeOut(200);
			}).fail(function(xhr, error, code) {
				alert(error + " : " + code);
				console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
			}).done(function(info) {
				setValue($(".content .box.base .form_update"), info);
			});
		}
	</script>

	<!-- 메뉴 설정 -->
	<script type="text/template" id="subMenuTmp">
	<@ _.each(list, function(subMenu) { @>
		<div class="box_wrap">
			<span class="delete sub">
				<i class="fa fa-trash"></i> 삭제
			</span>
			<label>순서</label>
			<input required type="text" name="order" value="<@=subMenu.order@>">
			<label>이름</label>
			<input required type="text" name="name" value="<@=subMenu.name@>">
			<label>URL</label>
			<input required type="text" name="url" value="<@=subMenu.url@>">
		</div>
	<@ }) @>
	</script>

	<script>
		var $items = $(".content .box.menuType .items");
		var subMenuTmpFunc = _.template($("#subMenuTmp").html());

		// 신규 메뉴 추가
		$(".content .box.menuType select[name='no']").change(function() {
			if ($(this).val() == 0) {
				$items.html("");
				$(".content .box.menuType input[name!='CSRFToken']").val("");
				$(".content .box.menuType select").val("true");
				$(this).val(0);
				$(".content .box.menuType .delete.main").hide();
			} else {
				getMenuTypeInfo();
				$(".content .box.menuType .delete.main").show();
			}
		});

		// 신규 서브 메뉴 추가
		$(".content .box.menuType .add").click(function() {
			if (!confirm("신규 서브 메뉴를 추가 하시겠습니까?")) {
				return false;
			}
			var item = {
				order: "",
				name: "",
				url: ""
			}
			var code = subMenuTmpFunc({
				list: [ item ]
			});
			$items.append(code);
		});

		// 서브 메뉴 삭제
		$(".content .box.menuType .items").on("click", ".delete.sub", function() {
			if (!confirm("해당 서브 메뉴를 삭제 하시겠습니까?")) {
				return false;
			}

			$(this).parents(".box_wrap").remove();
		});

		// form_update 전송
		$(".content .box.menuType .form_update").submit(function() {
			var no = $(this).find("select[name='no']").val();
			var method = (no == 0) ? "POST" : "PUT";

			// url, mehotd 지정
			$(this).attr("action", "/admin/setting/menuType/" + no);
			$(this).find("input[name='_method']").val(method);

			// subMenuList 구성
			var items = $(this).find(".items .box_wrap");
			items.each(function(idx) {
				var inputs = $(this).find("input");
				inputs.each(function() {
					var attr = $(this).attr("name");
					$(this).attr("name", "subMenuList[" + idx + "]." + attr);
				});
			});
		});

		// 삭제
		$(".content .box.menuType .delete.main").click(function() {
			if (!confirm("해당 메뉴를 정말 삭제 하시겠습니까?")) {
				return false;
			}

			var no = $(this).parents(".form_update").find("select[name='no']").val();
			if (no == 0) {
				return false;
			}
			var $deleteForm = $(this).parents(".box").find(".form_delete");
			$deleteForm.attr("action", "/admin/setting/menuType/" + no);
			$deleteForm.submit();
		});

		// 메뉴 정보 취득
		function getMenuTypeInfo() {
			var no = $(".content .box.menuType select[name='no']").val();
			if (no == 0) {
				return;
			}
			$.ajax("/admin/setting/menuType/" + no, {
				type: "GET",
				dataType: "json",
				data: {
					no: no
				},
				beforeSend: function() {
					$loader.show();
				}
			}).always(function() {
				$loader.fadeOut(200);
			}).fail(function(xhr, error, code) {
				alert(error + " : " + code);
				console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
			}).done(function(info) {
				setValue($(".content .box.menuType .form_update"), info);
				var code = subMenuTmpFunc({
					list: info.subMenuList
				});
				$items.html(code);
			});
		}
	</script>

	<!-- 게시판 설정 -->
	<script>
		// 신규 게시판 추가
		$(".content .box.boardType select[name='no']").change(function() {
			if ($(this).val() == 0) {
				$(".content .box.boardType input[name!='CSRFToken']").val("");
				$(".content .box.boardType select").val("true");
				$(this).val(0);

				$(".content .box.boardType [name='anonymous']").val("false");
				$(".content .box.boardType [name='secret']").val("false");
				$(".content .box.boardType [name='album']").val("false");
				$(".content .box.boardType [name='writePoint']").val("0");
				$(".content .box.boardType [name='commentPoint']").val("0");
				$(".content .box.boardType [name='thumbPoint']").val("0");
				$(".content .box.boardType [name='downloadPoint']").val("0");
				$(".content .box.boardType [name='popularThumb']").val("0");
				$(".content .box.boardType [name='writeGrade']").val("1");
				$(".content .box.boardType [name='readGrade']").val("0");
				$(".content .box.boardType [name='commentGrade']").val("1");
				$(".content .box.boardType [name='downloadGrade']").val("1");
				$(".content .box.boardType [name='adminGrade']").val("9999");

				$(".content .box.boardType select[name!='no']").each(function() {
					var lows = $(this).parents(".box_wrap").attr("data-low");
					var value = $(this).parents(".box_wrap").attr("data-on");
					if (!lows || !value) {
						return;
					}

					var show = $(this).val() == value;
					lows = lows.split(",");
					toggleLows(show, lows);
				});
				$(".content .box.boardType .delete.main").hide();
			} else {
				getBoardTypeInfo();
				$(".content .box.boardType .delete.main").show();
			}
		});

		// ON/OFF 설정
		$(".content .box.boardType select[name!='no']").change(function() {
			var lows = $(this).parents(".box_wrap").attr("data-low");
			var value = $(this).parents(".box_wrap").attr("data-on");
			if (!lows || !value) {
				return;
			}

			var show = $(this).val() == value;
			lows = lows.split(",");
			toggleLows(show, lows);
		});

		// 하위 항목 ON/OFF
		function toggleLows(show, lows) {
			for (var i = 0, length = lows.length; i < length; i++) {
				var name = lows[i];
				var children = $(".content .box.boardType [name='" + name + "']");
				if (show) {
					children.parents(".box_wrap").show();
				} else {
					children.parents(".box_wrap").hide();
				}

				// 대상의 하위항목이 있을시 추가 ON/OFF
				var lowers = children.parents(".box_wrap").attr("data-low");
				var value = children.parents(".box_wrap").attr("data-on");
				if (lowers && value) {
					lowers = lowers.split(",");
					if (show) {
						var lowerShow = children.val() == value;
						toggleLows(lowerShow, lowers);
					} else {
						toggleLows(show, lowers);
					}
				}
			}
		}

		// form_update 전송
		$(".content .box.boardType .form_update").submit(function() {
			var no = $(this).find("select[name='no']").val();
			var method = (no == 0) ? "POST" : "PUT";

			// url, mehotd 지정
			$(this).attr("action", "/admin/setting/boardType/" + no);
			$(this).find("input[name='_method']").val(method);
		});

		// 삭제
		$(".content .box.boardType .delete.main").click(function() {
			if (!confirm("해당 게시판을 정말 삭제 하시겠습니까?")) {
				return false;
			}
			if (!confirm("게시글/댓글/첨부파일등 게시판의 모든 하위 데이터가 삭제 됩니다.\r정말 삭제 하시겠습니까?")) {
				return false;
			}

			var no = $(this).parents(".form_update").find("select[name='no']").val();
			if (no == 0) {
				return false;
			}
			var $deleteForm = $(this).parents(".box").find(".form_delete");
			$deleteForm.attr("action", "/admin/setting/boardType/" + no);
			$deleteForm.submit();
		});

		// 게시판 정보 취득
		function getBoardTypeInfo() {
			var no = $(".content .box.boardType select[name='no']").val();
			if (no == 0) {
				return;
			}
			$.ajax("/admin/setting/boardType/" + no, {
				type: "GET",
				dataType: "json",
				data: {
					no: no
				},
				beforeSend: function() {
					$loader.show();
				}
			}).always(function() {
				$loader.fadeOut(200);
			}).fail(function(xhr, error, code) {
				alert(error + " : " + code);
				console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
			}).done(function(info) {
				setValue($(".content .box.boardType .form_update"), info);

				$(".content .box.boardType select[name!='no']").each(function() {
					var lows = $(this).parents(".box_wrap").attr("data-low");
					var value = $(this).parents(".box_wrap").attr("data-on");
					if (!lows || !value) {
						return;
					}

					var show = $(this).val() == value;
					lows = lows.split(",");
					toggleLows(show, lows);
				});
			});
		}
	</script>
</body>

</html>