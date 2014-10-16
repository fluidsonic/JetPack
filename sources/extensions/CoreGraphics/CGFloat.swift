import CoreGraphics


// allow integers in CGFloat math
func +  <T: IntegerType> (a: CGFloat, b: T) -> CGFloat { return a + b }
func +  <T: IntegerType> (a: T, b: CGFloat) -> CGFloat { return a + b }
func += <T: IntegerType> (inout a: CGFloat, b: T) { a += b }
func -  <T: IntegerType> (a: CGFloat, b: T) -> CGFloat { return a + b }
func -  <T: IntegerType> (a: T, b: CGFloat) -> CGFloat { return a + b }
func -= <T: IntegerType> (inout a: CGFloat, b: T) { a -= b }
func *  <T: IntegerType> (a: CGFloat, b: T) -> CGFloat { return a * b }
func *  <T: IntegerType> (a: T, b: CGFloat) -> CGFloat { return a * b }
func *= <T: IntegerType> (inout a: CGFloat, b: T) { a *= b }
func /  <T: IntegerType> (a: CGFloat, b: T) -> CGFloat { return a / b }
func /  <T: IntegerType> (a: T, b: CGFloat) -> CGFloat { return a / b }
func /= <T: IntegerType> (inout a: CGFloat, b: T) { a /= b }
func %  <T: IntegerType> (a: CGFloat, b: T) -> CGFloat { return a / b }
func %= <T: IntegerType> (inout a: CGFloat, b: T) { a /= b }
