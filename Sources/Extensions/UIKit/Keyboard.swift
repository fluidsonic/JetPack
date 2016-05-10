import UIKit


public final class Keyboard {

	public private(set) static var animation = Animation(duration: 0.25, timing: .Curve(UIViewAnimationCurve(rawValue: 7)!))
	public private(set) static var frame = CGRect()
	public private(set) static var isVisible = false

	public static var eventBus = EventBus()


	private init() {
		// static only
	}


	private static func didChangeFrameWithNotification(notification: NSNotification) {
		updateFromNotification(notification)

		eventBus.publish(Event.DidChangeFrame())
	}


	private static func didHideWithNotification(notification: NSNotification) {
		updateFromNotification(notification)

		eventBus.publish(Event.DidHide())
	}


	private static func didShowWithNotification(notification: NSNotification) {
		updateFromNotification(notification)

		eventBus.publish(Event.DidShow())
	}


	@warn_unused_result
	public static func frameInView(view: UIView) -> CGRect {
		guard let window = view.window ?? view as? UIWindow else {
			return .null
		}

		let windowSize = window.bounds.size
		var frameInWindow = window.convertRect(frame, fromWindow: nil)
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

		let frameInView = view.convertRect(frameInWindow, fromView: window)
		return frameInView
	}


	internal static func setUp() {
		subscribeToNotifications()
	}


	private static func subscribeToNotifications() {
		let queue = NSOperationQueue.mainQueue()
		let notificationCenter = NSNotificationCenter.defaultCenter()
		notificationCenter.addObserverForName(UIKeyboardDidChangeFrameNotification,  object: nil, queue: queue, usingBlock: didChangeFrameWithNotification)
		notificationCenter.addObserverForName(UIKeyboardDidHideNotification,         object: nil, queue: queue, usingBlock: didHideWithNotification)
		notificationCenter.addObserverForName(UIKeyboardDidShowNotification,         object: nil, queue: queue, usingBlock: didShowWithNotification)
		notificationCenter.addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: queue, usingBlock: willChangeFrameWithNotification)
		notificationCenter.addObserverForName(UIKeyboardWillHideNotification,        object: nil, queue: queue, usingBlock: willHideWithNotification)
		notificationCenter.addObserverForName(UIKeyboardWillShowNotification,        object: nil, queue: queue, usingBlock: willShowWithNotification)
	}


	private static func updateFromNotification(notification: NSNotification) {
		guard let userInfo = notification.userInfo else {
			return
		}

		if let
			rawAnimationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int, animationCurve = UIViewAnimationCurve(rawValue: rawAnimationCurve),
			animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval
		{
			self.animation = Animation(duration: animationDuration, timing: .Curve(animationCurve))
		}

		if let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
			frame = frameValue.CGRectValue()
			isVisible = UIScreen.mainScreen().bounds.intersects(frame)
		}
	}


	private static func willChangeFrameWithNotification(notification: NSNotification) {
		updateFromNotification(notification)

		eventBus.publish(Event.WillChangeFrame())
	}


	private static func willHideWithNotification(notification: NSNotification) { // called after willChangeFrame
		updateFromNotification(notification)

		eventBus.publish(Event.WillHide())
	}


	private static func willShowWithNotification(notification: NSNotification) { // called after willChangeFrame
		updateFromNotification(notification)

		eventBus.publish(Event.WillShow())
	}



	public struct Event {

		public struct DidChangeFrame  { private init() {} }
		public struct DidHide         { private init() {} }
		public struct DidShow         { private init() {} }
		public struct WillChangeFrame { private init() {} }
		public struct WillHide        { private init() {} }
		public struct WillShow        { private init() {} }


		private init() {}
	}
}
