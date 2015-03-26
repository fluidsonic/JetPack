import UIKit


public extension UIColor {

	public convenience init(rgb: Int) {
		self.init(rgb: rgb, alpha: 1)
	}


	public convenience init(rgb: Int, alpha: CGFloat) {
		let red   = CGFloat((rgb >> 16) & 0xFF) / 255
		let green = CGFloat((rgb >> 8)  & 0xFF) / 255
		let blue  = CGFloat(rgb         & 0xFF) / 255

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}


	public convenience init(rgba: Int) {
		let red   = CGFloat((rgba >> 24) & 0xFF) / 255
		let green = CGFloat((rgba >> 16) & 0xFF) / 255
		let blue  = CGFloat((rgba >> 8)  & 0xFF) / 255
		let alpha = CGFloat( rgba        & 0xFF) / 255

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}


	public static func random(alpha: CGFloat = 1) -> UIColor {
		return self(
			red:   CGFloat(arc4random_uniform(255)) / 255,
			green: CGFloat(arc4random_uniform(255)) / 255,
			blue:  CGFloat(arc4random_uniform(255)) / 255,
			alpha: alpha
		)
	}
}
