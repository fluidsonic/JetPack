import Foundation


public extension Timer {

	@nonobjc
	public static func scheduledTimerWithTimeInterval(_ timeInterval: TimeInterval, repeats: Bool = false, closure: Closure) -> Timer {
		return scheduledTimer(timeInterval: timeInterval, target: timerHandler, selector: #selector(TimerHandler.handle(_:)), userInfo: StrongReference(closure), repeats: repeats)
	}
}



private let timerHandler = TimerHandler()

private class TimerHandler: NSObject {

	@objc
	fileprivate func handle(_ timer: Timer) {
		let closureReference = timer.userInfo as! StrongReference<Closure>
		closureReference.target()
	}
}
