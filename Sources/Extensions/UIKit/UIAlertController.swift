import UIKit


public extension UIAlertController {

	@nonobjc
	convenience init(actionSheetWithMessage message: String) {
		self.init(title: nil, message: message.nonEmpty, preferredStyle: .actionSheet)
	}


	@nonobjc
	convenience init(actionSheetWithTitle title: String) {
		self.init(title: title.nonEmpty, message: nil, preferredStyle: .actionSheet)
	}


	@nonobjc
	convenience init(actionSheetWithTitle title: String, message: String) {
		self.init(title: title.nonEmpty, message: message.nonEmpty, preferredStyle: .actionSheet)
	}


	@nonobjc
	convenience init(alertWithMessage message: String) {
		self.init(title: nil, message: message.nonEmpty, preferredStyle: .alert)
	}


	@nonobjc
	convenience init(alertWithTitle title: String, message: String) {
		self.init(title: title.nonEmpty, message: message.nonEmpty, preferredStyle: .alert)
	}


	@discardableResult
	@nonobjc
	func addActionWithTitle(_ title: String, handler: Closure? = nil) -> UIAlertAction {
		let action = UIAlertAction(title: title, style: .default) { _ in handler?() }
		addAction(action)
		return action
	}


	@discardableResult
	@nonobjc
	func addCancelAction(_ handler: Closure? = nil) -> UIAlertAction {
		return addCancelActionWithTitle(Bundle(for: UIAlertController.self).localizedString(forKey: "Cancel", value: "Cancel", table: nil), handler: handler)
	}


	@discardableResult
	@nonobjc
	func addCancelActionWithTitle(_ title: String, handler: Closure? = nil) -> UIAlertAction {
		let action = UIAlertAction(title: title, style: .cancel) { _ in handler?() }
		addAction(action)
		return action
	}


	@discardableResult
	@nonobjc
	func addDestructiveActionWithTitle(_ title: String, handler: Closure? = nil) -> UIAlertAction {
		let action = UIAlertAction(title: title, style: .destructive) { _ in handler?() }
		addAction(action)
		return action
	}


	@discardableResult
	@nonobjc
	func addOkayAction(_ handler: Closure? = nil) -> UIAlertAction {
		let action = addActionWithTitle(Bundle(for: UIAlertController.self).localizedString(forKey: "OK", value: "OK", table: nil), handler: handler)

		if preferredAction == nil {
			preferredAction = action
		}

		return action
	}


	@discardableResult
	@nonobjc
	func addPreferredActionWithTitle(_ title: String, handler: Closure? = nil) -> UIAlertAction {
		let action = UIAlertAction(title: title, style: .default) { _ in handler?() }
		addAction(action)

		preferredAction = action

		return action
	}
}
