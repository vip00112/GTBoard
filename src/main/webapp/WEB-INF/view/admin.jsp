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
	<div class="loading"></div>
	<!-- // .loading -->

	<aside class="menu">
		<button class="on">
			<i class="fa fa-caret-left fa-fw fa-2x"></i>
		</button>

		<ul>
			<li class="base on">기본 정보 설정</li>
            <li class="nav">메뉴 설정</li>
			<li class="boardType">게시판 설정</li>
			<li class="board">게시글 관리</li>
			<li class="comment">댓글 관리</li>
		</ul>
	</aside>

	<section class="content">
		Server :
		<%=application.getServerInfo()%>
		<br />
		Servlet :
		<%=application.getMajorVersion()%>.<%=application.getMinorVersion()%>
		<br />
		JSP :
		<%=JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion()%>
		<br />

		<div class="box base on">
			<h2>기본 정보 설정</h2>

			<form action="/admin/setting/base/update" method="post">
				<fieldset>
					<legend class="screen_out">기본 정보 설정</legend>
					<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

					<div class="box">
						<h3>기본 설정</h3>

						<div class="box_wrap">
							<label>Title</label>
							<input type="text" name="title" value="">
							<span class="desc">브라우저 및 meta 태그의 타이틀</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>Logo</label>
							<input type="text" name="logo" value="">
							<span class="desc">로고 이미지 경로 (미지정시 Title 표기)</span>
						</div>
						<!-- // .box_wrap -->
					</div>
					<!-- // .box -->

					<div class="box">
						<h3>meta 태그 설정</h3>

						<div class="box_wrap">
							<label for="athor">Author</label>
							<input type="text" id="athor" name="athor" value="">
							<span class="desc">해당 페이지 소유주</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>Reply</label>
							<input type="text" name="reply" value="">
							<span class="desc">해당 페이지 소유주의 이메일</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>Keyword</label>
							<input type="text" name="keyword" value="">
							<span class="desc">검색 엔진에 노출될 해당 페이지 키워드</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>Description</label>
							<input type="text" name="description" value="">
							<span class="desc">검색 엔진에 노출될 해당 페이지 설명</span>
						</div>
						<!-- // .box_wrap -->
					</div>
					<!-- // .box -->

					<div class="box">
						<h3>하단 정보 설정</h3>

						<div class="box_wrap">
							<label>상호명</label>
							<input type="text" name="businessName" value="">
							<span class="desc">footer에 표기될 사업자 등록된 상호명</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>사업자번호</label>
							<input type="text" name="businessNumber" value="">
							<span class="desc">footer에 표기될 사업자 번호</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>대표</label>
							<input type="text" name="ceo" value="">
							<span class="desc">footer에 표기될 사업자 등록된 대표명</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>주소</label>
							<input type="text" name="address" value="">
							<span class="desc">footer에 표기될 사업자 등록된 주소</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>연락처</label>
							<input type="text" name="tel" value="">
							<span class="desc">footer에 표기될 사업자 등록된 연락처</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>팩스</label>
							<input type="text" name="fax" value="">
							<span class="desc">footer에 표기될 사업자 등록된 팩스번호</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>이메일</label>
							<input type="text" name="email" value="">
							<span class="desc">footer에 표기될 사업자 등록된 이메일</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>설립년도</label>
							<input type="text" name="startYear" value="">
							<span class="desc">footer의 coptright에 표기될 설립년도</span>
						</div>
						<!-- // .box_wrap -->
					</div>
					<!-- // .box -->

					<div class="box">
						<h3>시작 페이지 게시글 갯수 설정</h3>

						<div class="box_wrap">
							<label>게시판 별 갯수</label>
							<input type="text" name="indexViewCount" value="">
							<span class="desc">index 페이지에 보여질 게시판 별 게시글 갯수</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>전체 게시판 갯수</label>
							<input type="text" name="indexViewCountTotal" value="">
							<span class="desc">index 페이지에 보여질 전체 게시판 게시글 갯수</span>
						</div>
						<!-- // .box_wrap -->
					</div>
					<!-- // .box -->

					<button>저장</button>
				</fieldset>
			</form>
		</div>
		<!-- // .box.base -->

		<div class="box boardType">
			<h2>게시판 설정</h2>

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

					<div class="box">
						<h3>필수 기본 설정</h3>

						<div class="box_wrap">
							<label>순서</label>
							<input type="text" name="order" value="">
							<span class="desc">index 페이지 및 메뉴 표기 순서</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>이름</label>
							<input type="text" name="name" value="">
							<span class="desc">화면에 보여지는 이름</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>설명</label>
							<input type="text" name="description" value="">
							<span class="desc">해당 게시판의 간략한 설명</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>URL</label>
							<input type="text" name="url" value="">
							<span class="desc">주소창에 보여질 영문주소</span>
						</div>
						<!-- // .box_wrap -->
					</div>
					<!-- // .box -->

					<div class="box">
						<h3>ON/OFF 설정</h3>

						<div class="box_wrap">
							<label>게시판 활성화</label>
							<select name="use">
								<option value="true">활성화</option>
								<option value="false">비활성화</option>
							</select>
							<span class="desc">비활성화시 접근 불가</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>글쓴이 공개</label>
							<select name="anonymous">
								<option value="false">공개</option>
								<option value="true">익명</option>
							</select>
							<span class="desc">게시글 및 댓글 작성자 익명 여부</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap" data-low="useComment,useAttachFile,useWriteCode,useCommentCode,readGrade" data-on="false">
							<label>비밀 게시글</label>
							<select name="secret">
								<option value="false">공개 글</option>
								<option value="true">비밀 글</option>
							</select>
							<span class="desc">비밀 글은 작성자와 운영자만 열람 가능</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>기본 보기 형식</label>
							<select name="album">
								<option value="false">리스트</option>
								<option value="true">앨범</option>
							</select>
							<span class="desc">앨범 보기시 썸네일 이미지 표기</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap" data-low="useCommentCode,commentPoint,commentGrade" data-on="true">
							<label>댓글</label>
							<select name="useComment">
								<option value="false">미사용</option>
								<option value="true">사용</option>
							</select>
							<span class="desc">미사용시 댓글 작성 불가</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap" data-low="downloadPoint,downloadGrade" data-on="true">
							<label>첨부파일</label>
							<select name="useAttachFile">
								<option value="false">미사용</option>
								<option value="true">사용</option>
							</select>
							<span class="desc">첨부파일 허용 여부</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>OCR: 글 작성</label>
							<select name="useWriteCode">
								<option value="false">미사용</option>
								<option value="true">사용</option>
							</select>
							<span class="desc">글 작성시 도배 방지 코드 적용</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label for="useCommentCode">OCR: 댓글 작성</label>
							<select name="useCommentCode">
								<option value="false">미사용</option>
								<option value="true">사용</option>
							</select>
							<span class="desc">댓글 작성시 도배 방지 코드 적용</span>
						</div>
						<!-- // .box_wrap -->
					</div>
					<!-- // .box -->

					<div class="box">
						<h3>값 설정</h3>

						<div class="box_wrap">
							<label>글 작성 포인트</label>
							<input type="text" name="writePoint" value="">
							<span class="desc">글 작성시 작성자에게 지급할 포인트</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>댓글 작성 포인트</label>
							<input type="text" name="commentPoint" value="">
							<span class="desc">댓글 작성시 작성자에게 지급할 포인트</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>추천 포인트</label>
							<input type="text" name="thumbPoint" value="">
							<span class="desc">게시글 추천시 작성자에게 지급할 포인트</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>다운로드 소모 포인트</label>
							<input type="text" name="downloadPoint" value="">
							<span class="desc">첨부파일 다운로드시 필요한 포인트</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>인기글 추천 갯수</label>
							<input type="text" name="popularThumb" value="">
							<span class="desc">인기글이 되기위한 최소 추천 갯수</span>
						</div>
						<!-- // .box_wrap -->
					</div>
					<!-- // .box -->

					<div class="box">
						<h3>등급 설정</h3>

						<div class="box_wrap">
							<label>글작성 등급</label>
							<input type="text" name="writeGrade" value="">
							<span class="desc">글 작성이 가능한 등급</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>글읽기 등급</label>
							<input type="text" name="readGrade" value="">
							<span class="desc">게시글 읽기가 가능한 등급</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>댓글작성 등급</label>
							<input type="text" name="commentGrade" value="">
							<span class="desc">댓글 작성이 가능한 등급</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>다운로드 등급</label>
							<input type="text" name="downloadGrade" value="">
							<span class="desc">첨부파일 다운로드가 가능한 등급</span>
						</div>
						<!-- // .box_wrap -->

						<div class="box_wrap">
							<label>관리자 등급</label>
							<input type="text" name="adminGrade" value="">
							<span class="desc">게시판 관리자 등급(수정/삭제 가능)</span>
						</div>
						<!-- // .box_wrap -->
					</div>
					<!-- // .box -->

					<button type="submit">저장</button>
				</fieldset>
			</form>
		</div>
		<!-- // .box.boardType -->

		<div class="box nav">
			<h2>메뉴 설정</h2>
		</div>
		<!-- // .box.nav -->

		<div class="box board">
			<h2>게시글 관리</h2>
		</div>
		<!-- // .box.board -->

		<div class="box comment">
			<h2>댓글 관리</h2>
		</div>
		<!-- // .box.comment -->
	</section>

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

	<!-- underscore setting -->
	<script>
		_.templateSettings = {
			interpolate: /\<\@\=(.+?)\@\>/gim,
			evaluate: /\<\@(.+?)\@\>/gim,
			escape: /\<\@\-(.+?)\@\>/gim
		};
	</script>

	<!-- 공통 -->
	<script>
		var $menu = $(".menu");
		var $content = $(".content");
		var $loader = $("body>.loading");

		$(window).load(function() {
			if ($(".content .box.base").hasClass("on")) {
				getBaseInfo();
			} else if ($(".content .box.boardType").hasClass("on")) {
				getBoardTypeInfo();
			}
		});

		// 메뉴 펼침/닫힘
		$(".menu button").click(function() {
			var $btn = $(this);
			$btn.toggleClass("on");
			var $icon = $btn.find(".fa");

			if ($btn.hasClass("on")) {
				$icon.removeClass("fa-caret-right");
				$icon.addClass("fa-caret-left");
				$menu.animate({
					left: 0
				}, 200);
				$content.animate({
					left: 150
				}, 200);
			} else {
				$icon.removeClass("fa-caret-left");
				$icon.addClass("fa-caret-right");
				$menu.animate({
					left: -150
				}, 200);
				$content.animate({
					left: 0
				}, 200);
			}
		});

		// 메뉴 변경
		$(".menu li").click(function() {
			$(".menu li").removeClass("on");
			$(".content .box").removeClass("on");

			var className = $(this).attr("class");
			$(this).addClass("on");
			$(".content .box." + className).addClass("on");

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
				dataType: "json",
				beforeSend: function() {
					$loader.show();
				}
			}).always(function() {
				$loader.fadeOut(200);
			}).fail(function(xhr, error, code) {
				alert(error + " : " + code);
				console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
			}).done(function(info) {
				setValue($(".content .box.base form"), info);
			});
		}
	</script>

	<!-- 게시판 설정 -->
	<script>
		$(".content .box.boardType select[name='no']").change(function() {
			if ($(this).val() == 0) {
				$(".content .box.boardType input[name!='CSRFToken']").val("");
				$(".content .box.boardType select").val("true");
				$(this).val(0);

				$(".content .box.boardType [name='anonymous']").val("false");
				$(".content .box.boardType [name='secret']").val("false");
				$(".content .box.boardType [name='album']").val("false");
				$(".content .box.boardType [name='writePoint']").val("0");
				$(".content .box.boardType [name='commentPoint']").val("0");
				$(".content .box.boardType [name='thumbPoint']").val("0");
				$(".content .box.boardType [name='downloadPoint']").val("0");
				$(".content .box.boardType [name='popularThumb']").val("0");
				$(".content .box.boardType [name='writeGrade']").val("1");
				$(".content .box.boardType [name='readGrade']").val("0");
				$(".content .box.boardType [name='commentGrade']").val("1");
				$(".content .box.boardType [name='downloadGrade']").val("1");
				$(".content .box.boardType [name='adminGrade']").val("9999");
				
				$(".content .box.boardType select[name!='no']").each(function() {
					var lows = $(this).parents(".box_wrap").attr("data-low");
					var value = $(this).parents(".box_wrap").attr("data-on");
					if (!lows || !value) {
						return;
					}

					var show = $(this).val() == value;
					lows = lows.split(",");
					toggleLows(show, lows);
				});
			} else {
				getBoardTypeInfo();
			}
		});

		$(".content .box.boardType select[name!='no']").change(function() {
			var lows = $(this).parents(".box_wrap").attr("data-low");
			var value = $(this).parents(".box_wrap").attr("data-on");
			if (!lows || !value) {
				return;
			}

			var show = $(this).val() == value;
			lows = lows.split(",");
			toggleLows(show, lows);
		});

		// 하위 항목 ON/OFF
		function toggleLows(show, lows) {
			for (var i = 0, length = lows.length; i < length; i++) {
				var name = lows[i];
				var children = $(".content .box.boardType [name='" + name + "']");
				if (show) {
					children.parents(".box_wrap").show();
				} else {
					children.parents(".box_wrap").hide();
				}

				// 대상의 하위항목이 있을시 추가 ON/OFF
				var lowers = children.parents(".box_wrap").attr("data-low");
				var value = children.parents(".box_wrap").attr("data-on");
				if (lowers && value) {
					lowers = lowers.split(",");
					if (show) {
						var lowerShow = children.val() == value;
						toggleLows(lowerShow, lowers);
					} else {
						toggleLows(show, lowers);
					}
				}
			}
		}

		function getBoardTypeInfo() {
			var no = $(".content .box.boardType select[name=no]").val();
			if (no == 0) {
				return;
			}
			$.ajax("/admin/setting/board", {
				type: "GET",
				dataType: "json",
				data: {
					no: no
				},
				beforeSend: function() {
					$loader.show();
				}
			}).always(function() {
				$loader.fadeOut(200);
			}).fail(function(xhr, error, code) {
				alert(error + " : " + code);
				console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
			}).done(function(info) {
				setValue($(".content .box.boardType form"), info);
				
				$(".content .box.boardType select[name!='no']").each(function() {
					var lows = $(this).parents(".box_wrap").attr("data-low");
					var value = $(this).parents(".box_wrap").attr("data-on");
					if (!lows || !value) {
						return;
					}

					var show = $(this).val() == value;
					lows = lows.split(",");
					toggleLows(show, lows);
				});
			});
		}
	</script>
</body>

</html>