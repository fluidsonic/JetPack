import UIKit


public extension UIImage {

	public convenience init?(placeholderOfSize size: CGSize) {
		let context = CGBitmapContextCreate(nil, Int(ceil(size.width)), Int(ceil(size.height)), 8, 0, CGColorSpaceCreateDeviceRGB(), CGImageAlphaInfo.PremultipliedLast.rawValue)
		guard let cgimage = CGBitmapContextCreateImage(context) else {
			return nil
		}

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
