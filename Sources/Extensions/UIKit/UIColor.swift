import CoreImage
import UIKit


public extension UIColor {

	typealias GrayscaleComponents = (white: CGFloat, alpha: CGFloat)
	typealias HsbaComponents = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
	typealias RgbaComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)


	@nonobjc
	convenience init(argb: Int) {
		let alpha = CGFloat((argb >> 24) & 0xFF) / 255
		let red   = CGFloat((argb >> 16) & 0xFF) / 255
		let green = CGFloat((argb >> 8)  & 0xFF) / 255
		let blue  = CGFloat( argb        & 0xFF) / 255

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}


	@nonobjc
	convenience init(rgb: Int) {
		self.init(rgb: rgb, alpha: 1)
	}


	@nonobjc
	convenience init(rgb: Int, alpha: CGFloat) {
		let red   = CGFloat((rgb >> 16) & 0xFF) / 255
		let green = CGFloat((rgb >> 8)  & 0xFF) / 255
		let blue  = CGFloat(rgb         & 0xFF) / 255

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}


	@nonobjc
	convenience init(rgba: Int) {
		let red   = CGFloat((rgba >> 24) & 0xFF) / 255
		let green = CGFloat((rgba >> 16) & 0xFF) / 255
		let blue  = CGFloat((rgba >> 8)  & 0xFF) / 255
		let alpha = CGFloat( rgba        & 0xFF) / 255

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}


	@objc(JetPack_alpha)
	var alpha: CGFloat {
		return rgbaComponents?.alpha ?? hsbaComponents?.alpha ?? grayscaleComponents?.alpha ?? 1
	}


	@nonobjc
	func colorHavingHighestContrast(_ contrastColors: [UIColor]) -> UIColor {
		// http://stackoverflow.com/a/3943023/1183577

		guard let luminocity = luminocity else {
			preconditionFailure("Cannot call .colorWithHighestContrast() on a color which doesn't support a RGBA representation: \(self)")
		}

		var colorWithHighestContrast: UIColor?
		var highestContrast = -CGFloat.infinity

		for contrastColor in contrastColors {
			guard let constrastColorLuminocity = contrastColor.luminocity else {
				continue
			}

			let contrast: CGFloat
			if constrastColorLuminocity > luminocity {
				contrast = (constrastColorLuminocity + 0.05) / (luminocity + 0.05)
			}
			else {
				contrast = (luminocity + 0.05) / (constrastColorLuminocity + 0.05)
			}

			if contrast > highestContrast {
				colorWithHighestContrast = contrastColor
				highestContrast = contrast
			}
		}

		if let colorWithHighestContrast = colorWithHighestContrast {
			return colorWithHighestContrast
		}

		preconditionFailure("Must pass at least one color which supports RGBA representation: \(contrastColors)")
	}


	@nonobjc
	var grayscaleComponents: GrayscaleComponents? {
		var white = CGFloat(0)
		var alpha = CGFloat(0)

		guard getWhite(&white, alpha: &alpha) else {
			return nil
		}

		return GrayscaleComponents(white: white, alpha: alpha)
	}


	@nonobjc
	var hsbaComponents: HsbaComponents? {
		var hue = CGFloat(0)
		var saturation = CGFloat(0)
		var brightness = CGFloat(0)
		var alpha = CGFloat(0)

		guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
			return nil
		}

		return HsbaComponents(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
	}


	@nonobjc
	func interpolate(to destination: UIColor, fraction: CGFloat) -> UIColor {
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
	var isTint: Bool {
		return self is ColorUsingTintColor
	}


	@nonobjc
	var luminocity: CGFloat? {
		// https://www.w3.org/TR/WCAG20/#relativeluminancedef

		guard let components = rgbaComponents else {
			return nil
		}

		let r = components.red   <= 0.03928 ? (components.red   / 12.92) : pow((components.red   + 0.055) / 1.055, 2.4)
		let g = components.green <= 0.03928 ? (components.green / 12.92) : pow((components.green + 0.055) / 1.055, 2.4)
		let b = components.blue  <= 0.03928 ? (components.blue  / 12.92) : pow((components.blue  + 0.055) / 1.055, 2.4)

		return (0.2126 * r) + (0.7152 * g) + (0.0722 * b)
	}


	@nonobjc
	func overlay(with overlayColor: UIColor) -> UIColor {
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

		let maxAlpha = max(components.alpha, overlayComponents.alpha)
		let minAlpha = min(components.alpha, overlayComponents.alpha)

		return UIColor(
			red:   (components.red   * fraction) + (overlayComponents.red   * overlayFraction),
			green: (components.green * fraction) + (overlayComponents.green * overlayFraction),
			blue:  (components.blue  * fraction) + (overlayComponents.blue  * overlayFraction),
			alpha: maxAlpha + (((1 - maxAlpha)) * minAlpha)
		)
	}


	@nonobjc
	static func random(alpha: CGFloat = 1) -> Self {
		return self.init(
			red:   CGFloat(arc4random_uniform(255)) / 255,
			green: CGFloat(arc4random_uniform(255)) / 255,
			blue:  CGFloat(arc4random_uniform(255)) / 255,
			alpha: alpha
		)
	}


	@nonobjc
	var rgbaComponents: RgbaComponents? {
		var red = CGFloat(0)
		var green = CGFloat(0)
		var blue = CGFloat(0)
		var alpha = CGFloat(0)

		guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
			return nil
		}

		return RgbaComponents(red: red, green: green, blue: blue, alpha: alpha)
	}


	@nonobjc
	static var tint: UIColor {
		return tint(alpha: 1)
	}


	@nonobjc
	static func tint(alpha: CGFloat) -> UIColor {
		if alpha >= 1 {
			return ColorUsingTintColor.fullAlpha
		}

		return ColorUsingTintColor(alpha: alpha)
	}


	@nonobjc
	var tintAlpha: CGFloat? {
		return (self as? ColorUsingTintColor)?.alpha
	}


	@available(*, unavailable, renamed: "tint")
	@nonobjc
	static func tintColor() -> UIColor {
		return tint
	}


	@available(*, unavailable, renamed: "tint(alpha:)")
	@nonobjc
	static func tintColorWithAlpha(_ alpha: CGFloat) -> UIColor {
		return tint(alpha: alpha)
	}


	func tinted(for view: UIView, dimsWithTint: Bool) -> UIColor {
		return tinted(with: view.tintColor, forAdjustmentMode: view.tintAdjustmentMode, dimsWithTint: dimsWithTint)
	}


	@objc(JetPack_tintedWithColor:)
	func tinted(with tintColor: UIColor) -> UIColor {
		return self
	}


	func tinted(with tintColor: UIColor, forAdjustmentMode tintAdjustmentMode: UIView.TintAdjustmentMode, dimsWithTint: Bool) -> UIColor {
		if isTint {
			return tinted(with: tintColor)
		}
		else if dimsWithTint && tintAdjustmentMode == .dimmed, let hsbaComponents = hsbaComponents, hsbaComponents.saturation > 0 {
			// TODO should this be based on luminocity, not brightness?
			return UIColor(hue: hsbaComponents.hue, saturation: 0, brightness: hsbaComponents.brightness, alpha: hsbaComponents.alpha)
		}
		else {
			return self
		}
	}


	@available(*, unavailable, renamed: "tinted(with:)")
	@nonobjc
	func tintedWithColor(_ tintColor: UIColor) -> UIColor {
		return tinted(with: tintColor)
	}


	@nonobjc
	func w3cContrast(to color: UIColor) -> CGFloat? {
		guard
			let luminocity = luminocity,
			let colorLuminocity = color.luminocity
		else {
			return nil
		}

		if colorLuminocity > luminocity {
			return (colorLuminocity + 0.05) / (luminocity + 0.05)
		}
		else {
			return (luminocity + 0.05) / (colorLuminocity + 0.05)
		}
	}
}



