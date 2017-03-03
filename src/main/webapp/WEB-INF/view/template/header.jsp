<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

    <div class="wrap header">
        <header class="container">
            <nav class="gnav">
                <ul class="menu">
                    <li>
                        <a href="/notice"><i class="fa fa-bolt fa-fw"></i> 공지사항</a>
                    </li>
                    <li>
                        <a href="#" onclick="return false;"><i class="fa fa-bars fa-fw"></i> 유저 게시판</a>

                        <ul class="menu sub">
                            <li><a href="/board/all">전체 보기</a></li>
							<c:forEach items="${boardSetting.boardTypeList}" var="boardType">
								<c:if test="${boardType.use}">
	                                <li><a href="/board/${boardType.url}">${boardType.name}</a></li>
								</c:if>
							</c:forEach>
                        </ul>
                    </li>
                    <li>
                        <a href="#" onclick="return false;"><i class="fa fa-bell fa-fw"></i> Q&amp;A</a>

                        <ul class="menu sub">
                            <li><a href="">문의 게시판</a></li>
                            <li><a href="">신고 게시판</a></li>
                            <li><a href="">1:1 문의 메일</a></li>
                        </ul>
                    </li>
                    <li>
                        <a href="#" onclick="return false;"><i class="fa fa-smile-o fa-fw"></i> 광고 센터</a>

                        <ul class="menu sub">
                            <li><a href="">전체 보기</a></li>
                            <li><a href="">광고 문의</a></li>
                        </ul>
                    </li>
                    <li>
                        <a href="#" onclick="return false;"><i class="fa fa-user fa-fw"></i> 회원 정보</a>

                        <ul class="menu sub">
			            	<c:choose>
			            		<%-- 로그인되지 않은 상태 --%>
			            		<c:when test="${loginUser == null}">
					                <li>
					                    <a href="/login" title="로그인">로그인</a>
					                </li>
					                <li>
					                    <a href="/join/agreement" title="회원가입">회원가입</a>
					                </li>
			            		</c:when>
			            		
			            		<%-- 최고 관리자로 로그인된 상태 --%>
			            		<c:when test="${loginUser.admin}">
					                <li>
					                    <a href="/admin" title="사이트 관리">사이트 관리</a>
					                </li>
					                <li>
					                    <a href="/user/${loginUser.no}" title="내정보">내정보</a>
					                </li>
					                <li>
					                    <a href="/logout" title="로그아웃">로그아웃</a>
					                </li>
			            		</c:when>
			            		
			            		<%-- 그 외: 일반 유저로 로그인된 상태 --%>
			            		<c:otherwise>
					                <li>
					                    <a href="/user/${loginUser.no}" title="내정보">내정보</a>
					                </li>
					                <li>
					                    <a href="/logout" title="로그아웃">로그아웃</a>
					                </li>
			            		</c:otherwise>
			            	</c:choose>
                        </ul>
                    </li>
                </ul>
            </nav>
            
        	<h1 class="screen_out">${baseSetting.title}</h1>
        </header>
        <!-- // header.container -->
    </div>
    <!-- // .wrap.header -->