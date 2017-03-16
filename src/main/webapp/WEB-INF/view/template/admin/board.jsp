<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<h2>기본 정보 설정</h2>

<select name="no">
	<option value="all">전체 게시판</option>
	<c:forEach items="${boardSetting.boardTypeList}" var="boardType">
		<option value="${boardType.url}">${boardType.name}</option>
	</c:forEach>
</select>

<div class="board_frame all">
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
		<input type="checkbox" id="checkAllBoard">
		<label for="checkAllBoard">전체선택</label>

		<form action="/admin/board/delete" method="post" class="form_delete">
			<fieldset>
				<legend class="screen_out">선택 삭제 폼</legend>
				<input type="hidden" name="CSRFToken" value="${CSRFToken}" />
				<input type="hidden" name="_method" value="DELETE">
				<input type="hidden" name="boardNo">
				<button class="btn delete" title="선택 항목 삭제">
					<i class="fa fa-trash"></i>
				</button>
			</fieldset>
		</form>

		<form action="/admin/board/move" method="post" class="form_move">
			<fieldset>
				<legend class="screen_out">선택 이동 폼</legend>
				<input type="hidden" name="CSRFToken" value="${CSRFToken}" />
				<input type="hidden" name="_method" value="PUT">
				<input type="hidden" name="boardNo">
				<label>
					<select name="typeNo">
						<c:forEach items="${boardSetting.boardTypeList}" var="boardType">
							<option value="${boardType.no}">${boardType.name}</option>
						</c:forEach>
					</select>
					으로
				</label>
				<button class="btn move" title="선택 항목 이동">
					<i class="fa fa-refresh"></i>
					이동
				</button>
			</fieldset>
		</form>
	</div>
	<!-- // .box_select -->

	<ul class="line top">
		<li class="type">구분</li>
		<li class="no">번호</li>
		<li class="title">제목</li>
		<li class="nickname">글쓴이</li>
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

	<form action="" class="form_search" method="post">
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

<!-- boardTmp -->
<script type="text/template" id="boardTmp">
	<@ _.each(list, function(board) { @>
		<ul class="line item">
			<li class="check">
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
				<@ if (board.recent) { @>
					<span class="new" title="신규 글"></span>
				<@ } else if (board.popular) { @>
					<span class="hot" title="인기 글"></span>
				<@ } @>
				<@ if (board.boardType.secret) { @>
					<span class="secret" title="비밀 글"></span>
				<@ } @>
				<a href="/board/<@=board.no@>" class="<@=board.titleClass@>">
					<@=changeEntities(board.title)@>
				</a>
				<@ if (board.boardType.useAttachFile && board.includeAttachFile) { @>
					<span class="file" title="첨부파일 포함"></span>
				<@ } @>
				<@ if (board.includeImg) { @>
					<span class="image" title="이미지 포함"></span>
				<@ } @>
				<@ if (board.includeVideo) { @>
					<span class="video" title="동영상 포함"></span>
				<@ } @>
				<@ if (board.boardType.useComment && board.commentCount > 0) { @>
					<span class="count_comment" title="댓글 수"><@=board.commentCount@></span>
				<@ } @>
			</li>
			<li class="nickname"><@=board.nickname@></li>
			<li class="date" title="<@=board.viewRegdateFull@>"><@=board.viewRegdate@></li>
			<li class="hit"><@=board.hit@></li>
			<li class="thumb"><@=board.thumb@></li>
		</ul>
	<@ }) @>
</script>

<script>
	var $boardLoader = $(".board_frame .loading");
	var $boardCheckBox = $(".board_frame #checkAllBoard");
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

	// 게시판 선택
	$(".content .box.board select[name='no']").change(function() {
		getBoardList();
	});

	// 선택 항목 삭제
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

	// 선택 항목 이동
	$(".board_frame .box_select .form_move").submit(function(e) {
		var $form = $(this);
		gtBoard.board.moveAll(e, $form, function() {
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
					alert("선택하신 게시글 이동에 성공 하였습니다.");
				}
			});
		});
		return false;
	});

	// 옵션 변경 및 검색
	$(".board_frame .form_search").submit(function(e) {
		e.preventDefault();

		gtBoard.board.updateOption($(this));
		getBoardList();
	});

	// 기본 정보 취득
	function getBoardList(pageNo) {
		if (typeof pageNo === "undefined") {
			pageNo = boardPaginate.getCurrentPage();
			if (pageNo == 0) {
				pageNo = 1;
			}
		}
		$boardCheckBox.prop("checked", false);

		var url = $(".content .box.board select[name='no']").val();
		$.ajax("/admin/board/" + url, {
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
				$loader.show();
			}
		}).always(function() {
			$loader.fadeOut(200);
		}).fail(function(xhr, error, code) {
			alert(error + " : " + code);
			console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
		}).done(function(data) {
			if (data == null) {
				return;
			}

			// 최대 페이지 넘을시 처리
			var max = boardPaginate.getMaxPage();
			if (max > 0 && pageNo > max) {
				getBoardList(max);
				return;
			}

			var code = boardTmpFunc({
				list: data.boardList
			});

			$(".board_frame .box_item").html(code);
			$(".board_frame .paginate").html(data.paginateHtml);
			gtBoard.board.resizeTitle();
		});
	}
</script>