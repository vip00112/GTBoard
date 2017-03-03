// Iframe z-index fix
$(function() {
	$('iframe').each(function() {
		var url = $(this).attr("src");
		url = url + (url.indexOf("?") > 0 ? "&" : "?") + "wmode=transparent";
		$(this).attr({
			"src": url,
			"wmode": "Opaque"
		});
	});
});

// IE 9 미만 버전을 위한 Plyfill
(function() {
	// preventDefault
	if (!Event.prototype.preventDefault) {
		Event.prototype.preventDefault = function() {
			this.returnValue = false;
		};
	}

	// stopPropagation
	if (!Event.prototype.stopPropagation) {
		Event.prototype.stopPropagation = function() {
			this.cancelBubble = true;
		};
	}

	// addEventListener/removeEventListener
	if (Element.prototype && !Element.prototype.addEventListener) {
		
		// common.js의 전역변수 대입
		ltIE9 = true;
		
		var eventListeners = [];
		var addEventListener = function(type, listener) {
			var self = this;
			var wrapper = function(e) {
				e.target = e.srcElement;
				e.currentTarget = self;
				if (typeof listener.handleEvent != 'undefined') {
					listener.handleEvent(e);
				} else {
					listener.call(self, e);
				}
			};
			if (type == "DOMContentLoaded") {
				var wrapper2 = function(e) {
					if (document.readyState == "complete") {
						wrapper(e);
					}
				};
				document.attachEvent("onreadystatechange", wrapper2);
				eventListeners.push({
					object: this,
					type: type,
					listener: listener,
					wrapper: wrapper2
				});

				if (document.readyState == "complete") {
					var e = new Event();
					e.srcElement = window;
					wrapper2(e);
				}
			} else {
				this.attachEvent("on" + type, wrapper);
				eventListeners.push({
					object: this,
					type: type,
					listener: listener,
					wrapper: wrapper
				});
			}
		};

		var removeEventListener = function(type, listener) {
			var counter = 0;
			while (counter < eventListeners.length) {
				var eventListener = eventListeners[counter];
				if (eventListener.object == this && eventListener.type == type && eventListener.listener == listener) {
					if (type == "DOMContentLoaded") {
						this.detachEvent("onreadystatechange", eventListener.wrapper);
					} else {
						this.detachEvent("on" + type, eventListener.wrapper);
					}
					eventListeners.splice(counter, 1);
					break;
				}
				++counter;
			}
		};

		Element.prototype.addEventListener = addEventListener;
		Element.prototype.removeEventListener = removeEventListener;
		if (HTMLDocument) {
			HTMLDocument.prototype.addEventListener = addEventListener;
			HTMLDocument.prototype.removeEventListener = removeEventListener;
		}
		if (Window) {
			Window.prototype.addEventListener = addEventListener;
			Window.prototype.removeEventListener = removeEventListener;
		}
	}
	;
})();