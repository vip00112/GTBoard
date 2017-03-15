$(window).load(function() {
	// common.js의 변수를 통한 IE 9 미만 버전 확인
	if (ltIE9) {
		// IE 9 미만 호환성을 위한 script로드로 인해 발생한 딜레이 차이
		gtBoard.board.resizeTitleDelay(500);
	} else {
		gtBoard.board.resizeTitle();
	}

	// 브라우저 크기 조절
	$(window).resize(function() {
		gtBoard.board.resizeTitleDelay(100);
	});

	// 게시판 상세 옵션 펼침/닫힘
	$(".board_frame .box_desc>span").click(function() {
		gtBoard.board.toggleDesc($(this));
	});

	// 옵션 변경: 보기 형식
	$(".board_frame .box_option .view_type li").click(function() {
		gtBoard.board.changeViewType($(this));
	});

	// 옵션 변경: 갯수
	$(".board_frame .box_option .view_count li").click(function() {
		gtBoard.board.changeViewCount($(this));
	});

	// 옵션 변경: 정렬
	$(".board_frame .box_option .view_order li").click(function() {
		gtBoard.board.changeViewOrder($(this));
	});

	// 검색
	$(".board_frame .form_search").submit(function() {
		gtBoard.board.updateOption($(this));
	});

	// 게시글 전체 선택/해제
	$(".board_frame .box_select #checkAllBoard").click(function() {
		gtBoard.board.toggleCheckAll($(this));
	});

	// 체크된 것 해제시 전체선택 해제
	$(".board_frame .box_item").on("change", ".line.item .check input", function() {
		gtBoard.board.uncheckAll($(this));
	});

	// 이미지 확대 보기
	$(".text img").click(function() {
		gtBoard.board.fullScreen($(this));
	});
});