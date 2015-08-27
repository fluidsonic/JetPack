import UIKit


public extension UIImage {

	public static func fromColor(color: UIColor, withSize size: CGSize = CGSize(square: 1), scale: CGFloat = 1) -> UIImage {
		let frame = CGRect(size: size.sizeScaledBy(scale))

		UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)

		let context = UIGraphicsGetCurrentContext()
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, frame)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}


	public convenience init?(placeholderOfSize size: CGSize) {
		let context = CGBitmapContextCreate(nil, Int(ceil(size.width)), Int(ceil(size.height)), 8, 0, CGColorSpaceCreateDeviceRGB(), CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue))
		let cgimage = CGBitmapContextCreateImage(context)

		self.init(CGImage: cgimage, scale: 1, orientation: .Up)
	}


	public var hasAlphaChannel: Bool {
		let info = CGImageGetAlphaInfo(CGImage)
		switch info {
		case .First, .Last, .Only, .PremultipliedFirst, .PremultipliedLast:
			return true

		case .None, .NoneSkipFirst, .NoneSkipLast:
			return false
		}
	}


	public static func templateNamed(name: String) -> UIImage? {
		return self.init(named: name)?.imageWithRenderingMode(.AlwaysTemplate)
	}
}
