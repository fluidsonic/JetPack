import Foundation

// TODO refactor this


public func async(closure: Closure) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), closure)
}


public func async(priority: AsyncPriority, closure: Closure) {
	var dispatchPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
	switch priority {
	case .Background:
		dispatchPriority = DISPATCH_QUEUE_PRIORITY_BACKGROUND

	case .Default:
		break

	case .High:
		dispatchPriority = DISPATCH_QUEUE_PRIORITY_HIGH

	case .Low:
		dispatchPriority = DISPATCH_QUEUE_PRIORITY_LOW
	}

	dispatch_async(dispatch_get_global_queue(dispatchPriority, 0), closure)
}


public func onMainThread(closure: Closure) {
	dispatch_async(dispatch_get_main_queue(), closure)
}


public func onMainThread(afterDelay delay: NSTimeInterval, closure: Closure) {
	let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
	dispatch_after(time, dispatch_get_main_queue(), closure)
}


public func timer(delay delay: NSTimeInterval, repeats: Bool = false, callback: Closure) -> NSTimer {
	return NSTimer.scheduledTimerWithTimeInterval(delay, target: blockTimerHandler, selector: "handle:", userInfo: StrongReference(callback), repeats: repeats)
}




public enum AsyncPriority {
	case Background
	case Default
	case High
	case Low
}



private let blockTimerHandler = BlockTimerHandler()

private class BlockTimerHandler: NSObject {

	@objc
	func handle(timer: NSTimer) {
		let handlerReference = timer.userInfo as! StrongReference<Closure>
		handlerReference.target()
	}
}
