import CoreGraphics


// allow integers in CGFloat math
public func +  <T: IntegerType> (a: CGFloat, b: T) -> CGFloat { return a + b }
public func +  <T: IntegerType> (a: T, b: CGFloat) -> CGFloat { return a + b }
public func += <T: IntegerType> (inout a: CGFloat, b: T) { a += b }
public func -  <T: IntegerType> (a: CGFloat, b: T) -> CGFloat { return a + b }
public func -  <T: IntegerType> (a: T, b: CGFloat) -> CGFloat { return a + b }
public func -= <T: IntegerType> (inout a: CGFloat, b: T) { a -= b }
public func *  <T: IntegerType> (a: CGFloat, b: T) -> CGFloat { return a * b }
public func *  <T: IntegerType> (a: T, b: CGFloat) -> CGFloat { return a * b }
public func *= <T: IntegerType> (inout a: CGFloat, b: T) { a *= b }
public func /  <T: IntegerType> (a: CGFloat, b: T) -> CGFloat { return a / b }
public func /  <T: IntegerType> (a: T, b: CGFloat) -> CGFloat { return a / b }
public func /= <T: IntegerType> (inout a: CGFloat, b: T) { a /= b }
public func %  <T: IntegerType> (a: CGFloat, b: T) -> CGFloat { return a / b }
public func %= <T: IntegerType> (inout a: CGFloat, b: T) { a /= b }
