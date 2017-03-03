/**
 * @license Copyright (c) 2003-2017, CKSource - Frederico Knabben. All rights reserved. For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function(config) {
	// prism : upgrade codesnippet
	// image,file : upload
	config.extraPlugins = 'prism,image,file';

	// extraPlugins
	config.imageBrowserUrl = "/editor/browser/img";
	config.fileBrowserUrl = "/editor/browser/file";

	// 코드 스니펫 플러그인 설정
	// config.codeSnippet_theme = 'monokai_sublime';

	config.language = "ko"; // 언어
	config.skin = "moono-lisa"; // 스킨
	config.uiColor = "#EEEEEE"; // UI 색상
	config.height = 400; // 기본 높이
	config.toolbar = [ { // 툴바
		name: "document",
		items: [ "Source", "Preview" ]
	}, {
		name: "clipboard",
		items: [ "Undo", "Redo" ]
	}, {
		name: "styles",
		items: [ "Font", "FontSize" ]
	}, {
		name: "colors",
		items: [ "TextColor", "BGColor" ]
	}, {
		name: "basicstyles",
		items: [ "Bold", "Italic", "Underline", "Strike" ]
	}, {
		name: "paragraph",
		items: [ "JustifyBlock", "JustifyCenter", "JustifyLeft", "JustifyRight", "-", "NumberedList", "BulletedList" ]
	}, {
		name: "links",
		items: [ "Link", "Unlink" ]
	}, "/", {
		name: "insert",
		items: [ "Image", "File", "Embed", "CodeSnippet", "-", "Table", "HorizontalRule" ]
	} ];

	config.enterMode = "1"; // Enter 1:<p>, 2:<br>, 3:<div>
	config.shiftEnterMode = "2"; // Shift+Enter 1:<p>, 2:<br>, 3:<div>
	config.font_names = "굴림/Gulim;돋움/Dotum;맑은고딕/'Malgun Gothic';Verdana/Verdana;Arial/Arial;SANS-SERIF/sans-serif";

	// Tab 제거
	var removeTab = "";
	removeTab += "table:advanced;"; // 표
	removeTab += "link:advanced;"; // 링크
	config.removeDialogTabs = removeTab;
};

// 에디터 설정
CKEDITOR.on('instanceReady', function(ev) {
	// 요소간 개행 삭제
	var tags = [ "p", "br", "ul", "ol", "li", "pre" ];
	var writer = ev.editor.dataProcessor.writer;
	tags.forEach(function(tag) {
		writer.setRules(tag, {
			indent: false,
			breakBeforeOpen: true,
			breakAfterOpen: false,
			breakBeforeClose: false,
			breakAfterClose: false
		});
	});
});

// dialog 개인 설정
CKEDITOR.on('dialogDefinition', function(ev) {
	var name = ev.data.name;
	var dialog = ev.data.definition.dialog;
	var definition = ev.data.definition;

	// 공통
	definition.resizable = CKEDITOR.DIALOG_RESIZE_NONE; // 리사이즈 불가
});