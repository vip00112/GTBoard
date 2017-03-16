<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8" />

<c:choose>
	<c:when test="${type eq 'terms'}">
		<c:set var="type" value="이용약관" />
	</c:when>
	<c:when test="${type eq 'privacy'}">
		<c:set var="type" value="개인정보 취급 방침" />
	</c:when>
	<c:when test="${type eq 'youth'}">
		<c:set var="type" value="청소년 보호 정책" />
	</c:when>
	<c:when test="${type eq 'email'}">
		<c:set var="type" value="이메일 무단 수집 거부" />
	</c:when>
</c:choose>

<%-- meta Template --%>
<c:import url="template/meta.jsp">
	<c:param name="author"></c:param>
	<c:param name="reply"></c:param>
	<c:param name="keyword"></c:param>
	<c:param name="description"></c:param>
	<c:param name="robots">noindex, nofollow</c:param>
	<c:param name="ogType"></c:param>
	<c:param name="title">${baseSetting.title}-${type}</c:param>
	<c:param name="thumbnail"></c:param>
</c:import>

<title>${baseSetting.title}-${type}</title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/agreement.css">

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
		<c:param name="pageTitle">${type}</c:param>
		<c:param name="pageDesc">현재 적용된 내용과 이전 내역을 확인할 수 있습니다.</c:param>
	</c:import>

	<%-- main article --%>
	<section>
		<div class="loading"></div>
		<!-- // .loading -->

		<label>
			이전 내역
			<select name="no">
				<c:forEach items="${agreements}" var="agreement">
					<option value="${agreement.no}">${agreement.viewRegdate}</option>
				</c:forEach>
			</select>
		</label>

		<div class="text"></div>
		<span class="regdate"></span>
	</section>
	<%-- // main article --%>

	<%-- footer Template --%>
	<c:import url="template/footer.jsp"></c:import>

	<script>
		var $loader = $(".loading");

		$(window).load(function() {
			getAgreement();
		});

		$("select[name='no']").change(function() {
			getAgreement();
		});

		// 이전 내역 취득
		function getAgreement() {
			var no = $("select[name='no']").val();
			$.ajax("/agreement/" + no, {
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
			}).done(function(data) {
				$(".text").html(data.content);
				$(".regdate").text("위 내용은 '" + data.viewRegdate + "' 부터 적용 됩니다.");
			});
		}
	</script>
</body>

</html>