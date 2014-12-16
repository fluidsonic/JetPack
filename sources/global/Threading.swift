import Foundation


public func onMainThread(block: Block) {
	dispatch_async(dispatch_get_main_queue(), block)
}


public func onMainThread(afterDelay delay: NSTimeInterval, block: Block) {
	let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
	dispatch_after(time, dispatch_get_main_queue(), block)
}


public func timer(#delay: NSTimeInterval, callback: Block) -> NSTimer {
	return NSTimer.scheduledTimerWithTimeInterval(delay, target: blockTimerHandler, selector: "handle:", userInfo: StrongReference(callback), repeats: false)
}





private let blockTimerHandler = BlockTimerHandler()

private class BlockTimerHandler: NSObject {

	@objc
	func handle(timer: NSTimer) {
		let handlerReference = timer.userInfo as StrongReference<Block>
		handlerReference.target?()
	}
}
