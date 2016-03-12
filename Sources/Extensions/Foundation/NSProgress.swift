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
			if let fractionCompletedHandler = newValue {
				observer = Observer(progress: self, fractionCompletedHandler: fractionCompletedHandler)
			}
			else {
				observer = nil
			}
		}
	}


	@nonobjc
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
	private let progress: Unmanaged<NSProgress>


	private init(progress: NSProgress, fractionCompletedHandler: Double -> Void) {
		self.fractionCompletedHandler = fractionCompletedHandler
		self.progress = Unmanaged.passUnretained(progress)

		super.init()

		progress.addObserver(self, forKeyPath: "fractionCompleted", options: [], context: nil)
	}


	deinit {
		progress.takeUnretainedValue().removeObserver(self, forKeyPath: "fractionCompleted", context: nil)
	}


	private override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		fractionCompletedHandler(progress.takeUnretainedValue().fractionCompleted)
	}
}
