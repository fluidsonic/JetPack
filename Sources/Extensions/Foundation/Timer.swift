import Foundation


public extension Timer {

	@nonobjc
	static func scheduledTimer(withTimeInterval timeInterval: TimeInterval, block: @escaping (Timer) -> Void) -> Timer {
		return scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: block)
	}
}
