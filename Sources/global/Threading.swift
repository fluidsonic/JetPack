import Foundation


public func onBackgroundQueue(closure: Closure) {
	onBackgroundQueueOfPriority(.Default, closure: closure)
}


public func onBackgroundQueueOfPriority(priority: DispatchQueuePriority, closure: Closure) {
	dispatch_async(dispatch_get_global_queue(priority.dispatchPriority, 0), closure)
}


public func onMainQueue(closure: Closure) {
	dispatch_async(dispatch_get_main_queue(), closure)
}


public func onMainQueueAfterDelay(delay: NSTimeInterval, closure: Closure) {
	let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * NSTimeInterval(NSEC_PER_SEC)))
	dispatch_after(time, dispatch_get_main_queue(), closure)
}



public enum DispatchQueuePriority {
	case Background
	case Default
	case High
	case Low


	private var dispatchPriority: dispatch_queue_priority_t {
		switch self {
		case .Background: return DISPATCH_QUEUE_PRIORITY_BACKGROUND
		case .Default:    return DISPATCH_QUEUE_PRIORITY_DEFAULT
		case .High:       return DISPATCH_QUEUE_PRIORITY_HIGH
		case .Low:        return DISPATCH_QUEUE_PRIORITY_LOW
		}
	}
}




// remove soon

@available(*, unavailable, renamed="onMainQueue")
public func onMainThread(closure: Closure) {
	onMainQueue(closure)
}


@available(*, unavailable, renamed="onMainQueueAfterDelay")
public func onMainThread(afterDelay delay: NSTimeInterval, closure: Closure) {
	onMainQueueAfterDelay(delay, closure: closure)
}


@available(*, unavailable, renamed="NSTimer.scheduledTimerWithTimeInterval")
public func timer(delay timeInterval: NSTimeInterval, repeats: Bool = false, closure: Closure) -> NSTimer {
	return NSTimer.scheduledTimerWithTimeInterval(timeInterval, repeats: repeats, closure: closure)
}
