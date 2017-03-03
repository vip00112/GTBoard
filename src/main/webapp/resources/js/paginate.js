/* paginate.js ver 2.0
 * Copyright 2016 by GT, MIT License
 */
function Paginate(selector, userOption) {
	if (typeof selector !== 'string') {
		throw "'selector' parameter type is must 'string'";
	}

	var nodes = document.querySelectorAll(selector);
	if (!nodes || nodes.length < 1) {
		throw "not found htmlDOM by'" + selector + "' selector";
	} else if (nodes.length > 1) {
		throw "'htmlDOM' need just one. you have to change your 'selector' parameter : your 'selector' parameter is '" + selector + "'";
	}

	var self = this;
	this.element = nodes[0]; // htmlDOM
	this.option = this.extend(this.defaultOption, userOption); // merge userOption to defaultOption

	// add changePage event
	this.addClickEvent(this.element, function(e) {
		// preventDefault by userOption
		if (self.option.preventDefault) {
			e.preventDefault ? e.preventDefault() : (e.returnValue = false);
		}

		var target = e.target || e.srcElement;
		if (target == self.element) {
			return;
		}
		if (target.tagName == "I") { // if target is 'FontAwesome' in 'A' tag
			target = target.parentElement;
		}

		if (target.tagName == "A") {
			var className = target.className;
			if (self.hasClass(target, "max") || self.hasClass(target, "now")) {
				e.preventDefault ? e.preventDefault() : (e.returnValue = false);
				return;
			}

			// remove class
			var nodes = self.element.querySelectorAll(".now");
			for (var i = 0, size = nodes.length; i < size; i++) {
				var el = nodes[i];
				self.removeClass(el, "now");
			}

			// add class
			self.addClass(target, "now");
		}

		// call onPageClick event by userOption
		if (typeof self.option.onPageClick === 'function') {
			self.option.onPageClick();
		}
	});
}

Paginate.prototype = {
	// defaultOption
	defaultOption: {
		preventDefault: false,
		onPageClick: null
	},

	// function
	extend: function(defaultOption, userOption) {
		if (typeof defaultOption !== 'object') {
			throw "'defaultOption' parameters type is must object";
		} else if (userOption && typeof userOption !== 'object') {
			throw "'userOption' parameters type is must object";
		}

		var result = {};
		for ( var attrname in defaultOption) {
			result[attrname] = defaultOption[attrname];
		}
		for ( var attrname in userOption) {
			result[attrname] = userOption[attrname];
		}
		return result;
	},
	addClickEvent: function(element, callBack) {
		if (element.addEventListener) {
			element.addEventListener("click", callBack, false);
		} else {
			element.attachEvent("onclick", callBack);
		}
	},
	hasClass: function(element, className) {
		return new RegExp('(^|\\s)' + className + '(\\s|$)').test(element.className);
	},
	addClass: function(element, className) {
		element.className += (element.className ? ' ' : '') + className;
	},
	removeClass: function(element, className) {
		element.className = element.className.replace(new RegExp('(^|\\s)*' + className + '(\\s|$)*', 'g'), '');
	},
	getCurrentPage: function() {
		if (!this.element) {
			throw "you must defined 'element' before call 'getCurrentPage' function";
		}
		var nodes = this.element.querySelectorAll("li a.now");
		if (nodes.length > 0) {
			var value = nodes[0].getAttribute("data-no");
			return parseInt(value);
		}
		return 0;
	},
	getMaxPage: function() {
		if (!this.element) {
			throw "you must defined 'element' before call 'getMaxPage' function";
		}
		var nodes = this.element.querySelectorAll("li a[data-no]");
		if (nodes.length > 0) {
			var value = nodes[nodes.length - 1].getAttribute("data-no");
			return parseInt(value);
		}
		return 0;
	}
};