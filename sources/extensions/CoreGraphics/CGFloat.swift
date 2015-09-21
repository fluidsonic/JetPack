import CoreGraphics
import Darwin


public extension CGFloat {

	public static let Pi = CGFloat(M_PI)


	public var absolute: CGFloat {
		return CGFloat.abs(self)
	}


	@warn_unused_result
	public func clamp(min min: CGFloat, max: CGFloat) -> CGFloat {
		return Swift.min(Swift.max(self, min), max)
	}


	public var round: CGFloat {
		return CoreGraphics.round(self)
	}
}
