<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<h2>기본 정보 설정</h2>

<form action="/admin/setting/base" method="post" class="form_update">
	<fieldset>
		<legend class="screen_out">기본 정보 설정</legend>
		<input type="hidden" name="_method" value="PUT" />
		<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

		<div class="box">
			<h3>기본 설정</h3>

			<div class="box_wrap">
				<label>Title</label>
				<input required type="text" name="title" value="">
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
				<input required type="text" id="author" name="author" value="">
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
				<input required type="text" name="keyword" value="">
				<span class="desc">검색 엔진에 노출될 해당 페이지 키워드</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>Description</label>
				<input required type="text" name="description" value="">
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
				<input required type="text" name="startYear" value="" data-regex="[0-9]+">
				<span class="desc">footer의 coptright에 표기될 설립년도</span>
			</div>
			<!-- // .box_wrap -->
		</div>
		<!-- // .box -->

		<div class="box">
			<h3>시작 페이지 게시글 갯수 설정</h3>

			<div class="box_wrap">
				<label>게시판 별 갯수</label>
				<input type="text" name="indexViewCount" value="" data-regex="[0-9]+">
				<span class="desc">index 페이지에 보여질 게시판 별 게시글 갯수</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>전체 게시판 갯수</label>
				<input type="text" name="indexViewCountTotal" value="" data-regex="[0-9]+">
				<span class="desc">index 페이지에 보여질 전체 게시판 게시글 갯수</span>
			</div>
			<!-- // .box_wrap -->
		</div>
		<!-- // .box -->

		<button>저장</button>
	</fieldset>
</form>

<!-- 기본 정보 설정 -->
<script>
	// 기본 정보 취득
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
			setValue($(".content .box.base .form_update"), info);
		});
	}
</script>