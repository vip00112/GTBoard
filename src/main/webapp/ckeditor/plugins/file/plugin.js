'use strict';

(function() {
	var key = -1;
	var gEditor;

	CKEDITOR.plugins.add("file", {
		viewIcon: '<i class="fa fa-arrow-circle-down fa-lg" style="font-weight:bold;color:green;margin-right:5px;"></i>',
		protectedIcon: "<!--{cke_protected download icon}-->",
		
		init: function(editor) {
			gEditor = editor;
			
			// 버튼 설정
			editor.ui.addButton("File", {
				label: "첨부파일 삽입",
				command: "file",
				toolbar: "insert",
				icon: this.path + "icons/icon.png"
			});

			// 버튼 클릭시 커맨드
			editor.addCommand("file", {
                allowedContent: "a[data-name]{text-decoration};",
				exec: function() {
					key =  Math.floor((Math.random() * 100000) + 1);
					var url = editor.config.fileBrowserUrl + "?key=" + key;
					var name = "fileBrowser";
					var w = 400;
					var h = 600;
				    var left = (window.screen.width / 2) - ((w / 2));
				    var top = (window.screen.height / 2) - ((h / 2));
					window.open(url, name, "width=" + w + ",height=" + h + ",left=" + left + ",top=" + top + ",screenX=" + left + ",screenY=" + top);
				}
			});
		},
		
		// 팝업창에서 본문 삽입
		exec: function(paramKey, url, fileName, text) {
			if (key != paramKey) {
				return;
			}
			gEditor.insertHtml('<p><a data-name="' + fileName + '" href="' + url + '" target="_blank" style="text-decoration:none;">' + this.protectedIcon + text + '</a></p>');
		},
		
		// 팝업창에서 첨부된 파일 삭제시 본문 내용 변경
		replaceContent: function(url) {
			var content = gEditor.getData(); // 기존 내용
			var tags = content.match(/<a[^>]*>.*?<\/a>/gi); // a 태그 추출
			if (tags != null && tags.length > 0) {
				for (var i = 0, length = tags.length; i < length; i++) {
					var tag = tags[i];

					// 삭제한 파일의 url을 가지는 a 태그를 본문에서 삭제
					if (tag.indexOf(url) != -1) {
						tag = tag.replace(/\(/gi, "\\(");
						tag = tag.replace(/\)/gi, "\\)");
						var reg = new RegExp(tag, "gi");
						content = content.replace(reg, "");
					}
				}

				// a태그가 삭제되어 빈 p태그 삭제
				content = content.replace(/\<p\>\<\/p\>/gi, "");

				// 변경된 내용으로 본문 수정
				gEditor.setData(content);
			}
		},
		
		// viewIcon <-> protectedIcon 변환
		toggleIcon: function(text, isView) {
			if (typeof isView === 'undefined') {
				return text;
			}
			
			var regText = isView ? this.protectedIcon : this.viewIcon;
			var viewText = isView ? this.viewIcon : this.protectedIcon;
			var reg = new RegExp(regText, "gi");
			return text.replace(reg, viewText);
		}

	});

})();