$(window).load(function() {
	// 댓글 전체 선택/해제
	$(".comment_frame .box_select #checkAllComment").click(function() {
		gtBoard.comment.toggleCheckAll($(this));
	});

	// 체크된 것 해제시 전체선택 해제
	$(".comment_frame .box_item").on("change", ".comment.item .delete input", function() {
		gtBoard.comment.uncheckAll($(this));
	});
});