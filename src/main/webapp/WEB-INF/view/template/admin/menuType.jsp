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
					<option value="${menuType.no}">No ${menuType.no} : ${menuType.name}</option>
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
				<input required type="text" name="order" value="" data-regex="[0-9]+">
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
				<input required type="text" name="url" value="" data-regex="[0-9a-z-\/#]+">
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

<script type="text/template" id="subMenuTmp">
	<@ _.each(list, function(subMenu) { @>
		<div class="box_wrap">
			<span class="delete sub">
				<i class="fa fa-trash"></i> 삭제
			</span>
			<label>순서</label>
			<input required type="text" name="order" value="<@=subMenu.order@>" data-regex="[0-9]+">
			<label>이름</label>
			<input required type="text" name="name" value="<@=subMenu.name@>">
			<label>URL</label>
			<input required type="text" name="url" value="<@=subMenu.url@>" data-regex="[0-9a-z-\/#]+">
		</div>
	<@ }) @>
	</script>

<script>
	var $items = $(".content .box.menuType .items");
	var subMenuTmpFunc = _.template($("#subMenuTmp").html());

	// 신규 메뉴 추가
	$(".content .box.menuType select[name='no']").change(function() {
		if ($(this).val() == 0) {
			$items.html("");
			$(".content .box.menuType input[name!='CSRFToken']").val("");
			$(".content .box.menuType select").val("true");
			$(this).val(0);
			$(".content .box.menuType .delete.main").hide();
		} else {
			getMenuTypeInfo();
			$(".content .box.menuType .delete.main").show();
		}
	});

	// 삭제
	$(".content .box.menuType .delete.main").click(function() {
		if (!confirm("해당 메뉴를 정말 삭제 하시겠습니까?")) {
			return false;
		}

		var no = $(this).parents(".form_update").find("select[name='no']").val();
		if (no == 0) {
			return false;
		}
		var $deleteForm = $(this).parents(".box").find(".form_delete");
		$deleteForm.attr("action", "/admin/setting/menuType/" + no);
		$deleteForm.submit();
	});

	// 신규 서브 메뉴 추가
	$(".content .box.menuType .add").click(function() {
		if (!confirm("신규 서브 메뉴를 추가 하시겠습니까?")) {
			return false;
		}
		var item = {
			order: "",
			name: "",
			url: ""
		}
		var code = subMenuTmpFunc({
			list: [ item ]
		});
		$items.append(code);
	});

	// 서브 메뉴 삭제
	$(".content .box.menuType .items").on("click", ".delete.sub", function() {
		if (!confirm("해당 서브 메뉴를 삭제 하시겠습니까?")) {
			return false;
		}

		$(this).parents(".box_wrap").remove();
	});

	// form_update 전송
	$(".content .box.menuType .form_update").submit(function() {
		var no = $(this).find("select[name='no']").val();
		var method = (no == 0) ? "POST" : "PUT";

		// url, mehotd 지정
		$(this).attr("action", "/admin/setting/menuType/" + no);
		$(this).find("input[name='_method']").val(method);

		// subMenuList 구성
		var items = $(this).find(".items .box_wrap");
		items.each(function(idx) {
			var inputs = $(this).find("input");
			inputs.each(function() {
				var attr = $(this).attr("name");
				$(this).attr("name", "subMenuList[" + idx + "]." + attr);
			});
		});
	});

	// 메뉴 정보 취득
	function getMenuTypeInfo() {
		var no = $(".content .box.menuType select[name='no']").val();
		if (no == 0) {
			return;
		}
		$.ajax("/admin/setting/menuType/" + no, {
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
			setValue($(".content .box.menuType .form_update"), info);
			var code = subMenuTmpFunc({
				list: info.subMenuList
			});
			$items.html(code);
		});
	}
</script>