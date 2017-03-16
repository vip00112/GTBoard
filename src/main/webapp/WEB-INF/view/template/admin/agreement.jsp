<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<h2>운영방침 설정</h2>

<form action="" method="post" class="form_update">
	<fieldset>
		<legend class="screen_out">운영방침 설정</legend>
		<input type="hidden" name="_method" value="PUT" />
		<input type="hidden" name="CSRFToken" value="${CSRFToken}" />

		<div class="box">
			<div class="box_wrap">
				<label>구분</label>
				<select name="type">
					<option value="terms">이용약관</option>
					<option value="privacy">개인정보 취급 방침</option>
					<option value="youth">청소년 보호 정책</option>
					<option value="email">이메일 무단 수집 거부</option>
				</select>
				<span class="desc">운영방침 구분</span>
			</div>
			<!-- // .box_wrap -->

			<div class="box_wrap">
				<label>등록일자</label>
				<select name="viewRegdate"></select>
				<span class="desc">해당 방침이 등록된 일자</span>
			</div>
			<!-- // .box_wrap -->
		</div>
		<!-- // .box -->

		<div class="box">
			<label>등록일자 수정</label>
			<input type="text" name="regdate" readonly required>
		</div>
		<!-- // .box -->

		<div class="box">
			<textarea name="content" id="editor" required></textarea>
		</div>
		<!-- // .box -->

		<button>저장</button>
	</fieldset>
</form>

<%-- CKEditor 설정 --%>
<script src="/ckeditor/ckeditor.js" charset="utf-8"></script>
<script src="/resources/js/ckeditor.js"></script>
<script>
	$(window).load(function() {
		createCKEditor("Link,Unlink,Image,File,Embed,CodeSnippet");
	});
</script>

<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
<script src="/resources/js/jquery-ui-timepicker.min.js"></script>

<script>
	var agreementInfos = [];

	// 항목 변경
	$(".content .box.agreement select[name='type']").change(function() {
		getAgreementInfo();
	});

	// 일자 변경
	$(".content .box.agreement select[name='viewRegdate']").change(function() {
		getAgreementDetail($(this).val());
	});

	// 작성일자 datepicker 설정
	$(".content .box.agreement input[name='regdate']").datetimepicker({
		dateFormat: 'yy-mm-dd',
		monthNamesShort: [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
		dayNamesMin: [ '일', '월', '화', '수', '목', '금', '토' ],
		changeMonth: true,
		changeYear: true,
		showMonthAfterYear: true,
		maxDate: 0,

		// timepicker 설정
		timeFormat: 'HH:mm:ss',
		controlType: 'select',
		oneLine: true,
		maxTime: 0
	});

	// form_update 전송
	$(".content .box.agreement .form_update").submit(function() {
		var no = $(this).find("select[name='viewRegdate']").val();
		var method = (no == 0) ? "POST" : "PUT";

		// url, mehotd 지정
		$(this).attr("action", "/admin/agreement/" + no);
		$(this).find("input[name='_method']").val(method);
	});

	// 항목별 내역 취득
	function getAgreementInfo() {
		var type = $(".content .box.agreement select[name='type']").val();
		$.ajax("/admin/agreement/" + type, {
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
			var $select = $(".content .box.agreement select[name='viewRegdate']");
			$select.html("");

			if (info != null) {
				agreementInfos = [];
				$(info).each(function() {
					agreementInfos.push({
						"no": this.no,
						"viewRegdate": this.viewRegdate,
						"content": this.content
					});
					$select.append("<option value='" + this.no + "'>" + this.viewRegdate + "</option>");
				});
				$select.append("<option value='0'>추가</option>");

				var no = $select.val();
				getAgreementDetail(no);
			}
		});
	}

	// 상세 내역 취득
	function getAgreementDetail(no) {
		// 신규 내용 추가
		if (no == 0) {
			$(".content .box.agreement input[name='regdate']").val("1990-01-01 00:00:00");
			$(".content .box.agreement input[name='regdate']").hide();
			CKEDITOR.instances.editor.setData("");
			return;
		}
		
		if (agreementInfos && agreementInfos.length > 0) {
			for (var i = 0, length = agreementInfos.length; i < length; i++) {
				var info = agreementInfos[i];
				if (info.no == no) {
					$(".content .box.agreement input[name='regdate']").val(info.viewRegdate);
					$(".content .box.agreement input[name='regdate']").show();
					CKEDITOR.instances.editor.setData(info.content);
					return;
				}
			}
		}
	}
</script>