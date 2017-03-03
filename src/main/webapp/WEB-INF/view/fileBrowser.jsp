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

<link rel="stylesheet" href="/resources/css/global/reset.css" />
<link rel="stylesheet" href="/resources/css/skin/fileBrowser.css" />

<title>첨부파일 업로드</title>
</head>

<body>
	<div class="loading"></div>
	<!-- // .loading -->

	<button class="exit">닫기</button>

	<p>* 파일 업로드: 첨부 파일을 서버로 업로드</p>
	<p>* 이미지 파일은 업로드 불가</p>
	<p class="bold">* 1개 파일당 10MB, 최대 10개 제한</p>

	<form action="/editor/browser/file/upload" method="post" enctype="multipart/form-data" class="form_upload">
		<label for="upload">파일 업로드</label>
		<input type="file" id="upload" name="upload" accept="*/*" multiple />
		<input type="hidden" name="key" />
		<input type="hidden" name="CSRFToken" value="${CSRFToken}" />
	</form>

	<p class="bold">선택 가능한 첨부파일 목록</p>
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
				<span title="<@=file.name@> (<@=file.viewSize@>)" data-name="<@=file.name@>" data-url="<@=file.url@>"><@=file.name@> (<@=file.viewSize@>)</span>
				<button class="btn select">선택</button>
				<form action="/editor/browser/file/delete" method="post" class="form_delete">
					<fieldset>
						<legend class="screen_out">첨부파일 삭제 폼</legend>
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

			$.ajax("/editor/browser/file/list", {
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

		// 새로운 파일 업로드
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

		// 파일 선택
		$(".frame").on("click", "li .select", function() {
			if (window.opener == null) {
				window.close();
				return;
			}
			if (!confirm("해당 첨부파일을 본문에 삽입 하시겠습니까?")) {
				return;
			}

			var url = $(this).parents("li").find("span").attr("data-url");
			var name = $(this).parents("li").find("span").attr("data-name");
			var title = $(this).parents("li").find("span").attr("title");
			var plugin = window.opener.CKEDITOR.plugins.get("file");
			if (plugin) {
				plugin.exec(key, url, name, title);
			}
			window.close();
		});

		// 파일 삭제
		$(".frame").on("click", "li .delete", function() {
			if (window.opener == null) {
				window.close();
				return;
			}
			if (!confirm("해당 첨부파일을 삭제 하시겠습니까?\n(본문에서도 삭제 됩니다.)")) {
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
					var url = $li.find("span").attr("data-url");
					var plugin = window.opener.CKEDITOR.plugins.get("file");
					if (plugin) {
						plugin.replaceContent(url);
					}
					$li.remove();
				}
			});
		});

		// 결과 창 닫기
		$(".result button").click(function() {
			$(".result").fadeOut(200);
		});

		// parameter 값 획득
		function getParameter(name) {
			var regex = new RegExp('[?&]' + name + '=([^&]*)'), result = window.location.search.match(regex);
			return (result && result.length > 1 ? decodeURIComponent(result[1]) : null);
		};
	</script>
</body>

</html>