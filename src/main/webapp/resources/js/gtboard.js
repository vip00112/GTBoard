(function() {
	// board 모듈
	var board = {
		timeout: null, // setTimeout 저장
		resizeTitle: function() { // 게시글 a 태그 넓이 조정
			var boards = $(".board_frame .box_item .line.item .title");
			$.each(boards, function() {
				var frame = $(this).parents(".board_frame");
				var $a = $(this).find("a");

				var isAd = $a.hasClass("a");
				var isNew = $a.hasClass("n");
				var isPopular = $a.hasClass("h");
				var isSecret = $a.hasClass("s");
				var hasImage = $a.hasClass("i");
				var hasVideo = $a.hasClass("v");
				var hasFile = $a.hasClass("f");
				var hasComment = $a.hasClass("c");
				var maxWidth = $(this).width();

				if (isAd) {
					maxWidth -= $(this).find(".ad").width() + 2;
				} else if (isNew) {
					maxWidth -= $(this).find(".new").width() + 2;
				} else if (isPopular) {
					maxWidth -= $(this).find(".hot").width() + 2;
				}
				if (isSecret) {
					maxWidth -= $(this).find(".secret").width() + 2;
				}

				// 앨범형 보기는 이미지 표기 아이콘 숨김
				if (!frame.hasClass("album")) {
					if (hasImage) {
						maxWidth -= $(this).find(".image").width() + 2;
					}
				}
				if (hasVideo) {
					maxWidth -= $(this).find(".video").width() + 2;
				}
				if (hasFile) {
					maxWidth -= $(this).find(".file").width() + 2;
				}
				if (hasComment) {
					maxWidth -= $(this).find(".count_comment").width() + 2;
				}

				$a.css("max-width", maxWidth + "px"); // 제목 width 조정
				$a.text($a.text().trim()); // 제목 문자열 앞뒤 공백 제거
			});
		},
		resizeTitleDelay: function(delay) { // delay 밀리초 후 게시글 a 태그 넓이 조정
			if (this.timeout !== null) {
				clearTimeout(this.timeout);
			}
			this.timeout = setTimeout(this.resizeTitle, delay);
		},
		toggleDesc: function($btn) { // 게시판 상세 옵션 펼침/닫힘
			var $box = $btn.parents(".box_desc");
			$box.toggleClass("on");
			$btn.toggleClass("on");

			var icon = $btn.find("i.fa");
			if ($btn.hasClass("on")) {
				icon.removeClass("fa-caret-down");
				icon.addClass("fa-caret-up");
			} else {
				icon.removeClass("fa-caret-up");
				icon.addClass("fa-caret-down");
			}
		},
		changeViewType: function($btn) { // 옵션 변경(보기 형식) 후 resizeTitleDelay 호출
			var $frame = $btn.parents(".board_frame");
			$frame.find(".box_option .view_type li.on").removeClass("on");
			$btn.addClass("on");

			if ($btn.hasClass("album")) {
				$frame.addClass("album");
			} else {
				$frame.removeClass("album");
			}
			this.resizeTitleDelay(100);
		},
		changeViewCount: function($btn) { // 옵션 변경(갯수) 후 검색form submit
			var $option = $btn.parents(".option");
			$option.find("li.on").removeClass("on");
			$btn.addClass("on");
			this.search($btn);
		},
		changeViewOrder: function($btn) { // 옵션 변경(정렬) 후 검색form submit
			var $option = $btn.parents(".option");
			$option.find("li.on").removeClass("on");
			$btn.addClass("on");
			this.search($btn);
		},
		updateOption: function($child) { // 현재 옵션을 검색form의 parameter전달을 위한 업데이트
			var $frame = $child.parents(".board_frame");
			var $form = $frame.find(".form_search");
			var pageNo = 1;
			var numPage = $frame.find(".box_option .view_count li.on").attr("data-value");
			var order = $frame.find(".box_option .view_order li.on").attr("data-value");

			$form.find("input[name='pageNo']").val(pageNo);
			$form.find("input[name='numPage']").val(numPage);
			$form.find("input[name='order']").val(order);
		},
		search: function($child) { // 검색form submit (ajax 처리시는 해당 페이지에서 개별 처리)
			var $frame = $child.parents(".board_frame");
			var $form = $frame.find(".form_search");
			this.updateOption($form);
			$form.submit();
		},
		toggleCheckAll: function($input) { // 전체 선택/해제
			var $frame = $input.parents(".board_frame");

			var checked = $input.prop("checked");
			$frame.find(".line.item .check input").prop("checked", checked);
		},
		uncheckAll: function($input) { // 전체 선택 버튼 체크 해제
			if (!$input.prop("checked")) {
				var $frame = $input.parents(".board_frame");
				$frame.find(".box_select #checkAllBoard").prop("checked", false);
			}
		},
		deleteAll: function(event, $form, callBack) { // 선택된 게시글 전체 삭제
			if (!confirm("선택하신 게시글을 정말 삭제 하시겠습니까?\n(삭제된 게시글은 복구할 수 없습니다.)")) {
				event.preventDefault ? event.preventDefault() : (event.returnValue = false);
				return;
			}

			var items = $form.parents(".board_frame").find(".line.item");
			var boardNos = [];
			items.each(function() {
				var $chk = $(this).find(".check input");
				if ($chk.prop("checked")) {
					var boardNo = $(this).find(".no").text().trim();
					boardNos.push(parseInt(boardNo));
				}
			});

			if (boardNos.length < 1) {
				alert("선택된 게시글이 없습니다.");
				return false;
			}

			$form.find("input[name=boardNo]").val(boardNos);
			if (typeof callBack === 'function') {
				callBack();
			}
		},
		deleteOne: function(event, callBack) { // 해당 게시글 삭제
			if (!confirm("해당 게시글을 정말 삭제 하시겠습니까?\n(삭제된 게시글은 복구할 수 없습니다.)")) {
				event.preventDefault ? event.preventDefault() : (event.returnValue = false);
				return;
			}

			// ajax 처리가 필요할시 callBack인자로 함수 전달
			if (typeof callBack === 'function') {
				callBack();
			}
		},
		moveAll: function(event, $form, callBack) { // 선택된 게시글 전체 이동
			if (!confirm("선택하신 게시글을 정말 이동 하시겠습니까?")) {
				event.preventDefault ? event.preventDefault() : (event.returnValue = false);
				return;
			}

			var items = $form.parents(".board_frame").find(".line.item");
			var boardNos = [];
			items.each(function() {
				var $chk = $(this).find(".check input");
				if ($chk.prop("checked")) {
					var boardNo = $(this).find(".no").text().trim();
					boardNos.push(parseInt(boardNo));
				}
			});

			if (boardNos.length < 1) {
				alert("선택된 게시글이 없습니다.");
				return false;
			}

			$form.find("input[name=boardNo]").val(boardNos);
			if (typeof callBack === 'function') {
				callBack();
			}
		},
		fullScreen: function($img) { // 게시글 상세에서 이미지 클릭시 전체 보기
			var fullScreen = $("<div class='screen'>").css({
				position: "fixed",
				top: "0px",
				left: "0px",
				width: "100%",
				height: "100%",
				background: "rgba(0, 0, 0, .2)",
				'z-index': 9999,
				display: "none",
				overflow: "scroll",
				title: "화면을 클릭시 사라집니다."
			});
			$(fullScreen).append("<img src='" + $img.attr("src") + "' alt='확대 이미지' class='viewer'>");

			$img.parents(".text").append(fullScreen);
			$(fullScreen).fadeIn(200);

			$(fullScreen).click(function() {
				$(this).fadeOut(200, function() {
					$(this).remove();
				});
			});
		},
	};

	// comment 모듈
	var comment = {
		toggleCheckAll: function($input) { // 전체 선택/해제
			var $frame = $input.parents(".comment_frame");

			var checked = $input.prop("checked");
			$frame.find(".comment.item .check input").prop("checked", checked);
		},
		uncheckAll: function($input) { // 전체 선택 버튼 체크 해제
			if (!$input.prop("checked")) {
				var $frame = $input.parents(".comment_frame");
				$frame.find(".box_select #checkAllComment").prop("checked", false);
			}
		},
		deleteAll: function(event, $form, callBack) { // 선택된 댓글 전체 삭제
			if (!confirm("선택하신 댓글을 정말 삭제 하시겠습니까?\n(삭제된 댓글은 복구할 수 없습니다.)")) {
				event.preventDefault ? event.preventDefault() : (event.returnValue = false);
				return;
			}

			var items = $form.parents(".comment_frame").find(".comment.item");
			var commentNos = [];
			items.each(function() {
				var $chk = $(this).find(".check input");
				if ($chk.prop("checked")) {
					var commentNo = $(this).find(".no").text().trim();
					commentNos.push(parseInt(commentNo));
				}
			});

			if (commentNos.length < 1) {
				alert("선택된 댓글이 없습니다.");
				return false;
			}

			$form.find("input[name=commentNo]").val(commentNos);
			if (typeof callBack === 'function') {
				callBack();
			}
		},
		deleteOne: function(event, callBack) { // 해당 댓글 삭제
			if (!confirm("해당 댓글을 정말 삭제 하시겠습니까?\n(삭제된 댓글은 복구할 수 없습니다.)")) {
				event.preventDefault ? event.preventDefault() : (event.returnValue = false);
				return;
			}

			// ajax 처리가 필요할시 callBack인자로 함수 전달
			if (typeof callBack === 'function') {
				callBack();
			}
		}
	};

	// gtBoard 모듈 추가
	window.gtBoard = {
		board: board,
		comment: comment
	};
})();