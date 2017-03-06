<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8" />

<%-- meta Template --%>
<c:import url="template/meta.jsp">
	<c:param name="author">${board.nickname}</c:param>
	<c:param name="reply">-</c:param>
	<c:param name="keyword"></c:param>
	<c:param name="description">
		<c:out value="${board.text}" />
	</c:param>
	<c:param name="robots"></c:param>
	<c:param name="ogType">article</c:param>
	<c:param name="title">${baseSetting.title} | <c:out value="${board.title}" />
	</c:param>
	<c:param name="thumbnail">${board.thumbnail}</c:param>
</c:import>

<title>${baseSetting.title}-<c:out value="${board.title}" /></title>

<%-- link Template --%>
<c:import url="template/link.jsp"></c:import>

<%-- 개별 css --%>
<link rel="stylesheet" href="/resources/css/skin/boardDetail.css">
<link rel="stylesheet" href="/ckeditor/plugins/prism/lib/prism/prism_patched.min.css">

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
		<c:param name="pageTitle">${boardType.name}</c:param>
		<c:param name="pageDesc">${boardType.description}</c:param>
	</c:import>

	<%-- main article --%>
	<section>
		<article>
			<h1 class="title" title="<c:out value="${board.title}"/>">
				<c:out value="${board.title}" />
			</h1>

			<div class="box title">
				<ul>
					<li class="nickname">${board.nickname}</li>
					<li class="date">${board.viewRegdateFull}</li>
					<li class="hit">${board.hit}</li>
					<li class="comment">${board.commentCount}</li>
					<c:if test="${board.lastUpdate != null}">
						<li class="update">${board.viewLastUpdate}</li>
					</c:if>
				</ul>
			</div>
			<!-- // .box.title -->

			<div class="box content">
				<article class="text">${board.content}</article>
				<!-- // .text -->
			</div>
			<!-- // .box.content -->
		</article>

		<div class="box thumb">
			<div class="loading"></div>
			<!-- // .loading -->

			<c:choose>
				<%-- 이미 추천한 경우 --%>
				<c:when test="${isAddedThumb}">
					<button class="btn thumb added">
						<i class="fa fa-thumbs-up"></i>
						추천
						<em>${board.thumb}</em>
					</button>
				</c:when>

				<%-- 추천 가능 상태 --%>
				<c:otherwise>
					<button class="btn thumb">
						<i class="fa fa-thumbs-o-up"></i>
						추천
						<em>${board.thumb}</em>
					</button>
				</c:otherwise>
			</c:choose>
		</div>
		<!-- // .box.thumb -->

		<c:if test="${fn:length(board.downloadFiles) > 0}">
			<div class="box attach">
				<span>
					첨부 파일
					<strong>${fn:length(board.downloadFiles)}</strong>
				</span>
				<ul>
					<c:forEach items="${board.downloadFiles}" var="file">
						<li>
							<a href="${file.url}" target="_blank">
								<span class="ext">${file.extension}</span>
								<span class="name">${file.name}</span>
								<span class="size">${file.viewSize}</span>
							</a>
						</li>
					</c:forEach>
				</ul>
			</div>
			<!-- // .box.attach-->
		</c:if>

		<div class="box button">
			<c:if test="${loginUser != null && (loginUser.admin || loginUser.grade == board.boardType.adminGrade || loginUser.no == board.userNo)}">
				<a href="/board/${board.no}/update" class="btn update">
					<i class="fa fa-pencil"></i>
					수정
				</a>
				<form action="/board/${board.no}/delete" method="post" class="form_delete">
					<fieldset>
						<legend class="screen_out">게시글 삭제 폼</legend>
						<input type="hidden" name="_method" value="DELETE" />
						<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

						<button class="btn delete">
							<i class="fa fa-trash"></i>
							삭제
						</button>
					</fieldset>
				</form>
			</c:if>
			<a href="/board/${boardType.url}?searchType=${searchType}&search=${search}&numPage=${numPage}&pageNo=${pageNo}&order=${order}" class="btn list">
				<i class="fa fa-bars"></i>
				목록
			</a>
		</div>
		<!-- // .box.button -->
	</section>

	<c:if test="${board.boardType.useComment}">
		<section>
			<div class="comment_frame">
				<div class="loading comment"></div>
				<!-- // .loading -->

				<div class="box_top">
					<span>
						<i class="fa fa-comments" aria-hidden="true"></i>
						전체 댓글
						<strong>${board.commentCount}</strong>
					</span>
				</div>
				<!-- // .box_top -->

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

			<c:choose>
				<%-- 비로그인 댓글 작성 불가 --%>
				<c:when test="${loginUser == null}">
					<div class="box msg">
						<a href="/login" class="msg">로그인 후 댓글 작성이 가능 합니다.</a>
					</div>
				</c:when>

				<%-- 댓글 작성 등급 확인 --%>
				<c:when test="${loginUser.grade < board.boardType.commentGrade}">
					<div class="box msg">
						<span class="msg">댓글을 작성할 수 있는 등급이 아닙니다.</span>
					</div>
				</c:when>

				<%-- 댓글 작성 가능한 상태 --%>
				<c:otherwise>
					<form action="/board/${board.no}/comment/write" method="post" class="comment form_write">
						<fieldset>
							<legend class="screen_out">댓글 작성 폼</legend>
							<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

							<textarea name="content" wrap="hard" required></textarea>

							<div class="box bottom">
								<c:if test="${board.boardType.useCommentCode}">
									<div class="box captcha">
										<div class="loading"></div>
										<!-- // .loading -->

										<input type="text" name="captcha" autocomplete="off" required placeholder="자동 방지 코드" />
										<img src="/captcha" alt="캡차 이미지" title="클릭시 새로고침" />
									</div>
									<!-- // .box.captcha -->
								</c:if>

								<button type="submit">댓글 등록</button>
							</div>
							<!-- // .box.bottom -->
						</fieldset>
					</form>
				</c:otherwise>
			</c:choose>
		</section>
	</c:if>
	<hr />

	<section>
		<%-- 전체 보기 --%>
		<c:if test="${boardType.no == 0}">
			<c:set var="all" value="all" />
		</c:if>

		<%-- 앨범 보기 --%>
		<c:if test="${boardType.album}">
			<c:set var="album" value="album" />
		</c:if>

		<div class="board_frame ${all} ${album}">
			<div class="loading board"></div>
			<!-- // .loading -->

			<div class="box_option">
				<div class="view_type option">
					<ul title="게시글 형식">
						<li class="list <c:if test="${!boardType.album}">on</c:if>">
							<i class="fa fa-bars"></i>
							리스트
						</li>
						<li class="album <c:if test="${boardType.album}">on</c:if>">
							<i class="fa fa-th"></i>
							앨범
						</li>
					</ul>
				</div>
				<!-- // .view_type -->

				<div class="view_count option">
					<ul title="게시글 갯수">
						<li data-value="10" <c:if test="${numPage == 10}">class="on"</c:if>>10개</li>
						<li data-value="30" <c:if test="${numPage == 30}">class="on"</c:if>>30개</li>
						<li data-value="50" <c:if test="${numPage == 50}">class="on"</c:if>>50개</li>
					</ul>
				</div>
				<!-- // .view_count -->

				<div class="view_order option">
					<ul title="게시글 정렬">
						<li data-value="regdate_DESC" <c:if test="${order eq 'regdate_DESC'}">class="on"</c:if>>최신순</li>
						<li data-value="hit_DESC" <c:if test="${order eq 'hit_DESC'}">class="on"</c:if>>조회순</li>
						<li data-value="thumb_DESC" <c:if test="${order eq 'thumb_DESC'}">class="on"</c:if>>추천순</li>
						<li data-value="commentCount_DESC" <c:if test="${order eq 'commentCount_DESC'}">class="on"</c:if>>댓글순</li>
					</ul>
				</div>
				<!-- // .view_order-->
			</div>
			<!-- // .box_option -->

			<ul class="line top">
				<li class="type">구분</li>
				<li class="no">번호</li>
				<li class="title">제목</li>
				<li class="nickname">글쓴이</li>
				<li class="date">작성일</li>
				<li class="hit">조회</li>
				<li class="thumb">추천</li>
			</ul>

			<div class="box_item notice">
				<c:set var="boardNo">${board.no}</c:set>
				<c:forEach items="${noticeList}" var="board">
					<ul class="line item <c:if test="${board.no == boardNo}">now</c:if>">
						<li class="type">
							<a href="/board/${board.boardType.url}">${board.boardType.name}</a>
						</li>
						<li class="no notice">
							<c:choose>
								<c:when test="${board.no == boardNo}">
									<i class="fa fa-caret-right"></i>
								</c:when>
								<c:otherwise>공지</c:otherwise>
							</c:choose>
						</li>
						<%-- <li class="thumbnail"> <a> <img/> </a> </li>
						게시판 별 공지 게시글은 썸네일 이미지 보여주지 않는다. --%>
						<li class="title notice" title="<c:out value="${board.title}"/>">
							<c:if test="${board.recent}">
								<span class="new" title="신규 글"></span>
							</c:if>
							<a href="/board/${board.no}?url=${boardType.url}&searchType=${searchType}&search=${search}&numPage=${numPage}&pageNo=${pageNo}&order=${order}" class="${board.titleClass}">
								<c:out value="${board.title}" />
							</a>
							<c:if test="${board.boardType.useComment && board.commentCount > 0}">
								<span class="count_comment" title="댓글 수">${board.commentCount}</span>
							</c:if>
							<c:if test="${board.includeAttachFile}">
								<span class="file" title="첨부파일 포함"></span>
							</c:if>
							<c:if test="${board.includeImg}">
								<span class="image" title="이미지 포함"></span>
							</c:if>
						</li>
						<li class="nickname">${board.nickname}</li>
						<li class="date" title="${board.viewRegdateFull}">${board.viewRegdate}</li>
						<li class="hit">${board.hit}</li>
						<li class="thumb">${board.thumb}</li>
					</ul>
				</c:forEach>
			</div>
			<!-- // .box_item.notice -->

			<div class="box_item normal">
				<c:choose>
					<c:when test="${fn:length(boardList) > 0}">
						<c:set var="boardNo">${board.no}</c:set>
						<c:forEach items="${boardList}" var="board">
							<ul class="line item <c:if test="${board.no == boardNo}">now</c:if>">
								<li class="type">
									<a href="/board/${board.boardType.url}">${board.boardType.name}</a>
								</li>
								<li class="no">
									<c:choose>
										<c:when test="${board.no == boardNo}">
											<i class="fa fa-caret-right"></i>
										</c:when>
										<c:otherwise>${board.no}</c:otherwise>
									</c:choose>
								</li>
								<li class="thumbnail">
									<a href="/board/${board.no}?url=${boardType.url}&searchType=${searchType}&search=${search}&numPage=${numPage}&pageNo=${pageNo}&order=${order}">
										<c:set var="thumbnail" value="${board.defaultThumbnail}" />
										<c:if test="${board.thumbnail != null}">
											<c:set var="thumbnail" value="${board.thumbnail}" />
										</c:if>
										<img alt="썸네일 이미지" src="${thumbnail}">
									</a>
								</li>
								<li class="title <c:if test="${board.popular}">popular</c:if>" title="<c:out value="${board.title}"/>">
									<c:choose>
										<c:when test="${board.recent}">
											<span class="new" title="신규 글"></span>
										</c:when>
										<c:when test="${board.popular}">
											<span class="hot" title="인기 글"></span>
										</c:when>
									</c:choose>
									<a href="/board/${board.no}?url=${boardType.url}&searchType=${searchType}&search=${search}&numPage=${numPage}&pageNo=${pageNo}&order=${order}" class="${board.titleClass}">
										<c:out value="${board.title}" />
									</a>
									<c:if test="${board.boardType.useComment && board.commentCount > 0}">
										<span class="count_comment" title="댓글 수">${board.commentCount}</span>
									</c:if>
									<c:if test="${board.includeAttachFile}">
										<span class="file" title="첨부파일 포함"></span>
									</c:if>
									<c:if test="${board.includeImg}">
										<span class="image" title="이미지 포함"></span>
									</c:if>
								</li>
								<li class="nickname">${board.nickname}</li>
								<li class="date" title="${board.viewRegdateFull}">${board.viewRegdate}</li>
								<li class="hit">${board.hit}</li>
								<li class="thumb">${board.thumb}</li>
							</ul>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<ul class="line item">
							<li class="w100per">등록된 글이 없습니다.</li>
						</ul>
					</c:otherwise>
				</c:choose>
			</div>
			<!-- // .box_item.normal -->

			<div class="box_link">
				<a href="/board/${boardType.url}" class="all">
					<i class="fa fa-bars"></i>
					목록
				</a>
				<c:if test="${boardType.no != 0}">
					<a href="/board/${boardType.url}?popularThumb=${boardType.popularThumb}" class="popular">
						<i class="fa fa-thumbs-up"></i>
						인기글
					</a>
				</c:if>
				<c:if test="${boardType.no != 0 && loginUser != null && (loginUser.admin || loginUser.grade == board.boardType.adminGrade || loginUser.grade >= board.boardType.writeGrade)}">
					<a href="/board/${board.boardType.url}/write" class="write">
						<i class="fa fa-pencil"></i>
						글 작성
					</a>
				</c:if>
			</div>
			<!-- // .box_bottom -->

			<div class="paginate">${paginateHtml}</div>
			<!-- // .paginate -->

			<form action="/board/${boardType.url}" class="form_search" method="get">
				<fieldset>
					<legend class="screen_out">검색 폼</legend>

					<input type="hidden" name="pageNo" />
					<input type="hidden" name="numPage" />
					<input type="hidden" name="order" />

					<select name="searchType">
						<option value="title" <c:if test="${searchType eq 'title'}">selected</c:if>>글 제목</option>
						<option value="content" <c:if test="${searchType eq 'content'}">selected</c:if>>글 내용</option>
						<option value="title_content" <c:if test="${searchType eq 'title_content'}">selected</c:if>>글 제목 + 글 내용</option>
						<option value="nickname" <c:if test="${searchType eq 'nickname'}">selected</c:if>>글쓴이 닉네임</option>
						<option value="comment" <c:if test="${searchType eq 'comment'}">selected</c:if>>댓글 내용</option>
						<option value="comment_nickname" <c:if test="${searchType eq 'comment_nickname'}">selected</c:if>>댓글 작성자 닉네임</option>
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
	</section>
	<%-- // main article --%>

	<%-- footer Template --%>
	<c:import url="template/footer.jsp"></c:import>

	<!-- CKEditor CodeSnippet Plugin -->
	<script src="/ckeditor/plugins/prism/lib/prism/prism_patched.min.js"></script>

	<!-- commentTmp -->
	<script type="text/template" id="commentTmp">
	<@ _.each(list, function(comment) { @>
		<ul class="comment item">
			<li class="delete">
				<@ if (admin == "true" || comment.userNo == userNo) { @>
					<form action="/board/<@=boardNo@>/comment/<@=comment.no@>/delete" method="post" class="form_delete">
						<fieldset>
							<legend class="screen_out">댓글 삭제 폼</legend>
							<input type="hidden" name="_method" value="DELETE" />
							<input type="hidden" name="CSRFToken" value="<@=CSRFToken@>" />
							<button>
								<i class="fa fa-close"></i> 삭제
							</button>
						</fieldset>
					</form>
				<@ } @>
			</li>
			<li class="no"><@=comment.no@></li>
			<li class="nickname"><@=comment.nickname@></li>
			<li class="date"><@=comment.viewRegdateFull@></li>
			<li class="text" title="<@=changeEntities(comment.content)@>"><@=changeEntities(comment.content)@></li>
		</ul>
	<@ }) @>
	</script>

	<%-- 로그인 변수 선언 --%>
	<c:if test="${loginUser != null}">
		<script>
			var logined = true;
		</script>
	</c:if>

	<script>
		var $thumbLoader = $(".box.thumb .loading");
		var $commentLoader = $(".loading.comment");
		var $captchaLoader = $(".box.captcha .loading");
		var $captchaImg = $(".box.captcha img");
		var $commentCount = $(".box.title .comment");
		var $commentCountInFrame = $(".comment_frame .box_top strong");

		var commentTmpFunc = _.template($("#commentTmp").html());

		// 페이지네이트 설정
		var boardPaginate = new Paginate(".board_frame .paginate");
		var commentPaginate = new Paginate(".comment_frame .paginate", {
			preventDefault: true,
			onPageClick: function() {
				getCommentList();
				$("html,body").animate({
					scrollTop: $(".comment_frame").offset().top - 50
				}, 200);
			}
		});

		getCommentList(); // 댓글 목록 취득 ajax

		// 게시글 삭제
		$(".box.button .form_delete").submit(function(e) {
			gtBoard.board.deleteOne(e);
		});

		// 게시글 추천
		$(".box.thumb .btn.thumb").click(function() {
			var $btn = $(this);
			if ($btn.hasClass("added")) {
				alert("이미 추천 했습니다.");
				return;
			} else if (typeof logined == "undefined" || !logined) {
				alert("로그인 후 이용할 수 있습니다.");
				return;
			}

			$.ajax("/board/${board.no}/thumb", {
				type: "POST",
				dataType: "json",
				data: {
					CSRFToken: "${CSRFToken}"
				},
				beforeSend: function() {
					$thumbLoader.show();
				},
			}).always(function() {
				$thumbLoader.fadeOut(200);
			}).fail(function(xhr, error, code) {
				alert(error + " : " + code);
				console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
			}).done(function(result) {
				if (result) {
					var count = parseInt($btn.find("em").text()) + 1;
					$btn.addClass("added");
					$btn.find(".fa").removeClass("fa-thumbs-o-up").addClass("fa-thumbs-up");
					$btn.find("em").text(count);
					alert("게시글을 추천 하였습니다.");
				} else {
					alert("게시글을 추천할 수 없습니다.");
				}
			});
		});

		// 해당 글의 댓글 목록 ajax
		function getCommentList(pageNo) {
			if (typeof pageNo === "undefined") {
				pageNo = commentPaginate.getCurrentPage();
				if (pageNo == 0) {
					pageNo = 1;
				}
			}

			$.ajax("/board/${board.no}/comment", {
				type: "GET",
				dataType: "json",
				data: {
					pageNo: pageNo
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
					list: data.list,
					boardNo: "${board.no}",
					admin: "${loginUser.admin || loginUser.grade == board.boardType.adminGrade}",
					userNo: "${loginUser.no}",
					CSRFToken: "${CSRFToken}"
				});
				$(".comment_frame .box_item").html(code);
				$(".comment_frame .paginate").html(data.paginateHtml);
			});
		}

		// 댓글 등록
		$(".comment.form_write").submit(function(e) {
			e.preventDefault();

			if (isEmpty($(".comment.form_write textarea").val())) {
				alert("내용을 입력 해주세요.");
				return false;
			}

			$.ajax($(this).attr("action"), {
				type: "POST",
				dataType: "json",
				data: $(this).serialize(),
				beforeSend: function() {
					$commentLoader.show();
				}
			}).always(function() {
				$commentLoader.fadeOut(200);
			}).fail(function(xhr, error, code) {
				alert(error + " : " + code);
				console.log(xhr.status + " : " + code + "\n" + xhr.responseText);
			}).done(function(result) {
				if (result) {
					var count = parseInt($commentCount.text()) + 1;
					$commentCount.text(count);
					$commentCountInFrame.text(count);

					// 입력 값 초기화
					$(".comment.form_write textarea").val("");
					$(".comment.form_write .box.captcha input").val("");

					// captcha 이미지 새로고침
					$captchaLoader.show();
					$captchaImg.attr("src", "/captcha?ran=" + Math.random());
					$captchaLoader.fadeOut(500);

					getCommentList();
					alert("댓글을 등록 하였습니다.");
				} else {
					alert("댓글 등록에 실패 하였습니다.");
				}
			});
		});

		// 댓글 삭제
		$(".comment_frame .box_item").on("submit", ".form_delete", function(e) {
			var $form = $(this);
			var $comment = $(this).parents("li");
			gtBoard.comment.deleteOne(e, function() {
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
						var count = parseInt($commentCount.text()) - 1;
						if (count < 0) {
							count = 0;
						}
						$commentCount.text(count);
						$commentCountInFrame.text(count);
						$comment.remove();

						getCommentList();
						alert("댓글을 삭제 하였습니다.");
					}
				});
			});
			return false;
		});

		// captcha 새로고침
		$captchaImg.click(function() {
			$captchaLoader.show();
			$(this).attr("src", "/captcha?ran=" + Math.random());
			$captchaLoader.fadeOut(500);
		});
	</script>
</body>

</html>