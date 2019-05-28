import Foundation


public extension Timer {

	@nonobjc
	static func scheduledTimer(withTimeInterval timeInterval: TimeInterval, block: @escaping (Timer) -> Void) -> Timer {
		return scheduledTimer_backport(withTimeInterval: timeInterval, repeats: false, block: block)
	}


	@nonobjc
	static func scheduledTimer_backport(withTimeInterval timeInterval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
		return scheduledTimer(timeInterval: timeInterval, target: timerHandler, selector: #selector(TimerHandler.handle(_:)), userInfo: StrongReference(block), repeats: repeats)
	}
}



private let timerHandler = TimerHandler()

private class TimerHandler: NSObject {

	@objc
	fileprivate func handle(_ timer: Timer) {
		let closureReference = timer.userInfo as! StrongReference<(Timer) -> Void>
		closureReference.value(timer)
	}
}
