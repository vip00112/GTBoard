<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="format-detection" content="telphone=no">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<link rel="stylesheet" href="/resources/css/global/font-awesome.min.css" />
<link rel="stylesheet" href="/resources/css/global/reset.css" />
<link rel="stylesheet" href="/resources/css/skin/imgBrowser.css" />

<title>이미지 업로드</title>
</head>

<body>
	<div class="loading"></div>
	<!-- // .loading -->

	<button class="exit">닫기</button>

	<p>* 파일 업로드: 이미지 파일을 서버로 업로드</p>
	<p>* 외부 링크: 외부의 이미지 링크 참조</p>
	<p>* bmp, jpg, jpeg, png, gif 파일만 가능</p>
	<p>* 본문에 미포함시 서버에 저장되지 않음</p>
	<p class="bold">* 1개 파일당 3MB, 최대 30개 제한</p>

	<div class="box link">
		<div class="variable">
			<input type="text" name="link" placeholder="외부 이미지 링크" />
		</div>
		<button>등록</button>
	</div>
	<!-- // .box.link -->

	<form action="/editor/browser/img/upload" method="post" enctype="multipart/form-data" class="form_upload">
		<label for="upload">파일 업로드</label>
		<input type="file" id="upload" name="upload" accept="image/*" multiple />
		<input type="hidden" name="key" />
		<input type="hidden" name="CSRFToken" value="${CSRFToken}" />
	</form>

	<p class="bold">선택 가능한 이미지 목록</p>
	<ul class="frame">
	</ul>

	<div class="result">
		<div class="box_close">
			<button>확인</button>
		</div>
		<!-- // .box_close -->

		<ul>
		</ul>
	</div>
	<!-- // .result -->

	<!-- script load -->
	<script src="/resources/js/jquery.min.js"></script>
	<script src="/resources/js/underscore-min.js"></script>
	<script src="/resources/js/common.js?ver=0001"></script>

	<!-- underscore setting -->
	<script>
		_.templateSettings = {
			interpolate: /\<\@\=(.+?)\@\>/gim,
			evaluate: /\<\@(.+?)\@\>/gim,
			escape: /\<\@\-(.+?)\@\>/gim
		};
	</script>

	<script type="text/template" id="temp">
	<@ _.each(list, function(file) { @>
		<@ if (file.uploaded) { @>
			<li>
				<span><@=file.name@> (<@=file.viewSize@>)</span>
				<img src="<@=file.url@>" alt="<@=file.name@>">
				<div class="option">
					<button>옵션 설정 <i class="fa fa-caret-down fa-fw fa-lg"></i></button>
					<div class="box border">
						<strong>테두리 설정</strong>
						<label>두께 <input type="text" name="border" value="0"></label>
					</div>
					<div class="box margin">
						<strong>여백 설정</strong>
						<label>상 <input type="text" name="margin-top" value="0"></label>
						<label>하 <input type="text" name="margin-bottom" value="0"></label>
						<label>좌 <input type="text" name="margin-left" value="0"></label>
						<label>우 <input type="text" name="margin-right" value="0"></label>
					</div>
					<div class="box float">
						<strong>이미지 위치 설정</strong>
						<label><input type="radio" name="float-<@=file.url@>" value="none" checked> 일반</label>
						<label><input type="radio" name="float-<@=file.url@>" value="left"> 왼쪽</label>
						<label><input type="radio" name="float-<@=file.url@>" value="right"> 오른쪽</label>
					</div>
				</div>
				<button class="btn select">선택</button>
				<form action="/editor/browser/img/delete" method="post" class="form_delete">
					<fieldset>
						<legend class="screen_out">이미지 삭제 폼</legend>
						<input type="hidden" name="_method" value="DELETE" />
						<input type="hidden" name="CSRFToken" value="<@=CSRFToken@>" />
						<input type="hidden" name="url" value="<@=file.url@>" />
						<button type="button" class="btn delete">삭제</button>
					</fieldset>
				</form>
			</li>
		<@ } @>
	<@ }) @>
	</script>

	<script type="text/template" id="results">
	<@ _.each(list, function(file) { @>
		<@ var result = file.uploaded ? "success" : "error"; @>
		<li class="<@=result@>">
			<span><@=file.name@> (<@=file.viewSize@>)</span>
			<span><@=file.message@></span>
		</li>
	<@ }) @>
	</script>

	<script>
		var $loader = $(".loading");
		var key = getParameter("key");
		var tmpFunc = _.template($("#temp").html());
		var resultsFunc = _.template($("#results").html());

		// 기존 목록 불러오기
		$(window).load(function() {
			if (window.opener == null) {
				location.href = "/error";
				return;
			}
			$(".form_upload input[name='key']").val(key);

			$.ajax("/editor/browser/img/list", {
				type: "GET",
				dataType: "JSON",
				cache: false,
				beforeSend: function() {
					$loader.show();
				}
			}).always(function() {
				$loader.fadeOut(200);
				$(this).val("");
			}).done(function(data) {
				if (data != null) {
					var code = tmpFunc({
						list: data,
						CSRFToken: "${CSRFToken}"
					});
					$(".frame").html(code);
				} else {
					alert("비정상적인 접근 입니다.");
				}
			});
		});

		// 닫기
		$(".exit").click(function() {
			window.close();
		});

		// 외부 이미지 링크 추가
		$(".box.link button").click(function() {
			var $input = $(this).parents(".box.link").find("input[name='link']");
			var url = $input.val();
			if (!isEmpty(url)) {
				$.ajax("/editor/browser/img/link", {
					type: "POST",
					dataType: "JSON",
					data: {
						url: url,
						CSRFToken: "${CSRFToken}"
					},
					beforeSend: function() {
						$loader.show();
					}
				}).always(function() {
					$loader.fadeOut(200);
					$input.val("");
				}).done(function(data) {
					if (data != null) {
						var code = tmpFunc({
							list: [ data ],
							CSRFToken: "${CSRFToken}"
						});
						$(".frame").append(code);

						code = resultsFunc({
							list: [ data ]
						});
						$(".result ul").html(code);
						$(".result").fadeIn(200);
					} else {
						alert("비정상적인 접근 입니다.");
					}
				});
			}
		});

		// 새로운 이미지 업로드
		$(".form_upload input[name='upload']").change(function() {
			if (window.opener == null) {
				window.close();
				return;
			} else if ($(this).val() == "") {
				return;
			}
			var formData = new FormData($(".form_upload")[0]);
			$.ajax($(".form_upload").attr("action"), {
				type: "POST",
				dataType: "JSON",
				data: formData,
				async: false,
				cache: false,
				contentType: false,
				processData: false,
				beforeSend: function() {
					$loader.show();
				}
			}).always(function() {
				$loader.fadeOut(200);
				$(this).val("");
			}).done(function(data) {
				if (data != null) {
					var code = tmpFunc({
						list: data,
						CSRFToken: "${CSRFToken}"
					});
					$(".frame").append(code);

					code = resultsFunc({
						list: data
					});
					$(".result ul").html(code);
					$(".result").fadeIn(200);
				} else {
					alert("비정상적인 접근 입니다.");
				}
			});
		});

		// 이미지 선택
		$(".frame").on("click", "li .select", function() {
			if (window.opener == null) {
				window.close();
				return;
			}
			if (!confirm("해당 이미지를 본문에 삽입 하시겠습니까?")) {
				return;
			}

			var $li = $(this).parents("li");
			var $optionBox = $(this).parents("li").find(".option");
			var option = {
				"border": getOptionValue($optionBox, "border"),
				"margin-top": getOptionValue($optionBox, "margin-top"),
				"margin-bottom": getOptionValue($optionBox, "margin-bottom"),
				"margin-left": getOptionValue($optionBox, "margin-left"),
				"margin-right": getOptionValue($optionBox, "margin-right"),
				"float": getOptionValue($optionBox, "float", $li.find("img").attr("src"))
			};
			var src = $li.find("img").attr("src");
			var alt = $li.find("img").attr("alt");
			var plugin = window.opener.CKEDITOR.plugins.get("image");
			if (plugin) {
				plugin.exec(key, src, alt, option);
			}
			window.close();
		});

		// 이미지 삭제
		$(".frame").on("click", "li .delete", function() {
			if (window.opener == null) {
				window.close();
				return;
			}
			if (!confirm("해당 이미지를 삭제 하시겠습니까?\n(본문에서도 삭제 됩니다.)")) {
				return;
			}

			var $li = $(this).parents("li");
			var $form = $(this).parents(".form_delete");
			$.ajax($form.attr("action"), {
				type: "POST",
				dataType: "JSON",
				data: $form.serialize(),
				beforeSend: function() {
					$loader.show();
				}
			}).always(function() {
				$loader.fadeOut(200);
			}).done(function(result) {
				if (result) {
					var src = $li.find("img").attr("src");
					var plugin = window.opener.CKEDITOR.plugins.get("image");
					if (plugin) {
						plugin.replaceContent(src);
					}
					$li.remove();
				}
			});
		});

		// 결과 창 닫기
		$(".result button").click(function() {
			$(".result").fadeOut(200);
		});

		// 옵션 열림/닫힘
		$(".frame").on("click", "li .option button", function() {
			var $i = $(this).find("i");
			var $option = $(this).parents(".option");
			if ($option.hasClass("on")) {
				$i.removeClass("fa-caret-up");
				$i.addClass("fa-caret-down");
			} else {
				$i.removeClass("fa-caret-down");
				$i.addClass("fa-caret-up");
			}
			$option.toggleClass("on");
		});

		// 옵션 값 취득
		function getOptionValue($optionBox, name, url) {
			if (name == "float") {
				return $optionBox.find("input[name='" + name + "-" + url + "']:checked").val();
			}
			var value = $optionBox.find("input[name='" + name + "']").val();
			var regex = /^\d+$/;
			return regex.test(value) ? parseInt(value) : 0;
		}

		// parameter 값 획득
		function getParameter(name) {
			var regex = new RegExp('[?&]' + name + '=([^&]*)'), result = window.location.search.match(regex);
			return (result && result.length > 1 ? decodeURIComponent(result[1]) : null);
		};
	</script>
</body>

</html>