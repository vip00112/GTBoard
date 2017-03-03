<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

    <div class="wrap wide-paper">
        <aside class="container">
            <img src="/resources/img/main.jpg" alt="대문 이미지">
        </aside>
        <!-- // aside.container -->
    </div>
    <!-- // .wrap.wide-paper-->
    
    <div class="wrap main">
        <main class="container">
        	<c:if test="${param.pageTitle != null && param.pageDesc != null}">
	            <div id="pageDescBox">
	                <h2>${param.pageTitle}</h2>
	                <span>${param.pageDesc}</span>
	            </div>
                <hr />
	            <!-- // pageDescBox -->
        	</c:if>
        	
            <article>
                <h1 class="screen_out">본문</h1>