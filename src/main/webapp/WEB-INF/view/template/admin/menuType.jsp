<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<h2>메뉴 설정</h2>

<form action="" method="post" class="form_delete">
	<fieldset>
		<legend class="screen_out">메뉴 삭제</legend>
		<input type="hidden" name="_method" value="DELETE">
		<input type="hidden" name="CSRFToken" value="${CSRFToken}" />
	</fieldset>
</form>

<form action="" method="post" class="form_update">
	<fieldset>
		<legend class="screen_out">메뉴 설정</legend>
		<input type="hidden" name="_method" value="PUT" />
		<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

		<div class="box">
			<select name="no">
				<c:forEach items="${menuSetting.menuTypeList}" var="menuType">
					<option value="${menuType.no}">${menuType.name}</option>
				</c:forEach>
				<option value="0">신규 메뉴 추가</option>
			</select>

			<button type="button" class="delete main">
				<i class="fa fa-trash"></i>
				메뉴 삭제
			</button>
		</div>
		<!-- // .box -->

		<div class="box">
			<h3>메뉴 설정</h3>

			<div class="box_wrap">
				<label>순서</label>
				<input required type="text" name="order" value="">
				<span class="desc">메뉴에 표기될 순서</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>이름</label>
				<input required type="text" name="name" value="">
				<span class="desc">화면에 보여질 이름</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>URL</label>
				<input required type="text" name="url" value="">
				<span class="desc">클릭시 이동될 URL</span>
			</div>
			<!-- // .box_wrap -->
		</div>
		<!-- // .box -->

		<div class="box">
			<h3>서브 메뉴 설정</h3>

			<span class="add">
				<i class="fa fa-plus-circle fa-lg"></i>
				추가
			</span>

			<div class="items">
				<%-- subMenuTmp --%>
			</div>
		</div>
		<!-- // .box -->

		<button>저장</button>
	</fieldset>
</form>