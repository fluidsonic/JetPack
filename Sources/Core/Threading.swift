import Foundation


public func onBackgroundQueue(_ closure: @escaping Closure) {
	onBackgroundQueueOfPriority(.default, closure: closure)
}


public func onBackgroundQueueOfPriority(_ priority: DispatchQueue.GlobalQueuePriority, closure: @escaping Closure) {
	DispatchQueue.global(priority: priority).async(execute: closure)
}


public func onMainQueue(_ closure: @escaping Closure) {
	DispatchQueue.main.async(execute: closure)
}


public func onMainQueueAfterDelay(_ delay: TimeInterval, closure: @escaping Closure) {
	let time = DispatchTime.now() + Double(Int64(delay * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
	DispatchQueue.main.asyncAfter(deadline: time, execute: closure)
}
