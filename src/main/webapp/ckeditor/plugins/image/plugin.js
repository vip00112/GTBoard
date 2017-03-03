'use strict';

(function() {
	var key = -1;
	var gEditor;
	
	CKEDITOR.plugins.add("image", {
		init: function(editor) {
			gEditor = editor;
			
			// 버튼 설정
			editor.ui.addButton("Image", {
				label: "이미지 삽입",
				command: "image",
				toolbar: "insert",
				icon: this.path + "icons/icon.png"
			});

			// 버튼 클릭시 커맨드
			editor.addCommand("image", {
                allowedContent: "img[data-name,alt,!src]{float,border,margin};",
                requiredContent: "img[data-name,alt,src]",
				exec: function() {
					key =  Math.floor((Math.random() * 100000) + 1);
					var url = editor.config.imageBrowserUrl + "?key=" + key;
					var name = "imageBrowser";
					var w = 400;
					var h = 600;
				    var left = (window.screen.width / 2) - ((w / 2));
				    var top = (window.screen.height / 2) - ((h / 2));
					window.open(url, name, "width=" + w + ",height=" + h + ",left=" + left + ",top=" + top + ",screenX=" + left + ",screenY=" + top);
				}
			});
		},
		
		// 팝업창에서 본문 삽입
		exec: function(paramKey, src, alt, option) {
			if (key != paramKey) {
				return;
			}
			
			var style = '';
			if (option) {
				style += ' style="';
				style += 'border:' + option.border + 'px solid #424242;';
				style += 'margin:' + option["margin-top"] + 'px';
				style += ' ' + option["margin-right"] + 'px';
				style += ' ' + option["margin-bottom"] + 'px';
				style += ' ' + option["margin-left"] + 'px;';
				style += 'float:' + option.float + ';';
				style += '"';
			}
			gEditor.insertHtml('<img data-name="' + alt + '" alt="' + alt + '" src="' + src + '"' + style + '>');
		},
		
		// 팝업창에서 첨부된 이미지 삭제시 본문 내용 변경
		replaceContent: function(src) {
			var content = gEditor.getData(); // 기존 내용
			var tags = content.match(/<img[^>]*>/gi); // img 태그 추출
			if (tags != null && tags.length > 0) {
				for (var i = 0, length = tags.length; i < length; i++) {
					var tag = tags[i];

					// 삭제한 이미지의 src을 가지는 img 태그를 본문에서 삭제
					if (tag.indexOf(src) != -1) {
						var reg = new RegExp(tag, "gi");
						content = content.replace(reg, "");
					}
				}

				// img태그가 삭제되어 빈 p태그 삭제
				content = content.replace(/\<p\>\<\/p\>/gi, "");

				// 변경된 내용으로 본문 수정
				gEditor.setData(content);
			}
		}

	});

})();