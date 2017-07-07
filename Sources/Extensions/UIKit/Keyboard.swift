import UIKit


public final class Keyboard {

	fileprivate static var preloaded = false

	public fileprivate(set) static var animation = Animation(duration: 0.25, timing: .curve(UIViewAnimationCurve(rawValue: 7)!))
	public fileprivate(set) static var frame = CGRect()
	public fileprivate(set) static var isVisible = false

	public static var eventBus = EventBus()


	fileprivate init() {
		// static only
	}


	fileprivate static func didChangeFrameWithNotification(_ notification: Notification) {
		preloaded = true

		updateFromNotification(notification)

		eventBus.publish(Event.DidChangeFrame())
	}


	fileprivate static func didHideWithNotification(_ notification: Notification) {
		preloaded = true

		updateFromNotification(notification)

		eventBus.publish(Event.DidHide())
	}


	fileprivate static func didShowWithNotification(_ notification: Notification) {
		preloaded = true

		updateFromNotification(notification)

		eventBus.publish(Event.DidShow())
	}


	
	public static func frameInView(_ view: UIView) -> CGRect {
		guard let window = view.window ?? view as? UIWindow else {
			return .null
		}

		let windowSize = window.bounds.size
		var frameInWindow = window.convert(frame, from: nil)
		frameInWindow.left = 0

		if isVisible {
			// TODO
			// This is wrong when a hardware keyboard is connected while an input accessory view is still visible.
			// In that case the keyboard frame is only half-visible, so we cannot bottom-align the frame.

			frameInWindow.bottom = windowSize.height
		}
		else {
			frameInWindow.top = windowSize.height
		}

		let frameInView = view.convert(frameInWindow, from: window)
		return frameInView
	}


	public static func preload() {
		guard !preloaded, let _window = UIApplication.shared.delegate?.window, let window = _window, window.firstResponder == nil else { // why the double optional???
			return
		}

		preloaded = true

		let input = UITextField(frame: .zero)
		window.addSubview(input)

		input.becomeFirstResponder()
		input.resignFirstResponder()
		input.removeFromSuperview()
	}


	fileprivate static func subscribeToNotifications() {
		let queue = OperationQueue.main
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(forName: NSNotification.Name.UIKeyboardDidChangeFrame,  object: nil, queue: queue, using: didChangeFrameWithNotification)
		notificationCenter.addObserver(forName: NSNotification.Name.UIKeyboardDidHide,         object: nil, queue: queue, using: didHideWithNotification)
		notificationCenter.addObserver(forName: NSNotification.Name.UIKeyboardDidShow,         object: nil, queue: queue, using: didShowWithNotification)
		notificationCenter.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: queue, using: willChangeFrameWithNotification)
		notificationCenter.addObserver(forName: NSNotification.Name.UIKeyboardWillHide,        object: nil, queue: queue, using: willHideWithNotification)
		notificationCenter.addObserver(forName: NSNotification.Name.UIKeyboardWillShow,        object: nil, queue: queue, using: willShowWithNotification)
	}


	fileprivate static func updateFromNotification(_ notification: Notification) {
		guard let userInfo = notification.userInfo else {
			return
		}

		if let
			rawAnimationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int, let animationCurve = UIViewAnimationCurve(rawValue: rawAnimationCurve),
			let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
		{
			self.animation = Animation(duration: animationDuration, timing: .curve(animationCurve))
		}

		if let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
			frame = frameValue.cgRectValue
			isVisible = UIScreen.main.bounds.intersects(frame)
		}
	}


	fileprivate static func willChangeFrameWithNotification(_ notification: Notification) {
		preloaded = true

		updateFromNotification(notification)

		eventBus.publish(Event.WillChangeFrame())
	}


	fileprivate static func willHideWithNotification(_ notification: Notification) { // called after willChangeFrame
		preloaded = true

		updateFromNotification(notification)

		eventBus.publish(Event.WillHide())
	}


	fileprivate static func willShowWithNotification(_ notification: Notification) { // called after willChangeFrame
		preloaded = true

		updateFromNotification(notification)

		eventBus.publish(Event.WillShow())
	}



	public struct Event {

		public struct DidChangeFrame  { fileprivate init() {} }
		public struct DidHide         { fileprivate init() {} }
		public struct DidShow         { fileprivate init() {} }
		public struct WillChangeFrame { fileprivate init() {} }
		public struct WillHide        { fileprivate init() {} }
		public struct WillShow        { fileprivate init() {} }


		fileprivate init() {}
	}
}


@objc(_JetPack_Extensions_UIKit_Keyboard_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		Keyboard.subscribeToNotifications()
	}
}
