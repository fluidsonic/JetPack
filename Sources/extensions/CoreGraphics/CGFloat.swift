import CoreGraphics


public extension CGFloat {

	public static let Epsilon = CGFloat(NativeType.Epsilon)
	public static let Pi = CGFloat(NativeType.Pi)


	public var round: CGFloat {
		return CoreGraphics.round(self)
	}
}
