<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<h2>게시판 설정</h2>

<form action="" method="post" class="form_delete">
	<fieldset>
		<legend class="screen_out">게시판 삭제</legend>
		<input type="hidden" name="_method" value="DELETE">
		<input type="hidden" name="CSRFToken" value="${CSRFToken}" />
	</fieldset>
</form>

<form action="" method="post" class="form_update">
	<fieldset>
		<legend class="screen_out">게시판 설정</legend>
		<input type="hidden" name="_method" value="PUT" />
		<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

		<div class="box">
			<select name="no">
				<c:forEach items="${boardSetting.boardTypeList}" var="boardType">
					<option value="${boardType.no}">No ${boardType.no} : ${boardType.name}</option>
				</c:forEach>
				<option value="0">신규 게시판 추가</option>
			</select>

			<button type="button" class="copy">
				<i class="fa fa-clone"></i>
				설정 복사
			</button>
			<button type="button" class="delete main">
				<i class="fa fa-trash"></i>
				게시판 삭제
			</button>
		</div>
		<!-- // .box -->

		<div class="box">
			<h3>필수 기본 설정</h3>

			<div class="box_wrap">
				<label>이름</label>
				<input required type="text" name="name" value="">
				<span class="desc">화면에 보여지는 이름</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>설명</label>
				<input required type="text" name="description" value="">
				<span class="desc">해당 게시판의 간략한 설명</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>URL</label>
				<input required type="text" name="url" value="" data-regex="[a-z-]+">
				<span class="desc">/board/{url} 형태로 사용될 게시판 주소</span>
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

			<div class="box_wrap" data-low="mainOrder" data-on="true">
				<label>메인 페이지 표기</label>
				<select name="viewMain">
					<option value="true">표기</option>
					<option value="false">미표기</option>
				</select>
				<span class="desc">메인 페이지(/index) 표기 여부</span>
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
				<label>메인 페이지 표기 순서</label>
				<input required type="text" name="mainOrder" value="" data-regex="[0-9]+">
				<span class="desc">메인 페이지(/index) 표기 순서</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>글 작성 포인트</label>
				<input type="text" name="writePoint" value="" data-regex="[0-9]+">
				<span class="desc">글 작성시 작성자에게 지급할 포인트</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>댓글 작성 포인트</label>
				<input type="text" name="commentPoint" value="" data-regex="[0-9]+">
				<span class="desc">댓글 작성시 작성자에게 지급할 포인트</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>추천 포인트</label>
				<input type="text" name="thumbPoint" value="" data-regex="[0-9]+">
				<span class="desc">게시글 추천시 작성자에게 지급할 포인트</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>다운로드 소모 포인트</label>
				<input type="text" name="downloadPoint" value="" data-regex="[0-9]+">
				<span class="desc">첨부파일 다운로드시 필요한 포인트</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>인기글 추천 갯수</label>
				<input type="text" name="popularThumb" value="" data-regex="[0-9]+">
				<span class="desc">인기글이 되기위한 최소 추천 갯수</span>
			</div>
			<!-- // .box_wrap -->
		</div>
		<!-- // .box -->

		<div class="box">
			<h3>등급 설정</h3>

			<div class="box_wrap">
				<label>글작성 등급</label>
				<input type="text" name="writeGrade" value="" data-regex="[0-9]+">
				<span class="desc">글 작성이 가능한 등급</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>글읽기 등급</label>
				<input type="text" name="readGrade" value="" data-regex="[0-9]+">
				<span class="desc">게시글 읽기가 가능한 등급</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>댓글작성 등급</label>
				<input type="text" name="commentGrade" value="" data-regex="[0-9]+">
				<span class="desc">댓글 작성이 가능한 등급</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>다운로드 등급</label>
				<input type="text" name="downloadGrade" value="" data-regex="[0-9]+">
				<span class="desc">첨부파일 다운로드가 가능한 등급</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>관리자 등급</label>
				<input type="text" name="adminGrade" value="" data-regex="[0-9]+">
				<span class="desc">게시판 관리자 등급(수정/삭제 가능)</span>
			</div>
			<!-- // .box_wrap -->
		</div>
		<!-- // .box -->

		<button type="submit">저장</button>
	</fieldset>
</form>

<script>
	// 신규 게시판 추가
	$(".content .box.boardType select[name='no']").change(function() {
		if ($(this).val() == 0) {
			$(".content .box.boardType input[name!='CSRFToken']").val("");
			$(".content .box.boardType select").val("true");
			$(this).val(0);

			$(".content .box.boardType [name='anonymous']").val("false");
			$(".content .box.boardType [name='secret']").val("false");
			$(".content .box.boardType [name='album']").val("false");
			$(".content .box.boardType [name='mainOrder']").val("9999");
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
			$(".content .box.boardType .copy").hide();
			$(".content .box.boardType .delete.main").hide();
		} else {
			getBoardTypeInfo();
			$(".content .box.boardType .copy").show();
			$(".content .box.boardType .delete.main").show();
		}
	});
	
	// 복사
	$(".content .box.boardType .copy").click(function() {
		if (!confirm("현재 게시판의 설정을 복사 하시겠습니까?")) {
			return false;
		}
		
		$(".content .box.boardType select[name='no']").val(0);
		$(".content .box.boardType [name='name']").val("");
		$(".content .box.boardType [name='description']").val("");
		$(".content .box.boardType [name='url']").val("");
		$(".content .box.boardType [name='name']").focus();
	});

	// 삭제
	$(".content .box.boardType .delete.main").click(function() {
		if (!confirm("해당 게시판을 정말 삭제 하시겠습니까?")) {
			return false;
		}
		if (!confirm("게시글/댓글/첨부파일등 게시판의 모든 하위 데이터가 삭제 됩니다.\r정말 삭제 하시겠습니까?")) {
			return false;
		}

		var no = $(this).parents(".form_update").find("select[name='no']").val();
		if (no == 0) {
			return false;
		}
		var $deleteForm = $(this).parents(".box").find(".form_delete");
		$deleteForm.attr("action", "/admin/setting/boardType/" + no);
		$deleteForm.submit();
	});

	// ON/OFF 설정
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

	// form_update 전송
	$(".content .box.boardType .form_update").submit(function() {
		var no = $(this).find("select[name='no']").val();
		var method = (no == 0) ? "POST" : "PUT";

		// url, mehotd 지정
		$(this).attr("action", "/admin/setting/boardType/" + no);
		$(this).find("input[name='_method']").val(method);
	});

	// 게시판 정보 취득
	function getBoardTypeInfo() {
		var no = $(".content .box.boardType select[name='no']").val();
		if (no == 0) {
			return;
		}
		$.ajax("/admin/setting/boardType/" + no, {
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
			setValue($(".content .box.boardType .form_update"), info);

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