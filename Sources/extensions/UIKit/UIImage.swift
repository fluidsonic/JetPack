import UIKit


public extension UIImage {

	@nonobjc
	public convenience init?(placeholderOfSize size: CGSize) {
		let context = CGBitmapContextCreate(nil, Int(ceil(size.width)), Int(ceil(size.height)), 8, 0, CGColorSpaceCreateDeviceRGB(), CGImageAlphaInfo.PremultipliedLast.rawValue)
		guard let cgimage = CGBitmapContextCreateImage(context) else {
			return nil
		}

		self.init(CGImage: cgimage, scale: 1, orientation: .Up)
	}


	@nonobjc
	public convenience init?(named name: String, inBundle bundle: NSBundle) {
		self.init(named: name, inBundle: bundle, compatibleWithTraitCollection: nil)
	}


	@nonobjc
	@warn_unused_result
	public static func fromColor(color: UIColor, withSize size: CGSize = CGSize(square: 1), scale: CGFloat = 1) -> UIImage {
		let frame = CGRect(size: size.scaleBy(scale))

		UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)

		let context = UIGraphicsGetCurrentContext()
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, frame)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}


	@nonobjc
	public var hasAlphaChannel: Bool {
		let info = CGImageGetAlphaInfo(CGImage)
		switch info {
		case .First, .Last, .Only, .PremultipliedFirst, .PremultipliedLast:
			return true

		case .None, .NoneSkipFirst, .NoneSkipLast:
			return false
		}
	}


	@nonobjc
	public func imageConstrainedToSize(maximumSize: CGSize, interpolationQuality: CGInterpolationQuality = .High) -> UIImage {
		let coreImage = self.CGImage

		let currentSize = CGSize(width: CGImageGetWidth(coreImage), height: CGImageGetHeight(coreImage))

		let horizontalRatio = maximumSize.width / currentSize.width
		let verticalRatio = maximumSize.height / currentSize.height
		let scale = min(horizontalRatio, verticalRatio)

		var targetSize = currentSize.scaleBy(scale)
		targetSize.height = targetSize.height.round
		targetSize.width = targetSize.width.round

		if targetSize.height >= currentSize.height && targetSize.width >= currentSize.width {
			return self
		}

		let context = CGBitmapContextCreate(nil, Int(targetSize.width), Int(targetSize.height), CGImageGetBitsPerComponent(coreImage), 0, CGImageGetColorSpace(coreImage), CGImageGetBitmapInfo(coreImage).rawValue)
		CGContextSetInterpolationQuality(context, interpolationQuality)
		CGContextDrawImage(context, CGRect(size: targetSize), coreImage)

		let newCoreImage = CGBitmapContextCreateImage(context)!
		let newImage = UIImage(CGImage: newCoreImage, scale: self.scale, orientation: self.imageOrientation)

		return newImage
	}
}
