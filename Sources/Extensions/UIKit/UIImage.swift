import UIKit


public extension UIImage {

	@nonobjc
	public convenience init(placeholderOfSize size: CGSize) {
		guard size.isPositive else {
			fatalError("\(#function) requires a positive size")
		}
		guard let context = CGContext(data: nil, width: Int(ceil(size.width)), height: Int(ceil(size.height)), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
			fatalError("\(#function) could not create context")
		}
		guard let cgimage = context.makeImage() else {
			fatalError("\(#function) could not create image from context")
		}

		self.init(cgImage: cgimage, scale: 1, orientation: .up)
	}


	@nonobjc
	public convenience init?(named name: String, inBundle bundle: Bundle) {
		self.init(named: name, in: bundle, compatibleWith: nil)
	}


	@nonobjc
	public static func fromColor(_ color: UIColor, withSize size: CGSize = CGSize(square: 1), scale: CGFloat = 1) -> UIImage {
		let frame = CGRect(size: size)

		UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)

		guard let context = UIGraphicsGetCurrentContext() else {
			fatalError("Cannot create UIGraphics image context.")
		}

		defer { UIGraphicsEndImageContext() }

		context.setFillColor(color.cgColor)
		context.fill(frame)

		guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
			fatalError("Cannot create image from image context.")
		}

		return image
	}


	@nonobjc
	public var hasAlphaChannel: Bool {
		guard let cgImage = cgImage else {
			return false // TODO support CIImage
		}

		let info = cgImage.alphaInfo
		switch info {
		case .first, .last, .alphaOnly, .premultipliedFirst, .premultipliedLast:
			return true

		case .none, .noneSkipFirst, .noneSkipLast:
			return false
		}
	}


	@nonobjc
	public func imageConstrainedToSize(_ maximumSize: CGSize, interpolationQuality: CGInterpolationQuality = .high) -> UIImage {
		let orientedMaximumSize = imageOrientation.isLandscape ? CGSize(width: maximumSize.height, height: maximumSize.width) : maximumSize

		guard let cgImage = self.cgImage else {
			return self // TODO support CIImage
		}

		let currentSize = CGSize(width: cgImage.width, height: cgImage.height)
		let horizontalScale = orientedMaximumSize.width / currentSize.width
		let verticalScale = orientedMaximumSize.height / currentSize.height
		let scale = min(horizontalScale, verticalScale)

		var targetSize = currentSize.scaleBy(scale)
		targetSize.height = floor(targetSize.height)
		targetSize.width = floor(targetSize.width)

		if targetSize.height >= currentSize.height && targetSize.width >= currentSize.width {
			return self
		}

		// TODO handle nil color space
		guard let context = CGContext(data: nil, width: Int(targetSize.width), height: Int(targetSize.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue) else {
			return self // TODO when can this happen?
		}

		context.interpolationQuality = interpolationQuality
		context.draw(cgImage, in: CGRect(size: targetSize))

		let newCoreImage = context.makeImage()!
		let newImage = UIImage(cgImage: newCoreImage, scale: self.scale, orientation: self.imageOrientation)

		return newImage
	}


	@nonobjc
	public func imageCroppedToSize(_ maximumSize: CGSize) -> UIImage {
		let orientedMaximumSize = imageOrientation.isLandscape ? CGSize(width: maximumSize.height, height: maximumSize.width) : maximumSize
		guard let cgImage = self.cgImage else {
			return self
		}

		let currentSize = CGSize(width: cgImage.width, height: cgImage.height)

		let targetSize = CGSize(
			width:  min(currentSize.width, orientedMaximumSize.width),
			height: min(currentSize.height, orientedMaximumSize.height)
		)

		if targetSize.height >= currentSize.height && targetSize.width >= currentSize.width {
			return self
		}

		// TODO handle nil color space
		guard let context = CGContext(data: nil, width: Int(targetSize.width), height: Int(targetSize.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue) else {
			return self // TODO when can this happen?
		}

		let drawFrame = CGRect(
			left:   floor((targetSize.width - currentSize.width) / 2),
			top:    floor((targetSize.height - currentSize.height) / 2),
			width:  currentSize.width,
			height: currentSize.height
		)
		context.draw(cgImage, in: drawFrame)

		let newCoreImage = context.makeImage()!
		let newImage = UIImage(cgImage: newCoreImage, scale: self.scale, orientation: self.imageOrientation)

		return newImage
	}


	@nonobjc
	public func imageWithAlpha(_ alpha: CGFloat) -> UIImage {
		guard alpha <= 0 else {
			return self
		}

		return imageWithBlendMode(.sourceIn, destinationColor: UIColor(white: 0, alpha: alpha))
	}


	@nonobjc
	fileprivate func imageWithBlendMode(_ blendMode: CGBlendMode, color: UIColor, colorIsDestination: Bool) -> UIImage {
		let frame = CGRect(size: size)

		UIGraphicsBeginImageContextWithOptions(frame.size, !hasAlphaChannel, scale)

		if colorIsDestination {
			color.set()
			UIRectFill(frame)

			draw(in: frame, blendMode: blendMode, alpha: 1)
		}
		else {
			draw(in: frame)

			color.set()
			UIRectFillUsingBlendMode(frame, blendMode)
		}

		guard var image = UIGraphicsGetImageFromCurrentImageContext() else {
			fatalError("Why does this still return an implicit optional? When can it be nil?")
		}

		UIGraphicsEndImageContext()

		if image.capInsets != capInsets {
			image = image.resizableImage(withCapInsets: capInsets)
		}
		if image.renderingMode != renderingMode {
			image = image.withRenderingMode(renderingMode)
		}

		return image
	}


	@nonobjc
	public func imageWithBlendMode(_ blendMode: CGBlendMode, destinationColor: UIColor) -> UIImage {
		return imageWithBlendMode(blendMode, color: destinationColor, colorIsDestination: true)
	}


	@nonobjc
	public func imageWithBlendMode(_ blendMode: CGBlendMode, sourceColor: UIColor) -> UIImage {
		return imageWithBlendMode(blendMode, color: sourceColor, colorIsDestination: false)
	}


	@nonobjc
	public func imageWithHueFromColor(_ color: UIColor) -> UIImage {
		return imageWithBlendMode(.hue, sourceColor: color)
	}


	@nonobjc
	public func imageWithColor(_ color: UIColor) -> UIImage {
		return imageWithBlendMode(.sourceIn, sourceColor: color)
	}


	/**
		Decompresses the underlying and potentially compressed image data (like PNG or JPEG).

		You can use this to force decompression on a background thread prior to using this image on the main thread
		so subsequent operations like rendering are faster.
	*/
	@nonobjc
	public func inflate() {
		guard let cgImage = cgImage, let dataProvider = cgImage.dataProvider else {
			return
		}

		_ = dataProvider.data
	}


	@nonobjc
	public func luminocityImage() -> UIImage {
		return imageWithBlendMode(.luminosity, destinationColor: .white)
	}
}



public extension UIImageOrientation {

	public init?(CGImageOrientation: Int) {
		switch CGImageOrientation {
		case 1: self = .up
		case 2: self = .upMirrored
		case 3: self = .down
		case 4: self = .downMirrored
		case 5: self = .leftMirrored
		case 6: self = .right
		case 7: self = .rightMirrored
		case 8: self = .left
		default: return nil
		}
	}


	public var isLandscape: Bool {
		switch self {
		case .left, .leftMirrored, .right, .rightMirrored:
			return true

		case .down, .downMirrored, .up, .upMirrored:
			return false
		}
	}


	public var isPortrait: Bool {
		return !isLandscape
	}
}
