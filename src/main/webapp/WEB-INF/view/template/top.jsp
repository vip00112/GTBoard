<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

    <div class="wrap top">
        <div class="container">
            <div class="logo">
                <a href="/index">
                	<c:if test="${baseSetting.logo != null}"></c:if>
                	<c:choose>
                		<c:when test="${baseSetting.logo != null && baseSetting.logo != ''}">
		                    <span class="screen_out">${baseSetting.title}</span>
		                    <img src="${baseSetting.logo}" alt="로고 이미지">
                		</c:when>
                		<c:otherwise>
		                    <span>${baseSetting.title}</span>
		                    <img class="screen_out" src="${baseSetting.logo}" alt="로고 이미지">
                		</c:otherwise>
                	</c:choose>
                </a>
            </div>
            
            <button class="gnav" title="메뉴">메뉴 <i class="fa fa-caret-down"></i></button>

            <ul class="user">
            	<c:choose>
            		<%-- 로그인되지 않은 상태 --%>
            		<c:when test="${loginUser == null}">
		                <li>
		                    <a href="/login" title="로그인"><i class="fa fa-sign-in"></i></a>
		                </li>
		                <li>
		                    <a href="/join/agreement" title="회원가입"><i class="fa fa-user-plus"></i></a>
		                </li>
            		</c:when>
            		
            		<%-- 최고 관리자로 로그인된 상태 --%>
            		<c:when test="${loginUser.admin}">
		                <li>
		                    <a href="/admin" title="사이트 관리" target="_blank"><i class="fa fa-gear"></i></a>
		                </li>
		                <li>
		                    <a href="/user/${loginUser.no}" title="내정보"><i class="fa fa-user"></i></a>
		                </li>
		                <li>
		                    <a href="/logout" title="로그아웃"><i class="fa fa-sign-out"></i></a>
		                </li>
            		</c:when>
            		
            		<%-- 그 외: 일반 유저로 로그인된 상태 --%>
            		<c:otherwise>
		                <li>
		                    <a href="/user/${loginUser.no}" title="내정보"><i class="fa fa-user"></i></a>
		                </li>
		                <li>
		                    <a href="/logout" title="로그아웃"><i class="fa fa-sign-out"></i></a>
		                </li>
            		</c:otherwise>
            	</c:choose>
            </ul>
        </div>
        <!-- // .container -->
    </div>
    <!-- // .wrap.top -->