import CoreGraphics


extension CGColor: Equatable {}


public func == (a: CGColor, b: CGColor) -> Bool {
	return CGColorEqualToColor(a, b)
}
