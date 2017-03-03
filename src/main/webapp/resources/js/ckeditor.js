function createCKEditor() {
	// CKEditor 생성
	CKEDITOR.replace("editor", {
		on: {
			instanceReady: function(ev) {
				var text = $("#editor").val();
				
				// 다운로드 아이콘 표기(ckeditor/plugins/file/plugin.js)
				var plugin = CKEDITOR.plugins.get("file");
				if (plugin) {
					text = plugin.toggleIcon(text, false);
				}
				
				insertToEditor(text);
			}
		}
	});

	// 글 작성 폼 submit
	$("#writeForm").submit(function() {
		insertToTextarea();

		if (isEmpty($("#title").val())) {
			alert("제목을 입력 해주세요.");
			$("#title").focus();
			return false;
		} else if (isEmpty($("#editor").val())) {
			alert("내용을 입력 해주세요.");
			CKEDITOR.instances.editor.focus();
			return false;
		}
		insertToEditor($("#editor").val());
	});

	// 인자로 받은 text(html tag 가능)를 editor에 넣기
	function insertToEditor(text) {
		CKEDITOR.instances.editor.setData(text);
	}

	// editor의 내용을 textarea의 value로 넣기
	function insertToTextarea() {
		var text = CKEDITOR.instances.editor.getData();
		text = text.replace(/\\r\\n/gi, "").replace(/\\n/gi, "");
		text = text.replace(/\r\n/gi, "").replace(/\n/gi, "");

		var fragment = CKEDITOR.htmlParser.fragment.fromHtml(text);
		var writer = new CKEDITOR.htmlParser.basicWriter();

		CKEDITOR.instances.editor.filter.applyTo(fragment);
		fragment.writeHtml(writer);
		text = writer.getHtml();

		// 다운로드 아이콘 표기(ckeditor/plugins/file/plugin.js)
		var plugin = CKEDITOR.plugins.get("file");
		if (plugin) {
			text = plugin.toggleIcon(text, true);
		}

		$("#editor").val(text);
	}
}