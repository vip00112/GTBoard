<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

			</article>
		</main>
		<!-- // main.container -->
    </div>
    <!-- // .wrap.main -->

	<div class="wrap footer">
		<footer class="container">
			<ul>
				<li>
					<a href="/agreement/terms">이용약관</a>
				</li>
				<li>
					<a href="/agreement/privacy">개인정보 취급 방침</a>
				</li>
				<li>
					<a href="/agreement/youth">청소년 보호 정책</a>
				</li>
				<li>
					<a href="/agreement/email">이메일 무단 수집 거부</a>
				</li>
			</ul>
			<dl>
				<c:if test="${baseSetting.businessName != null && baseSetting.businessName != ''}">
					<dt>상호</dt>
					<dd title="${baseSetting.businessName}">${baseSetting.businessName}</dd>
				</c:if>
	
				<c:if test="${baseSetting.ceo != null && baseSetting.ceo != ''}">
					<dt>대표</dt>
					<dd title="${baseSetting.ceo}">${baseSetting.ceo}</dd>
				</c:if>
	
				<c:if test="${baseSetting.tel != null && baseSetting.tel != ''}">
					<dt>전화</dt>
					<dd title="${baseSetting.tel}">${baseSetting.tel}</dd>
				</c:if>
	
				<c:if test="${baseSetting.fax != null && baseSetting.fax != ''}">
					<dt>팩스</dt>
					<dd title="${baseSetting.fax}">${baseSetting.fax}</dd>
				</c:if>
	
				<c:if test="${baseSetting.email != null && baseSetting.email != ''}">
					<dt>이메일</dt>
					<dd title="${baseSetting.email}">${baseSetting.email}</dd>
				</c:if>
	
				<c:if test="${baseSetting.address != null && baseSetting.address != ''}">
					<dt>사업지</dt>
					<dd title="${baseSetting.address}">${baseSetting.address}</dd>
				</c:if>
	
				<c:if test="${baseSetting.businessNumber != null && baseSetting.businessNumber != ''}">
					<dt>사업자등록번호</dt>
					<dd title="${baseSetting.businessNumber}">${baseSetting.businessNumber}</dd>
				</c:if>
			</dl>
			<small>&copy; 2016. ${baseSetting.title}. All right reserved.</small>
		</footer>
		<!-- // footer.container -->
	</div>
	<!-- // .wrap.footer -->
	
	<%-- resultMsg --%>
	<c:if test="${resultMsg != null}">
		<div id="resultMsg">
			<div id="msgBox">
				<p class="msg">${resultMsg}</p>
				<button>확인</button>
			</div>
			<!-- // msgBox -->
		</div>
		<!-- // resultMsg -->
	</c:if>
	
	<!-- script load -->
	<script src="/resources/js/jquery.min.js"></script>
	<script src="/resources/js/underscore-min.js"></script>
	<script src="/resources/js/moment.min.js"></script>
	<script src="/resources/js/moment-with-locales.min.js"></script>
	<script src="/resources/js/gtboard.js?ver=0001"></script>
	<script src="/resources/js/common.js?ver=0001"></script>
	<script src="/resources/js/fix.js?ver=0001"></script>
	<script src="/resources/js/board.js?ver=0001"></script>
	<script src="/resources/js/comment.js?ver=0001"></script>
	<script src="/resources/js/paginate.js?ver=0001"></script>
	
	<%-- resultMsg --%>
	<c:if test="${resultMsg != null}">
		<script>
			$(window).load(function() {
				$("#resultMsg").show();
				$("#resultMsg #msgBox button").focus();
			});
	
			//resultMsg 닫기
			$("#resultMsg #msgBox button").click(function() {
				$("#resultMsg").fadeOut(200);
			}).focusout(function() {
	            $(this).focus();
	        }).keydown(function(e) {
	            if (e.keyCode != 32 && e.keyCode != 13) {
	                return false;
	            }
	        });
		</script>
		<c:remove var="resultMsg" />
	</c:if>
	
	<!-- underscore setting -->
	<script>
		_.templateSettings = {
			interpolate:/\<\@\=(.+?)\@\>/gim,
			evaluate:/\<\@(.+?)\@\>/gim,
			escape:/\<\@\-(.+?)\@\>/gim
		};
	</script>