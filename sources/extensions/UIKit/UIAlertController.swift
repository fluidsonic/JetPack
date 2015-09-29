public extension UIAlertController {

	public convenience init(actionSheetWithMessage message: String) {
		self.init(title: nil, message: message.nonEmpty, preferredStyle: .ActionSheet)
	}


	public convenience init(actionSheetWithTitle title: String) {
		self.init(title: title.nonEmpty, message: nil, preferredStyle: .ActionSheet)
	}


	public convenience init(alertWithMessage message: String) {
		self.init(title: nil, message: message.nonEmpty, preferredStyle: .Alert)
	}


	public convenience init(alertWithTitle title: String, message: String) {
		self.init(title: title.nonEmpty, message: message.nonEmpty, preferredStyle: .Alert)
	}


	public func addActionWithTitle(title: String, handler: Closure? = nil) {
		addAction(UIAlertAction(title: title, style: .Default) { _ in handler?() })
	}


	public func addCancelAction(handler: Closure? = nil) {
		addCancelActionWithTitle(NSBundle(forClass: UIAlertController.self).localizedStringForKey("Cancel", value: "Cancel", table: nil), handler: handler)
	}


	public func addCancelActionWithTitle(title: String, handler: Closure? = nil) {
		addAction(UIAlertAction(title: title, style: .Cancel) { _ in handler?() })
	}


	public func addDestructiveActionWithTitle(title: String, handler: Closure? = nil) {
		addAction(UIAlertAction(title: title, style: .Destructive) { _ in handler?() })
	}


	public func addOkayAction(handler: Closure? = nil) {
		addActionWithTitle(NSBundle(forClass: UIAlertController.self).localizedStringForKey("OK", value: "OK", table: nil), handler: handler)
	}
}
