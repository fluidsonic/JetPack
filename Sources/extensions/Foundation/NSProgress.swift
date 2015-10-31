import Foundation
import ObjectiveC


public extension NSProgress {

	private struct AssociatedKeys {
		private static var observer = UInt8()
	}



	@nonobjc
	public var fractionCompletedHandler: (Double -> Void)? {
		get {
			return observer?.fractionCompletedHandler
		}
		set {
			observer?.stopObserving()

			if let fractionCompletedHandler = newValue {
				observer = Observer(progress: self, fractionCompletedHandler: fractionCompletedHandler)
			}
			else {
				observer = nil
			}
		}
	}


	private var observer: Observer? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.observer) as! Observer?
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.observer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}



private final class Observer: NSObject {

	private let fractionCompletedHandler: Double -> Void
	private unowned let progress: NSProgress


	private init(progress: NSProgress, fractionCompletedHandler: Double -> Void) {
		self.fractionCompletedHandler = fractionCompletedHandler
		self.progress = progress

		super.init()

		progress.addObserver(self, forKeyPath: "fractionCompleted", options: [], context: nil)
	}


	private override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		fractionCompletedHandler(progress.fractionCompleted)
	}


	private func stopObserving() {
		progress.removeObserver(self, forKeyPath: "fractionCompleted")
	}
}
