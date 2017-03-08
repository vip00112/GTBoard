<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8" />

<%-- meta Template --%>
<c:import url="template/meta.jsp">
	<c:param name="author"></c:param>
	<c:param name="reply"></c:param>
	<c:param name="keyword"></c:param>
	<c:param name="description"></c:param>
	<c:param name="robots">noindex, nofollow</c:param>
	<c:param name="ogType"></c:param>
	<c:param name="title">${baseSetting.title} | 사이트관리</c:param>
	<c:param name="thumbnail"></c:param>
</c:import>

<title>${baseSetting.title}-사이트관리</title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/admin.css">

<%-- IE8 이하 link Template --%>
<c:import url="template/ltIE9.jsp"></c:import>

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
		<c:param name="pageTitle">사이트 관리</c:param>
		<c:param name="pageDesc">사이트의 전반적인 정보 관리 및 설정<br />
			<br />
								 Server : <%=application.getServerInfo()%><br />
								 Servlet : <%=application.getMajorVersion()%>.<%=application.getMinorVersion()%><br />
								 JSP : <%=JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion()%>
		</c:param>
	</c:import>

	<%-- main article --%>
	<section>
		<ul class="box menu">
			<li class="base on">기본 정보 설정</li>
			<li class="boardType">게시판 설정</li>
			<li class="board">게시글 관리</li>
			<li class="comment">댓글 관리</li>
		</ul>
	</section>

	<section>
		<div class="box content base on">
			<form action="/admin/setting/base/update" method="post">
				<fieldset>
					<legend class="screen_out">기본 정보 설정</legend>
					<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

					<div class="box base">
						<h2>기본 설정</h2>

						<div class="box_wrap">
							<label for="title">Title</label>
							<div class="variable">
								<input type="text" id="title" name="title">
								<span class="desc">브라우저 및 meta 태그의 타이틀</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="logo">Logo</label>
							<div class="variable">
								<input type="text" id="logo" name="logo">
								<span class="desc">로고 이미지 경로 (미지정시 Title 표기)</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->


					</div>
					<!-- // .box.meta -->

					<div class="box meta">
						<h2>meta 태그 설정</h2>

						<div class="box_wrap">
							<label for="author">Author</label>
							<div class="variable">
								<input type="text" id="author" name="author">
								<span class="desc">해당 페이지 소유주</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="reply">Reply</label>
							<div class="variable">
								<input type="text" id="reply" name="reply">
								<span class="desc">해당 페이지 소유주의 이메일</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="keyword">Keyword</label>
							<div class="variable">
								<input type="text" id="keyword" name="keyword">
								<span class="desc">검색 엔진에 노출될 해당 페이지 키워드</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="description">Description</label>
							<div class="variable">
								<input type="text" id="description" name="description">
								<span class="desc">검색 엔진에 노출될 해당 페이지 설명</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->
					</div>
					<!-- // .box.meta -->

					<div class="box footer">
						<h2>하단 정보 설정</h2>

						<div class="box_wrap">
							<label for="businessName">상호명</label>
							<div class="variable">
								<input type="text" id="businessName" name="businessName">
								<span class="desc">footer에 표기될 사업자 등록된 상호명</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="businessNumber">사업자번호</label>
							<div class="variable">
								<input type="text" id="businessNumber" name="businessNumber">
								<span class="desc">footer에 표기될 사업자 번호</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="ceo">대표</label>
							<div class="variable">
								<input type="text" id="ceo" name="ceo">
								<span class="desc">footer에 표기될 사업자 등록된 대표명</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="address">주소</label>
							<div class="variable">
								<input type="text" id="address" name="address">
								<span class="desc">footer에 표기될 사업자 등록된 주소</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="tel">연락처</label>
							<div class="variable">
								<input type="text" id="tel" name="tel">
								<span class="desc">footer에 표기될 사업자 등록된 연락처</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="fax">팩스</label>
							<div class="variable">
								<input type="text" id="fax" name="fax">
								<span class="desc">footer에 표기될 사업자 등록된 팩스번호</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="email">이메일</label>
							<div class="variable">
								<input type="text" id="email" name="email">
								<span class="desc">footer에 표기될 사업자 등록된 이메일</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="startYear">설립년도</label>
							<div class="variable">
								<input type="text" id="startYear" name="startYear">
								<span class="desc">footer의 coptright에 표기될 설립년도</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->
					</div>
					<!-- // .box.footer -->

					<div class="box index">
						<h2>시작 페이지 게시글 갯수 설정</h2>

						<div class="box_wrap">
							<label for="indexViewCount">게시판 별 갯수</label>
							<div class="variable">
								<input type="text" id="indexViewCount" name="indexViewCount">
								<span class="desc">index 페이지에 보여질 게시판 별 게시글 갯수</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="indexViewCountTotal">전체 게시판 갯수</label>
							<div class="variable">
								<input type="text" id="indexViewCountTotal" name="indexViewCountTotal">
								<span class="desc">index 페이지에 보여질 전체 게시판 게시글 갯수</span>
							</div>
							<!-- // .variable -->
						</div>
						<!-- // .box_wrap -->
					</div>
					<!-- // .box.index -->

					<button type="submit">저장</button>
				</fieldset>
			</form>
		</div>
		<!-- // .box.content.base -->

		<div class="box content boardType">
			<form action="/admin/setting/board/update" method="post">
				<fieldset>
					<legend class="screen_out">게시판 설정</legend>
					<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

					<select name="no">
						<c:forEach items="${boardSetting.boardTypeList}" var="boardType">
							<option value="${boardType.no}">${boardType.name}</option>
						</c:forEach>
						<option value="0">신규 게시판 추가</option>
					</select>

					<div class="box_wrap">
						<label for="order">순서</label>
						<div class="variable">
							<input type="text" id="order" name="order" value="">
							<span class="desc">index 페이지 및 메뉴 표기 순서</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="name">이름</label>
						<div class="variable">
							<input type="text" id="name" name="name" value="">
							<span class="desc">화면에 보여지는 이름</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="boardDescription">설명</label>
						<div class="variable">
							<input type="text" id="boardDescription" name="description" value="">
							<span class="desc">해당 게시판의 간략한 설명</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="url">URL</label>
						<div class="variable">
							<input type="text" id="url" name="url" value="">
							<span class="desc">주소창에 보여질 영문주소</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="use">게시판 활성화</label>
						<div class="variable">
							<select name="use">
								<option value="true">활성화</option>
								<option value="false">비활성화</option>
							</select>
							<span class="desc">비활성화시 접근 불가</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="anonymous">글쓴이 공개</label>
						<div class="variable">
							<select name="anonymous">
								<option value="false">공개</option>
								<option value="true">익명</option>
							</select>
							<span class="desc">게시글 및 댓글 작성자 익명 여부</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="secret">비밀 게시글</label>
						<div class="variable">
							<select name="secret">
								<option value="false">공개 글</option>
								<option value="true">비밀 글</option>
							</select>
							<span class="desc">비밀 글은 작성자와 운영자만 열람 가능</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="album">기본 보기 형식</label>
						<div class="variable">
							<select name="album">
								<option value="false">리스트</option>
								<option value="true">앨범</option>
							</select>
							<span class="desc">앨범 보기시 썸네일 이미지 표기</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="useComment">댓글</label>
						<div class="variable">
							<select name="useComment">
								<option value="true">사용</option>
								<option value="false">미사용</option>
							</select>
							<span class="desc">미사용시 댓글 작성 불가</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="useAttachFile">첨부파일</label>
						<div class="variable">
							<select name="useAttachFile">
								<option value="false">미사용</option>
								<option value="true">사용</option>
							</select>
							<span class="desc">첨부파일 허용 여부</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="useWriteCode">OCR: 글 작성</label>
						<div class="variable">
							<select name="useWriteCode">
								<option value="true">사용</option>
								<option value="false">미사용</option>
							</select>
							<span class="desc">글 작성시 도배 방지 코드 적용</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="useCommentCode">OCR: 댓글 작성</label>
						<div class="variable">
							<select name="useCommentCode">
								<option value="true">사용</option>
								<option value="false">미사용</option>
							</select>
							<span class="desc">댓글 작성시 도배 방지 코드 적용</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="writePoint">글 작성 포인트</label>
						<div class="variable">
							<input type="text" id="writePoint" name="writePoint" value="">
							<span class="desc">글 작성시 작성자에게 지급할 포인트</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="downloadPoint">다운로드 소모 포인트</label>
						<div class="variable">
							<input type="text" id="downloadPoint" name="downloadPoint" value="">
							<span class="desc">첨부파일 다운로드시 필요한 포인트</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="commentPoint">댓글 작성 포인트</label>
						<div class="variable">
							<input type="text" id="commentPoint" name="commentPoint" value="">
							<span class="desc">댓글 작성시 작성자에게 지급할 포인트</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="thumbPoint">추천 포인트</label>
						<div class="variable">
							<input type="text" id="thumbPoint" name="thumbPoint" value="">
							<span class="desc">게시글 추천시 작성자에게 지급할 포인트</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="popularThumb">인기글 추천 갯수</label>
						<div class="variable">
							<input type="text" id="popularThumb" name="popularThumb" value="">
							<span class="desc">인기글이 되기위한 최소 추천 갯수</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="writeGrade">글작성 등급</label>
						<div class="variable">
							<input type="text" id="writeGrade" name="writeGrade" value="">
							<span class="desc">글 작성이 가능한 등급</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="readGrade">글읽기 등급</label>
						<div class="variable">
							<input type="text" id="readGrade" name="readGrade" value="">
							<span class="desc">게시글 읽기가 가능한 등급</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="commentGrade">댓글작성 등급</label>
						<div class="variable">
							<input type="text" id="commentGrade" name="commentGrade" value="">
							<span class="desc">댓글 작성이 가능한 등급</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="downloadGrade">다운로드 등급</label>
						<div class="variable">
							<input type="text" id="downloadGrade" name="downloadGrade" value="">
							<span class="desc">첨부파일 다운로드가 가능한 등급</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<div class="box_wrap">
						<label for="adminGrade">관리자 등급</label>
						<div class="variable">
							<input type="text" id="adminGrade" name="adminGrade" value="">
							<span class="desc">게시판 관리자 등급(수정/삭제 가능)</span>
						</div>
						<!-- // .variable -->
					</div>
					<!-- // .box_wrap -->

					<button type="submit">저장</button>
				</fieldset>
			</form>
		</div>
		<!-- // .box.content.board -->

		<div class="box content board"></div>
		<!-- // .box.content.board -->

		<div class="box content comment"></div>
		<!-- // .box.content.comment -->
	</section>
	<%-- // main article --%>

	<%-- footer Template --%>
	<c:import url="template/footer.jsp"></c:import>

	<!-- 공통 -->
	<script>
		$(window).load(function() {
			if ($(".box.content.base").hasClass("on")) {
				getBaseInfo();
			} else if ($(".box.content.boardType").hasClass("on")) {
				getBoardTypeInfo();
			}
		});

		// menu 변경
		$(".box.menu li").click(function() {
			$(".box.menu li").removeClass("on");
			$(".content.box").removeClass("on");

			var className = $(this).attr("class");
			$(this).addClass("on");
			$(".content.box." + className).addClass("on");

			if (className == "base") {
				getBaseInfo();
			} else if (className == "boardType") {
				getBoardTypeInfo();
			}
		});

		function setValue($form, infoObj) {
			for (attr in infoObj) {
				if (typeof infoObj[attr] === "boolean") {
					$select = $form.find("select[name='" + attr + "']");
					$select.val(infoObj[attr].toString());
				} else {
					var $input = $form.find("input[name='" + attr + "']");
					$input.val(infoObj[attr]);
				}
			}
		}
	</script>

	<!-- 기본 정보 설정 -->
	<script>
		function getBaseInfo() {
			$.ajax("/admin/setting/base", {
				type: "GET",
				dataType: "json"
			}).fail(function(xhr, error, code) {
				alert(error + " : " + code);
				console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
			}).done(function(info) {
				setValue($(".box.content.base form"), info);
			});
		}
	</script>

	<!-- 게시판 설정 -->
	<script>
		$(".box.content.boardType select[name='no']").change(function() {
			if ($(this).val() == 0) {
				$(".box.content.boardType input[name!='CSRFToken']").val("");
				$(".box.content.boardType select").val("false");
				$(this).val(0);
			} else {
				getBoardTypeInfo();
			}
		});

		function getBoardTypeInfo() {
			var no = $(".box.content.boardType select[name=no]").val();
			if (no == 0) {
				return;
			}
			$.ajax("/admin/setting/board", {
				type: "GET",
				dataType: "json",
				data: {
					no: no
				}
			}).fail(function(xhr, error, code) {
				alert(error + " : " + code);
				console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
			}).done(function(info) {
				setValue($(".box.content.boardType form"), info);
			});
		}
	</script>
</body>

</html>