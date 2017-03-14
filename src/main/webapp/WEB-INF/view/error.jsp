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

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

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
	<!-- content Area -->
    <img src="/resources/img/error.png" alt="error">
    <h1>404 ERROR</h1>
    <h2>잘못된 접근 입니다.</h2>
    <a href="/index">
        <i class="fa fa-caret-right"></i> Home으로 돌아가기
    </a>
</body>

</html>