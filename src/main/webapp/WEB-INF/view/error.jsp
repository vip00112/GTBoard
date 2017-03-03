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
h1 {
	font-size: 20px;
	font-weight: bold;
	height: 50px;
	line-height: 50px;
	text-align: center;
}

a {
	display: block;
	text-decoration: none;
	color: #424242;
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
	<h1>잘못된 접근 입니다.</h1>
	<a href="/index">
		<i class="fa fa-caret-right"></i>
		Home으로 돌아가기
	</a>
</body>

</html>