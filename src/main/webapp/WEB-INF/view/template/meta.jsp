<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

	<%-- defined Meta --%>
	<c:set var="meta_author" value="${baseSetting.author}" />
	<c:set var="meta_replyTo" value="${baseSetting.reply}" />
	<c:set var="meta_keyword" value="${baseSetting.keyword}" />
	<c:set var="meta_description" value="${baseSetting.description}" />
	<c:set var="meta_robots" value="index, follow" />
	
	<%-- defined OpenGraph --%>
	<c:set var="og_title" value="${baseSetting.title}" />
	<c:set var="og_type" value="website" />
	<c:set var="og_siteName" value="${baseSetting.title}" />
	<c:set var="og_url" value="${requestUrl}" />
	<c:set var="og_image" value="/resources/img/main.jpg" />
	<c:set var="og_description" value="${baseSetting.description}" />
	
	<%-- defined Twitter --%>
	<c:set var="twitter_title" value="${baseSetting.title}" />
	<c:set var="twitter_card" value="summary" />
	<c:set var="twitter_site" value="${baseSetting.title}" />
	<c:set var="twitter_url" value="${requestUrl}" />
	<c:set var="twitter_image" value="/resources/img/main.jpg" />
	<c:set var="twitter_description" value="${baseSetting.description}" />
	
	<%-- Set Variable --%>
	<c:if test="${param.author != null && param.author != ''}">
		<c:set var="meta_author" value="${param.author}" />
	</c:if>
	<c:if test="${param.reply != null && param.reply != ''}">
		<c:set var="meta_replyTo" value="${param.reply}" />
	</c:if>
	<c:if test="${param.keyword != null && param.keyword != ''}">
		<c:set var="meta_keyword" value="${param.keyword}" />
	</c:if>
	<c:if test="${param.description != null && param.description != ''}">
		<c:set var="meta_description" value="${param.description}" />
		<c:set var="og_description" value="${param.description}" />
		<c:set var="twitter_description" value="${param.description}" />
	</c:if>
	<c:if test="${param.robots != null && param.robots != ''}">
		<c:set var="meta_robots" value="${param.robots}" />
	</c:if>
	<c:if test="${param.title != null && param.title != ''}">
		<c:set var="og_title" value="${param.title}" />
		<c:set var="twitter_title" value="${param.title}" />
	</c:if>
	<c:if test="${param.ogType != null && param.ogType != ''}">
		<c:set var="og_type" value="${param.ogType}" />
	</c:if>
	<c:if test="${param.thumbnail != null && param.thumbnail != ''}">
		<c:set var="og_image" value="${param.thumbnail}" />
		<c:set var="twitter_image" value="${param.thumbnail}" />
	</c:if>
	
	<%-- Check Local Image Url --%>
	<c:if test="${fn:startsWith(og_image, '/')}">
		<c:set var="og_image" value="${requestServerName}${og_image}" />
	</c:if>
	<c:if test="${fn:startsWith(twitter_image, '/')}">
		<c:set var="twitter_image" value="${requestServerName}${twitter_image}" />
	</c:if>
    
    <!-- Meta -->
    <meta name="author" content="${meta_author}">
    <meta name="reply-to" content="${meta_replyTo}">
    <meta name="keyword" content="${meta_keyword}">
    <meta name="description" content="${meta_description}">
    <meta name="robots" content="${meta_robots}">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <meta name="format-detection" content="telphone=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    
    <!-- OpenGraph -->
	<meta property="og:title" content="${og_title}">
	<meta property="og:type" content="${og_type}">
	<meta property="og:site_name" content="${og_siteName}">
	<meta property="og:url" content="${og_url}">
	<meta property="og:image" content="${og_image}">
	<meta property="og:description" content="${og_description}">
	
	<!-- Twitter -->
	<meta name="twitter:title" content="${twitter_title}">
	<meta name="twitter:card" content="${twitter_card}">
	<meta name="twitter:site" content="${twitter_site}">
	<meta name="twitter:url" content="${twitter_url}">
	<meta name="twitter:image" content="${twitter_image}">
	<meta name="twitter:description" content="${twitter_description}">
