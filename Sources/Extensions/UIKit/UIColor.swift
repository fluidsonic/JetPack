import CoreImage
import UIKit


public extension UIColor {

	public typealias GrayscaleComponents = (white: CGFloat, alpha: CGFloat)
	public typealias HsbaComponents = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
	public typealias RgbaComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)


	@nonobjc
	public convenience init(argb: Int) {
		let alpha = CGFloat((argb >> 24) & 0xFF) / 255
		let red   = CGFloat((argb >> 16) & 0xFF) / 255
		let green = CGFloat((argb >> 8)  & 0xFF) / 255
		let blue  = CGFloat( argb        & 0xFF) / 255

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}


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
	
	public func interpolateTo(_ destination: UIColor, fraction: CGFloat) -> UIColor {
		guard let rgba = rgbaComponents, let destinationRgba = destination.rgbaComponents else {
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
	
	public func overlayWithColor(_ overlayColor: UIColor) -> UIColor {
		guard let components = rgbaComponents, let overlayComponents = overlayColor.rgbaComponents else {
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
	
	public static func random(_ alpha: CGFloat = 1) -> Self {
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
	
	public static func tintColor() -> UIColor {
		return tintColorWithAlpha(1)
	}


	@nonobjc
	
	public static func tintColorWithAlpha(_ alpha: CGFloat) -> UIColor {
		if alpha >= 1 {
			return ColorUsingTintColor.fullAlpha
		}

		return ColorUsingTintColor(alpha: max(alpha, 0))
	}


	@objc(JetPack_tintedWithColor:)
	
	public func tintedWithColor(_ color: UIColor) -> UIColor {
		return self
	}
}



private final class ColorUsingTintColor: UIColor {

	fileprivate static let fullAlpha = ColorUsingTintColor(alpha: 1)

	fileprivate var _alpha = CGFloat(1)


	fileprivate convenience init(alpha: CGFloat) {
		self.init()

		_alpha = alpha
	}


	fileprivate override var alpha: CGFloat {
		return _alpha
	}


	fileprivate override var cgColor: CGColor {
		return placeholderColorForReason("CGColor").cgColor
	}


	fileprivate override var ciColor: CoreImage.CIColor {
		return placeholderColorForReason("CIColor").ciColor
	}


	fileprivate dynamic var colorSpaceName: String { // public in Mac, probably private in iOS
		return "tint"
	}


	fileprivate override func withAlphaComponent(_ requestedAlpha: CGFloat) -> UIColor {
		let alpha = requestedAlpha.coerced(in: 0 ... 1)
		if alpha == self.alpha {
			return self
		}

		return UIColor.tintColorWithAlpha(alpha)
	}


	fileprivate override var description: String {
		return (alpha >= 1 ? "UIColor.tintColor()" : "UIColor.tintColorWithAlpha(\(alpha))")
	}


	fileprivate override func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
		return false
	}


	fileprivate override func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
		return false
	}


	fileprivate override func getWhite(_ white: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
		return false
	}


	fileprivate override var hash: Int {
		return 123 ^ _alpha.hashValue
	}


	fileprivate override func isEqual(_ object: Any?) -> Bool {
		if object as? UIColor === self {
			return true
		}
		guard let color = object as? ColorUsingTintColor else {
			return false
		}

		return alpha == color.alpha
	}


	fileprivate func placeholderColorForReason(_ reason: String) -> UIColor {
		log("\(self).\(reason) was used instead of applying an actual tint color by using .tintedWithColor(_:) first")

		return UIColor(red: 1, green: 0, blue: 0, alpha: alpha)
	}


	fileprivate override func set() {
		placeholderColorForReason("set()").set()
	}


	fileprivate override func setFill() {
		placeholderColorForReason("setFill()").setFill()
	}


	fileprivate override func setStroke() {
		placeholderColorForReason("setStroke()").setStroke()
	}


	fileprivate override func tintedWithColor(_ tintColor: UIColor) -> UIColor {
		return tintColor.withAlphaComponent(alpha * tintColor.alpha)
	}
}
