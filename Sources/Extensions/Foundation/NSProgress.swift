import Foundation
import ObjectiveC


public extension Progress {

	fileprivate struct AssociatedKeys {
		fileprivate static var observer = UInt8()
	}



	@nonobjc
	var fractionCompletedHandler: ((Double) -> Void)? {
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
	fileprivate var observer: Observer? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.observer) as! Observer?
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.observer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}



private final class Observer: NSObject {

	fileprivate let fractionCompletedHandler: (Double) -> Void
	fileprivate let progress: Unmanaged<Progress>


	fileprivate init(progress: Progress, fractionCompletedHandler: @escaping (Double) -> Void) {
		self.fractionCompletedHandler = fractionCompletedHandler
		self.progress = Unmanaged.passUnretained(progress)

		super.init()

		progress.addObserver(self, forKeyPath: "fractionCompleted", options: [], context: nil)
	}


	deinit {
		progress.takeUnretainedValue().removeObserver(self, forKeyPath: "fractionCompleted", context: nil)
	}


	fileprivate override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		fractionCompletedHandler(progress.takeUnretainedValue().fractionCompleted)
	}
}
