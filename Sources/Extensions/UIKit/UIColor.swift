import CoreImage
import UIKit


public extension UIColor {

	public typealias GrayscaleComponents = (white: CGFloat, alpha: CGFloat)
	public typealias HsbaComponents = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
	public typealias RgbaComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)


	@nonobjc
	public convenience init(rgb: Int) {
		self.init(rgb: rgb, alpha: 1)
	}


	@nonobjc
	public convenience init(rgb: Int, alpha: CGFloat) {
		let red   = CGFloat((rgb >> 16) & 0xFF) / 255
		let green = CGFloat((rgb >> 8)  & 0xFF) / 255
		let blue  = CGFloat(rgb         & 0xFF) / 255

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}


	@nonobjc
	public convenience init(rgba: Int) {
		let red   = CGFloat((rgba >> 24) & 0xFF) / 255
		let green = CGFloat((rgba >> 16) & 0xFF) / 255
		let blue  = CGFloat((rgba >> 8)  & 0xFF) / 255
		let alpha = CGFloat( rgba        & 0xFF) / 255

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}


	@objc(JetPack_alpha)
	public var alpha: CGFloat {
		return rgbaComponents?.alpha ?? hsbaComponents?.alpha ?? grayscaleComponents?.alpha ?? 1
	}


	@nonobjc
	public var grayscaleComponents: GrayscaleComponents? {
		var components = GrayscaleComponents(white: 0, alpha: 0)
		guard getWhite(&components.white, alpha: &components.alpha) else {
			return nil
		}

		return components
	}


	@nonobjc
	public var hsbaComponents: HsbaComponents? {
		var components = HsbaComponents(hue: 0, saturation: 0, brightness: 0, alpha: 0)
		guard getHue(&components.hue, saturation: &components.saturation, brightness: &components.brightness, alpha: &components.alpha) else {
			return nil
		}

		return components
	}


	@nonobjc
	@warn_unused_result
	public func interpolateTo(destination: UIColor, fraction: CGFloat) -> UIColor {
		guard let rgba = rgbaComponents, destinationRgba = destination.rgbaComponents else {
			return self
		}

		return UIColor(
			red:   rgba.red   + ((destinationRgba.red   - rgba.red)   * fraction),
			green: rgba.green + ((destinationRgba.green - rgba.green) * fraction),
			blue:  rgba.blue  + ((destinationRgba.blue  - rgba.blue)  * fraction),
			alpha: rgba.alpha + ((destinationRgba.alpha - rgba.alpha) * fraction)
		)
	}


	@nonobjc
	@warn_unused_result
	public func overlayWithColor(overlayColor: UIColor) -> UIColor {
		guard let components = rgbaComponents, overlayComponents = overlayColor.rgbaComponents else {
			return overlayColor
		}

		if components.alpha <= 0 {
			return overlayColor
		}
		if overlayComponents.alpha <= 0 {
			return self
		}
		if overlayComponents.alpha >= 1 {
			return overlayColor
		}

		let fraction = 1 - overlayComponents.alpha
		let overlayFraction = overlayComponents.alpha

		return UIColor(
			red:   (components.red   * fraction) + (overlayComponents.red   * overlayFraction),
			green: (components.green * fraction) + (overlayComponents.green * overlayFraction),
			blue:  (components.blue  * fraction) + (overlayComponents.blue  * overlayFraction),
			alpha: components.alpha
		)
	}


	@nonobjc
	@warn_unused_result
	public static func random(alpha: CGFloat = 1) -> Self {
		return self.init(
			red:   CGFloat(arc4random_uniform(255)) / 255,
			green: CGFloat(arc4random_uniform(255)) / 255,
			blue:  CGFloat(arc4random_uniform(255)) / 255,
			alpha: alpha
		)
	}


	@nonobjc
	public var rgbaComponents: RgbaComponents? {
		var components = RgbaComponents(red: 0, green: 0, blue: 0, alpha: 0)
		guard getRed(&components.red, green: &components.green, blue: &components.blue, alpha: &components.alpha) else {
			return nil
		}

		return components
	}


	@nonobjc
	public var tintAlpha: CGFloat? {
		guard let color = self as? ColorUsingTintColor else {
			return nil
		}

		return color.alpha
	}


	@nonobjc
	@warn_unused_result
	public static func tintColor() -> UIColor {
		return tintColorWithAlpha(1)
	}


	@nonobjc
	@warn_unused_result
	public static func tintColorWithAlpha(alpha: CGFloat) -> UIColor {
		if alpha >= 1 {
			return ColorUsingTintColor.fullAlpha
		}

		return ColorUsingTintColor(alpha: max(alpha, 0))
	}


	@objc(JetPack_tintedWithColor:)
	@warn_unused_result
	public func tintedWithColor(color: UIColor) -> UIColor {
		return self
	}
}



private final class ColorUsingTintColor: UIColor {

	private static let fullAlpha = ColorUsingTintColor(alpha: 1)

	private let _alpha: CGFloat


	private init(alpha: CGFloat) {
		_alpha = alpha

		super.init()
	}


	private override var alpha: CGFloat {
		return _alpha
	}


	private required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
		fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
	}


	private override var CGColor: CGColorRef {
		return placeholderColorForReason("CGColor").CGColor
	}


	private override var CIColor: CoreImage.CIColor {
		return placeholderColorForReason("CIColor").CIColor
	}


	private dynamic var colorSpaceName: String { // public in Mac, probably private in iOS
		return "tint"
	}


	private override func colorWithAlphaComponent(requestedAlpha: CGFloat) -> UIColor {
		let alpha = requestedAlpha.clamp(min: 0, max: 1)
		if alpha == self.alpha {
			return self
		}

		return UIColor.tintColorWithAlpha(alpha)
	}


	private override var description: String {
		return (alpha >= 1 ? "UIColor.tintColor()" : "UIColor.tintColorWithAlpha(\(alpha))")
	}


	private override func getHue(hue: UnsafeMutablePointer<CGFloat>, saturation: UnsafeMutablePointer<CGFloat>, brightness: UnsafeMutablePointer<CGFloat>, alpha: UnsafeMutablePointer<CGFloat>) -> Bool {
		return false
	}


	private override func getRed(red: UnsafeMutablePointer<CGFloat>, green: UnsafeMutablePointer<CGFloat>, blue: UnsafeMutablePointer<CGFloat>, alpha: UnsafeMutablePointer<CGFloat>) -> Bool {
		return false
	}


	private override func getWhite(white: UnsafeMutablePointer<CGFloat>, alpha: UnsafeMutablePointer<CGFloat>) -> Bool {
		return false
	}


	private override var hash: Int {
		return 123 ^ _alpha.hashValue
	}


	private override func isEqual(object: AnyObject?) -> Bool {
		if object === self {
			return true
		}
		guard let color = object as? ColorUsingTintColor else {
			return false
		}

		return alpha == color.alpha
	}


	private func placeholderColorForReason(reason: String) -> UIColor {
		log("\(self).\(reason) was used instead of applying an actual tint color by using .tintedWithColor(_:) first")

		return UIColor(red: 1, green: 0, blue: 0, alpha: alpha)
	}


	private override func set() {
		placeholderColorForReason("set()").set()
	}


	private override func setFill() {
		placeholderColorForReason("setFill()").setFill()
	}


	private override func setStroke() {
		placeholderColorForReason("setStroke()").setStroke()
	}


	private override func tintedWithColor(tintColor: UIColor) -> UIColor {
		return tintColor.colorWithAlphaComponent(alpha * tintColor.alpha)
	}
}
