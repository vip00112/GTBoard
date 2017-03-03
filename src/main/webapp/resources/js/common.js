// 전역변수 선언
var ltIE9 = false; // IE 9 미만 버전: fix.js에서 설정

// gnav 열림/닫힘
$(".wrap.top .gnav").click(function() {
	if ($(this).hasClass("on")) { // 열림 -> 닫힘
		$(this).find(".fa").removeClass("fa-caret-up");
		$(this).find(".fa").addClass("fa-caret-down");
	} else { // 닫힘 -> 열림 : 스크롤 최상단 이동
		$(window).scrollTop(0);
		$(this).find(".fa").removeClass("fa-caret-down");
		$(this).find(".fa").addClass("fa-caret-up");
	}
	
	$(this).toggleClass("on");
	$(".wrap.header .gnav>.menu").toggleClass("on");
});

// 정규식 확인
function regexCheck(regex, text) {
	return regex.test(text);
}

// 빈 문자열 체크
function isEmpty(text) {
	text = text.replace(/\r/gi, "").replace(/\n/gi, "");
	text = text.replace(/\<p\>/gi, "").replace(/\<\/p\>/gi, "");
	text = text.replace(/\<br\>/gi, "").replace(/\<br \/\>/gi, "").replace(/\<br\/\>/gi, "");
	text = text.replace(/\&nbsp;/gi, "").replace(/ /gi, "").replace(/　/gi, "");
	return text == "";
}

// 엔티티 문자 치환
function changeEntities(text) {
	text = text.replace(/&/gi, "&amp;").replace(/</gi, "&lt;").replace(/>/gi, "&gt;");
	text = text.replace(/"/gi, "&quot;").replace(/'/gi, "&#x27;").replace(/`/gi, "&#x60;");
	return text;
}

// 쿠키 생성
function setCookie(name, value, expiredays) {
	var cookie = name + "=" + escape(value) + "; path=/;"
	if (typeof expiredays != 'undefined') {
		var todayDate = new Date();
		todayDate.setDate(todayDate.getDate() + expiredays);
		cookie += "expires=" + todayDate.toGMTString() + ";"
	}
	document.cookie = cookie;
}

// 쿠키 획득
function getCookie(name) {
	name += "=";
	var cookie = document.cookie;
	var startIdx = cookie.indexOf(name);
	if (startIdx != -1) {
		startIdx += name.length;
		var endIdx = cookie.indexOf(";", startIdx);
		if (endIdx == -1) {
			endIdx = cookie.length;
			return unescape(cookie.substring(startIdx, endIdx));
		}
	}
	return null;
}

// 쿠키 삭제
function deleteCookie(name) {
	setCookie(name, "", -1);
}

// 작성일자 표기 변환 : 오늘일자(시:분:초)와 이전(년-월-일) 구분
function getViewDate(unixTime) {
	var now = moment().format("YYYY-MM-DD");
	var regdate = moment.unix(unixTime / 1000).format("YYYY-MM-DD");

	if (now == regdate) { // 당일 글: 시간,분,초 표기
		return moment.unix(unixTime / 1000).format("HH:mm:ss");
	} else { // 그 외: 년,월,일 표기
		return regdate;
	}
}

// 작성일자 표기 변환 : 년-월-일 시:분:초
function getViewDate_Full(unixTime) {
	return moment.unix(unixTime / 1000).format("YYYY-MM-DD HH:mm:ss");
}