private class ColorUsingTintColor: UIColor {

	static let fullAlpha = ColorUsingTintColor(alpha: 1)

	private var _alpha = CGFloat(1)


	convenience init(alpha: CGFloat) {
		self.init()

		_alpha = alpha.coerced(atLeast: 0)
	}


	override var alpha: CGFloat {
		return _alpha
	}


	override var cgColor: CGColor {
		return placeholderColor(forReason: "cgColor").cgColor
	}


	override var ciColor: CIColor {
		return placeholderColor(forReason: "ciColor").ciColor
	}


	@objc
	private dynamic var colorSpaceName: String { // public in Mac, probably private in iOS
		return "tint"
	}


	override func withAlphaComponent(_ alpha: CGFloat) -> UIColor {
		let alpha = alpha.coerced(in: 0 ... 1)
		if alpha == self.alpha {
			return self
		}

		return .tint(alpha: alpha)
	}


	override var description: String {
		return (alpha >= 1 ? "UIColor.tint" : "UIColor.tint(alpha: \(alpha))")
	}


	override func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
		return false
	}


	override func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
		return false
	}


	override func getWhite(_ white: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
		return false
	}


	override var hash: Int {
		return 123 ^ _alpha.hashValue
	}


	override func isEqual(_ object: Any?) -> Bool {
		if object as? UIColor === self {
			return true
		}
		guard let color = object as? ColorUsingTintColor else {
			return false
		}

		return alpha == color.alpha
	}


	private func placeholderColor(forReason reason: String) -> UIColor {
		log("\(self).\(reason) was used instead of applying an actual tint color by using .tinted(with:) first")

		return UIColor(red: 1, green: 0, blue: 0, alpha: alpha)
	}


	override func set() {
		placeholderColor(forReason: "set()").set()
	}


	override func setFill() {
		placeholderColor(forReason: "setFill()").setFill()
	}


	override func setStroke() {
		placeholderColor(forReason: "setStroke()").setStroke()
	}


	override func tinted(with tintColor: UIColor) -> UIColor {
		return tintColor.withAlphaComponent(alpha * tintColor.alpha)
	}
}
