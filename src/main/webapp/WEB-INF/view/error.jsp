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
	<c:param name="description">잘못된 접근 입니다.</c:param>
	<c:param name="robots">noindex, nofollow</c:param>
	<c:param name="ogType"></c:param>
	<c:param name="title">${baseSetting.title} | Error</c:param>
	<c:param name="thumbnail"></c:param>
</c:import>

<title>${baseSetting.title}-Error</title>

<link rel="icon" href="/resources/img/favicon.ico">
<link rel="stylesheet" href="/resources/css/global/font-awesome.min.css" />
<link rel="stylesheet" href="/resources/css/global/reset.css" />

<style>
body {
	padding: 20px 0;
}

img {
	display: block;
	margin: auto;
}

h1 {
	display: block;
	font-size: 25px;
	font-weight: bold;
	line-height: 1.5;
	text-align: center;
}

h2 {
	display: block;
	font-size: 20px;
	font-weight: bold;
	line-height: 1.5;
	text-align: center;
}

a {
	display: block;
	text-decoration: none;
	color: #424242;
	line-height: 1.5;
	padding: 20px 0;
	text-align: center;
	transition: .2s ease;
}

a:hover {
	color: red;
}
</style>
</head>

<body>
	<c:set var="statusCode">${requestScope['javax.servlet.error.status_code']}</c:set>

	<img src="/resources/img/error.png" alt="error">
	<h1>'${statusCode}' ERROR</h1>

	<c:choose>
		<c:when test="${statusCode == 404}">
			<h2>페이지를 찾을 수 없습니다.</h2>
		</c:when>
		<c:otherwise>
			<h2>잘못된 접근 입니다.</h2>
		</c:otherwise>
	</c:choose>

	<a href="/index">
		<i class="fa fa-caret-right"></i>
		Home으로 돌아가기
	</a>
</body>

</html>