public class ImageView: View {

	private var drawFrame = CGRect.zero
	private var imageFilterContext: CIContext?


	public override init() {
		super.init()

		opaque = false
	}


	public required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	public override var contentMode: UIViewContentMode {
		didSet {
			if contentMode == oldValue {
				return
			}

			updateDrawFrame()
			setNeedsDisplay()
		}
	}


	public override func drawRect(rect: CGRect) {
		if drawFrame.width <= 0 || drawFrame.height <= 0 {
			return
		}

		if let image = imageAfterApplyingFilters {
			// TODO align draw frame to pixel grid

			image.drawInRect(drawFrame)
		}
	}


	public var image: UIImage? {
		didSet {
			if image === oldValue {
				return
			}

			// TODO might have to set contentScaleFactor here, see https://developer.apple.com/library/ios/qa/qa1708/_index.html

			updateDrawFrame()
			setNeedsDisplay()
		}
	}


	public var imageAfterApplyingFilters: UIImage? {
		if imageFilters.isEmpty {
			return image
		}

		if let image = image {
			var context: CIContext! = imageFilterContext
			if context == nil {
				context = CIContext(options: nil)
				imageFilterContext = context
			}

			let inputImage = CIImage(CGImage: image.CGImage!)

			var filterImage = inputImage
			for filter in imageFilters {
				filter.setValue(filterImage, forKey: "inputImage")
				if let outputImage = filter.outputImage {
					filterImage = outputImage
				}
			}

			let outputImage = context.createCGImage(filterImage, fromRect: inputImage.extent)
			return UIImage(CGImage: outputImage)
		}

		return nil
	}


	public var imageFilters = [CIFilter]() {
		didSet {
			if imageFilters.isEmpty {
				imageFilterContext = nil

				if oldValue.isEmpty {
					return
				}
			}

			updateOpaque()
			setNeedsDisplay()
		}
	}


	public override func layoutSubviews() {
		super.layoutSubviews()

		updateDrawFrame()
	}


	public override func sizeThatFits(size: CGSize) -> CGSize {
		if let image = image {
			return CGSize(width: min(size.width, image.size.width), height: min(size.height, image.size.height))
		}

		return .zero
	}


	private func updateDrawFrame() {
		drawFrame = .zero

		if let image = image {
			let imageSize = image.size
			let viewSize = bounds.size

			if imageSize.width > 0 && imageSize.height > 0 && viewSize.width > 0 && viewSize.height > 0 {
				var drawFrame = CGRect()
				drawFrame.size = imageSize

				switch contentMode {
				case .ScaleToFill:
					drawFrame.size = viewSize

				case .ScaleAspectFill, .ScaleAspectFit:
					let horizontalScale = imageSize.width / viewSize.width
					let verticalScale = imageSize.height / viewSize.height
					let scale = (contentMode == .ScaleAspectFill ? max : min)(horizontalScale, verticalScale)

					drawFrame.width = imageSize.width * scale
					drawFrame.height = imageSize.height * scale

					fallthrough

				case .Center, .Redraw:
					drawFrame.left = (viewSize.width - drawFrame.width) / 2
					drawFrame.top = (viewSize.width - drawFrame.width) / 2

				case .Top:
					drawFrame.left = (viewSize.width - drawFrame.width) / 2

				case .Bottom:
					drawFrame.left = (viewSize.width - drawFrame.width) / 2
					drawFrame.bottom = viewSize.height

				case .Left:
					drawFrame.top = (viewSize.width - drawFrame.width) / 2

				case .Right:
					drawFrame.top = (viewSize.width - drawFrame.width) / 2
					drawFrame.right = viewSize.width

				case .TopLeft:
					break

				case .TopRight:
					drawFrame.right = viewSize.width

				case .BottomLeft:
					drawFrame.bottom = viewSize.height

				case .BottomRight:
					drawFrame.bottom = viewSize.height
					drawFrame.right = viewSize.width
				}
				
				self.drawFrame = drawFrame
			}
		}

		updateOpaque()
	}


	private func updateOpaque() {
		if let image = image {
			if !imageFilters.isEmpty || !drawFrame.contains(bounds) {
				opaque = false
			}
			else {
				opaque = !image.hasAlphaChannel
			}
		}
		else {
			opaque = false
		}
	}
}
