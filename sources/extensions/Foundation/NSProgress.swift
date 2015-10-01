import Foundation
import ObjectiveC

private var fractionCompletedHandlerKey: UInt8 = 0


public extension NSProgress {

	@nonobjc
	public var fractionCompletedHandler: (Double -> Void)? {
		get {
			guard let observer = objc_getAssociatedObject(self, &fractionCompletedHandlerKey) as! Observer? else {
				return nil
			}

			return observer.fractionCompletedHandler
		}
		set {
			if let fractionCompletedHandler = newValue {
				objc_setAssociatedObject(self, &fractionCompletedHandlerKey, Observer(progress: self, fractionCompletedHandler: fractionCompletedHandler), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			}
			else {
				objc_setAssociatedObject(self, &fractionCompletedHandlerKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			}
		}
	}
}



private class Observer: NSObject {

	private let fractionCompletedHandler: Double -> Void
	private weak var progress: NSProgress?


	private init(progress: NSProgress, fractionCompletedHandler: Double -> Void) {
		self.fractionCompletedHandler = fractionCompletedHandler
		self.progress = progress

		super.init()

		progress.addObserver(self, forKeyPath: "fractionCompleted", options: [], context: nil)
	}


	deinit {
		progress?.removeObserver(self, forKeyPath: "fractionCompleted")
	}


	private override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		guard let progress = progress else {
			return
		}

		fractionCompletedHandler(progress.fractionCompleted)
	}
}
