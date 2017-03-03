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
	<c:param name="description">회원정보를 관리할 수 있습니다.</c:param>
	<c:param name="robots">noindex, nofollow</c:param>
	<c:param name="ogType"></c:param>
	<c:param name="title">${baseSetting.title} | 내정보</c:param>
	<c:param name="thumbnail"></c:param>
</c:import>

<title>${baseSetting.title}-내정보</title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/myPage.css">

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
		<c:param name="pageTitle">내 정보 관리</c:param>
		<c:param name="pageDesc">회원정보를 관리할 수 있습니다.</c:param>
	</c:import>

	<%-- main article --%>
	<section>
		<ul class="box menu">
			<li class="info on">내 정보 조회</li>
			<li class="board">게시글 관리</li>
			<li class="comment">댓글 관리</li>
			<li class="shop">포인트 상점</li>
			<li class="point">포인트 내역</li>
			<li class="nickname">닉네임 변경</li>
			<li class="pw">비밀번호 변경</li>
			<li class="leave">회원탈퇴</li>
		</ul>
	</section>

	<section>
		<div class="box content info on">
			<dl>
				<dt>이메일</dt>
				<dd>${loginUser.email}</dd>

				<dt>닉네임</dt>
				<dd>${loginUser.nickname}</dd>

				<dt>등급(레벨)</dt>
				<dd>
					LV
					<b>${loginUser.grade}</b>
				</dd>

				<dt>보유 포인트</dt>
				<dd>
					<b>${loginUser.point}</b>
					P
				</dd>

				<dt>작성 게시글</dt>
				<dd>
					<b>0</b>
					개
				</dd>

				<dt>작성 댓글</dt>
				<dd>
					<b>0</b>
					개
				</dd>
			</dl>
		</div>
		<!-- // .box.content.info -->

		<div class="box content board">
			<div class="board_frame my">
				<div class="loading"></div>
				<!-- // .loading -->

				<div class="box_option">
					<div class="view_type option">
						<ul title="게시글 형식">
							<li class="list on">
								<i class="fa fa-bars"></i>
								리스트
							</li>
							<li class="album">
								<i class="fa fa-th"></i>
								앨범
							</li>
						</ul>
					</div>
					<!-- // .view_type -->

					<div class="view_count option">
						<ul title="게시글 갯수">
							<li data-value="10">10개</li>
							<li data-value="30" class="on">30개</li>
							<li data-value="50">50개</li>
						</ul>
					</div>
					<!-- // .view_count -->

					<div class="view_order option">
						<ul title="게시글 정렬">
							<li data-value="regdate_DESC" class="on">최신순</li>
							<li data-value="hit_DESC">조회순</li>
							<li data-value="thumb_DESC">추천순</li>
							<li data-value="commentCount_DESC">댓글순</li>
						</ul>
					</div>
					<!-- // .view_order-->
				</div>
				<!-- // .box_option -->

				<div class="box_select">
					<form action="/user/${loginUser.no}/board/delete" method="post" class="form_delete">
						<fieldset>
							<legend class="screen_out">선택 삭제 폼</legend>
							<input type="hidden" name="CSRFToken" value="${CSRFToken}" />
							<input type="hidden" name="_method" value="DELETE">
							<input type="hidden" name="boardNo">
							<input type="checkbox" id="checkAllBoard">
							<label for="checkAllBoard">전체선택</label>
							<button class="btn delete" title="선택 항목 삭제">
								<i class="fa fa-trash"></i>
							</button>
						</fieldset>
					</form>
				</div>
				<!-- // .box_select -->

				<ul class="line top">
					<li class="type">구분</li>
					<li class="no">번호</li>
					<li class="title">제목</li>
					<li class="date">작성일</li>
					<li class="hit">조회</li>
					<li class="thumb">추천</li>
				</ul>

				<div class="box_item">
					<%-- boardTmp --%>
				</div>
				<!-- // .box_item -->

				<div class="paginate">
					<%-- ajax --%>
				</div>
				<!-- // .paginate -->

				<form action="/user/${loginUser.no}/board/list" class="form_search" method="post">
					<fieldset>
						<legend class="screen_out">검색 폼</legend>
						<input type="hidden" name="CSRFToken" value="${CSRFToken}" />
						<input type="hidden" name="pageNo" />
						<input type="hidden" name="numPage" />
						<input type="hidden" name="order" />

						<select name="searchType">
							<option value="title" <c:if test="${searchType eq 'title'}">selected</c:if>>글 제목</option>
							<option value="content" <c:if test="${searchType eq 'content'}">selected</c:if>>글 내용</option>
							<option value="title_content" <c:if test="${searchType eq 'title_content'}">selected</c:if>>글 제목 + 글 내용</option>
						</select>
						<div class="box search">
							<input type="search" name="search" value="${search}" placeholder="검색어" />
						</div>
						<button type="submit" class="btn search">
							<i class="fa fa-search"></i>
						</button>
					</fieldset>
				</form>
			</div>
			<!-- // .board_frame -->
		</div>
		<!-- // .box.content.board -->

		<div class="box content comment">
			<div class="comment_frame">
				<div class="loading"></div>
				<!-- // .loading -->

				<div class="box_select">
					<form action="/user/${loginUser.no}/comment/delete" method="post" class="form_delete">
						<fieldset>
							<legend class="screen_out">선택 삭제 폼</legend>
							<input type="hidden" name="CSRFToken" value="${CSRFToken}" />
							<input type="hidden" name="_method" value="DELETE">
							<input type="hidden" name="commentNo">
							<input type="checkbox" id="checkAllComment">
							<label for="checkAllComment">전체선택</label>
							<button class="btn delete" title="선택 항목 삭제">
								<i class="fa fa-trash"></i>
							</button>
						</fieldset>
					</form>
				</div>
				<!-- // .box_select -->

				<div class="box_item">
					<%-- commentTmp --%>
				</div>
				<!-- // .box_item -->

				<div class="paginate">
					<%-- ajax --%>
				</div>
				<!-- // .paginate -->
			</div>
			<!-- // .comment_frame -->
		</div>
		<!-- // .box.content.board -->

		<div class="box content shop"></div>
		<!-- // .box.content.board -->

		<div class="box content point"></div>
		<!-- // .box.content.board -->

		<div class="box content nickname"></div>
		<!-- // .box.content.info -->

		<div class="box content pw"></div>
		<!-- // .box.content.info -->

		<div class="box content leave"></div>
		<!-- // .box.content.info -->
	</section>
	<%-- // main article --%>

	<%-- footer Template --%>
	<c:import url="template/footer.jsp"></c:import>

	<!-- boardTmp -->
	<script type="text/template" id="boardTmp">
	<@ _.each(list, function(board) { @>
		<ul class="line item">
			<li class="delete">
				<input type="checkbox">
			</li>
			<li class="type">
				<a href="/board/<@=board.boardType.url@>"><@=board.boardType.name@></a>
			</li>
			<li class="no"><@=board.no@></li>
			<li class="thumbnail">
				<a href="/board/<@=board.no@>">
					<@ var thumbnail = board.defaultThumbnail; @>
					<@ if (board.thumbnail != null) { thumbnail = board.thumbnail; } @>
					<img alt="썸네일 이미지" src="<@=thumbnail@>">
				</a>
			</li>
			<li class="title <@if(board.popular){@>popular<@}@>" title="<@=changeEntities(board.title)@>">
				<a href="/board/<@=board.no@>" class="<@=board.titleClass@>">
					<@=changeEntities(board.title)@>
				</a>
				<@ if (board.includeImg) { @>
					<span class="image"></span>
				<@ } @>
				<@ if (board.boardType.useComment && board.commentCount > 0) { @>
					<span class="count_comment" title="댓글 수"><@=board.commentCount@></span>
				<@ } @>
				<@ if (board.recent) { @>
					<span class="new" title="신규 글"></span>
				<@ } @>
			</li>
			<li class="nickname"><@=board.nickname@></li>
			<li class="date" title="<@=board.viewRegdateFull@>"><@=board.viewRegdate@></li>
			<li class="hit"><@=board.hit@></li>
			<li class="thumb"><@=board.thumb@></li>
		</ul>
	<@ }) @>
	</script>

	<!-- commentTmp -->
	<script type="text/template" id="commentTmp">
	<@ _.each(list, function(comment) { @>
		<ul class="comment item">
			<li class="delete">
				<input type="checkbox">
			</li>
			<li class="no"><@=comment.no@></li>
			<li class="nickname"><@=comment.nickname@></li>
			<li class="date"><@=comment.viewRegdateFull@></li>
			<li class="text" title="<@=changeEntities(comment.content)@>"><@=changeEntities(comment.content)@></li>
		</ul>
	<@ }) @>
	</script>

	<!-- 공통 -->
	<script>
		// menu 변경
		$(".box.menu li").click(function() {
			$(".box.menu li").removeClass("on");
			$(".box.content").removeClass("on");

			var className = $(this).attr("class");
			$(this).addClass("on");
			$(".box.content." + className).addClass("on");

			if (className == "board") {
				getBoardList();
			} else if (className == "comment") {
				getCommentList();
			}
		});
	</script>

	<!-- 게시글 관리 -->
	<script>
		var $boardLoader = $(".box.board .loading");
		var $boardCheckBox = $(".box.board #checkAllBoard");
		var boardTmpFunc = _.template($("#boardTmp").html());

		// 페이지네이트 설정
		var boardPaginate = new Paginate(".board_frame .paginate", {
			preventDefault: true,
			onPageClick: function() {
				getBoardList();
				$("html,body").animate({
					scrollTop: $(".board_frame").offset().top - 50
				}, 200);
			}
		});

		// 게시글 관리: 게시글 목록 취득
		function getBoardList(pageNo) {
			if (typeof pageNo === "undefined") {
				pageNo = boardPaginate.getCurrentPage();
				if (pageNo == 0) {
					pageNo = 1;
				}
			}
			$boardCheckBox.prop("checked", false);

			$.ajax("/user/${loginUser.no}/board/list", {
				type: "GET",
				dataType: "json",
				data: {
					searchType: $(".board_frame .form_search select[name='searchType']").val(),
					search: $(".board_frame .form_search input[name='search']").val(),
					pageNo: pageNo,
					numPage: $(".board_frame .box_option .view_count ul li.on").attr("data-value"),
					order: $(".board_frame .box_option .view_order ul li.on").attr("data-value")
				},
				beforeSend: function() {
					$boardLoader.show();
				}
			}).always(function() {
				$boardLoader.fadeOut(200);
			}).fail(function(xhr, error, code) {
				alert(error + " : " + code);
				console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
			}).done(function(data) {
				// 최대 페이지 넘을시 처리
				var max = commentPaginate.getMaxPage();
				if (max > 0 && pageNo > max) {
					getCommentList(max);
					return;
				}

				var code = boardTmpFunc({
					list: data.boardList
				});

				$(".box.board .box_item").html(code);
				$(".box.board .paginate").html(data.paginateHtml);
				gtBoard.board.resizeTitle();
			});
		}

		// 게시글 관리: 선택 항목 삭제
		$(".board_frame .box_select .form_delete").submit(function(e) {
			var $form = $(this);
			gtBoard.board.deleteAll(e, $form, function() {
				$.ajax($form.attr("action"), {
					type: "POST",
					dataType: "json",
					data: $form.serialize(),
					beforeSend: function() {
						$boardLoader.show();
					},
				}).always(function() {
					$boardLoader.fadeOut(200);
				}).fail(function(xhr, error, code) {
					alert(error + " : " + code);
					console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
				}).done(function(result) {
					if (result) {
						getBoardList();
						alert("선택하신 게시글 삭제에 성공 하였습니다.");
					}
				});
			});
			return false;
		});

		// 게시글 관리: 옵션 변경 및 검색
		$(".board_frame .form_search").submit(function(e) {
			e.preventDefault();

			gtBoard.board.updateOption($(this));
			getBoardList();
		});
	</script>

	<!-- 댓글 관리 -->
	<script>
		var $commentLoader = $(".box.comment .loading");
		var $commentCheckBox = $(".box.comment #checkAllComment");
		var commentTmpFunc = _.template($("#commentTmp").html());

		// 페이지네이트 설정
		var commentPaginate = new Paginate(".comment_frame .paginate", {
			preventDefault: true,
			onPageClick: function() {
				getCommentList();
				$("html,body").animate({
					scrollTop: $(".comment_frame").offset().top - 50
				}, 200);
			}
		});

		// 댓글 관리: 댓글 목록 취득
		function getCommentList(pageNo) {
			if (typeof pageNo === "undefined") {
				pageNo = commentPaginate.getCurrentPage();
				if (pageNo == 0) {
					pageNo = 1;
				}
			}
			$commentCheckBox.prop("checked", false);

			$.ajax("/user/${loginUser.no}/comment/list", {
				type: "GET",
				dataType: "json",
				data: {
					pageNo: pageNo,
					numPage: $(".box.comment .box_option .view_count select").val()
				},
				beforeSend: function() {
					$commentLoader.show();
				},
			}).always(function() {
				$commentLoader.fadeOut(200);
			}).fail(function(xhr, error, code) {
				alert(error + " : " + code);
				console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
			}).done(function(data) {
				// 최대 페이지 넘을시 처리
				var max = commentPaginate.getMaxPage();
				if (max > 0 && pageNo > max) {
					getCommentList(max);
					return;
				}

				var code = commentTmpFunc({
					list: data.list
				});

				$(".box.comment .box_item").html(code);
				$(".box.comment .paginate").html(data.paginateHtml);
			});
		}

		// 댓글 관리: 선택 항목 삭제
		$(".comment_frame .box_select .form_delete").submit(function(e) {
			var $form = $(this);
			gtBoard.comment.deleteAll(e, $form, function() {
				$.ajax($form.attr("action"), {
					type: "POST",
					dataType: "json",
					data: $form.serialize(),
					beforeSend: function() {
						$commentLoader.show();
					},
				}).always(function() {
					$commentLoader.fadeOut(200);
				}).fail(function(xhr, error, code) {
					alert(error + " : " + code);
					console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
				}).done(function(result) {
					if (result) {
						getCommentList();
						alert("선택하신 댓글 삭제에 성공 하였습니다.");
					}
				});
			});
			return false;
		});
	</script>
</body>

</html>