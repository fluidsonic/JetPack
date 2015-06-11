import Foundation
import ObjectiveC

var fractionCompletedHandlerKey: UInt8 = 0


public extension NSProgress {

	public var fractionCompletedHandler: (Double -> Void)? {
		get {
			return objc_getAssociatedObject(self, &fractionCompletedHandlerKey) as! (Double -> Void)?
		}
		set {
			if let fractionCompletedHandler = newValue {
				objc_setAssociatedObject(self, &fractionCompletedHandlerKey, Observer(progress: self, fractionCompletedHandler: fractionCompletedHandler), objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
			}
			else {
				objc_setAssociatedObject(self, &fractionCompletedHandlerKey, nil, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
			}
		}
	}
}



private class Observer: NSObject {

	private let fractionCompletedHandler: Double -> Void
	private unowned var progress: NSProgress


	private init(progress: NSProgress, fractionCompletedHandler: Double -> Void) {
		self.fractionCompletedHandler = fractionCompletedHandler
		self.progress = progress

		super.init()

		progress.addObserver(self, forKeyPath: "fractionCompleted", options: nil, context: nil)
	}


	private override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
		fractionCompletedHandler(progress.fractionCompleted)
	}
}
