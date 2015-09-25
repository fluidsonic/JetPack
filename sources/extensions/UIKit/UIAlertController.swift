public extension UIAlertController {

	public convenience init(actionSheetWithMessage message: String) {
		self.init(title: nil, message: message, preferredStyle: .ActionSheet)
	}


	public convenience init(actionSheetWithTitle title: String) {
		self.init(title: title, message: message, preferredStyle: .ActionSheet)
	}


	public convenience init(alertWithMessage message: String) {
		self.init(title: nil, message: message, preferredStyle: .Alert)
	}


	public convenience init(alertWithTitle title: String, message: String) {
		self.init(title: title, message: message, preferredStyle: .Alert)
	}


	public func addActionWithTitle(title: String, handler: Closure = {}) {
		addAction(UIAlertAction(title: title, style: .Default) { _ in handler() })
	}


	public func addCancelAction(handler: Closure = {}) {
		addCancelActionWithTitle(NSBundle(forClass: UIAlertController.self).localizedStringForKey("Cancel", value: "Cancel", table: nil), handler: handler)
	}


	public func addCancelActionWithTitle(title: String, handler: Closure = {}) {
		addAction(UIAlertAction(title: title, style: .Cancel) { _ in handler() })
	}


	public func addDestructiveActionWithTitle(title: String, handler: Closure = {}) {
		addAction(UIAlertAction(title: title, style: .Destructive) { _ in handler() })
	}


	public func addOkayAction(handler: Closure = {}) {
		addActionWithTitle(NSBundle(forClass: UIAlertController.self).localizedStringForKey("OK", value: "OK", table: nil), handler: handler)
	}
}
