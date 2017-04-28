import UIKit


protocol GestureRecognizerDelegateProxy: UIGestureRecognizerDelegate {

	weak var nextDelegate: UIGestureRecognizerDelegate? { get }
}


extension GestureRecognizerDelegateProxy {

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
		return nextDelegate?.gestureRecognizer?(gestureRecognizer, shouldReceive: press) ?? true
	}


	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return nextDelegate?.gestureRecognizer?(gestureRecognizer, shouldReceive: touch) ?? true
	}


	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return nextDelegate?.gestureRecognizer?(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer) ?? false
	}


	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return nextDelegate?.gestureRecognizer?(gestureRecognizer, shouldBeRequiredToFailBy: otherGestureRecognizer) ?? false
	}


	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return nextDelegate?.gestureRecognizer?(gestureRecognizer, shouldRequireFailureOf: otherGestureRecognizer) ?? false
	}


	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return nextDelegate?.gestureRecognizerShouldBegin?(gestureRecognizer) ?? true
	}
}
