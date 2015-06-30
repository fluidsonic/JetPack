import CoreGraphics
import Darwin


public extension CGFloat {

	public static var Pi = CGFloat(M_PI)


	public var abs: CGFloat {
		return CGFloat.abs(self)
	}


	public func clamped(min min: CGFloat, max: CGFloat) -> CGFloat {
		return Swift.min(Swift.max(self, min), max)
	}


	public var rounded: CGFloat {
		return round(self)
	}
}


// allow Int in CGFloat math
// broken, see http://stackoverflow.com/questions/27173744/how-to-properly-support-int-values-in-cgfloat-math-in-swift
/*
public func +  (a: CGFloat, b: Int) -> CGFloat { return a + CGFloat(b) }
public func +  (a: Int, b: CGFloat) -> CGFloat { return CGFloat(a) + b }
public func += (inout a: CGFloat, b: Int)      { a += CGFloat(b) }
public func -  (a: CGFloat, b: Int) -> CGFloat { return a + CGFloat(b) }
public func -  (a: Int, b: CGFloat) -> CGFloat { return CGFloat(a) + b }
public func -= (inout a: CGFloat, b: Int)      { a -= CGFloat(b) }
public func *  (a: CGFloat, b: Int) -> CGFloat { return a * CGFloat(b) }
public func *  (a: Int, b: CGFloat) -> CGFloat { return CGFloat(a) * b }
public func *= (inout a: CGFloat, b: Int)      { a *= CGFloat(b) }
public func /  (a: CGFloat, b: Int) -> CGFloat { return a / CGFloat(b) }
public func /  (a: Int, b: CGFloat) -> CGFloat { return CGFloat(a) / b }
public func /= (inout a: CGFloat, b: Int)      { a /= CGFloat(b) }
public func %  (a: CGFloat, b: Int) -> CGFloat { return a / CGFloat(b) }
public func %= (inout a: CGFloat, b: Int)      { a /= CGFloat(b) }
*/
