@IBDesignable
public /* non-final */ class ImageView: View {

	public typealias Source = _ImageViewSource

	private var drawFrame = CGRect()
	private var isSettingImage = false
	private var isSettingImageFromSource = false
	private var isSettingSource = false
	private var isSettingSourceFromImage = false
	private var lastDrawnTintColor: UIColor?
	private var sourceCallbackProtectionCount = 0
	private var sourceCancellation: (Void -> Void)?
	private var sourceImageRetrievalCompleted = false


	public override init() {
		super.init()

		contentMode = .ScaleAspectFill
		opaque = false
		userInteractionEnabled = false
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	#if TARGET_INTERFACE_BUILDER
		public required convenience init(frame: CGRect) {
			self.init()

			self.frame = frame
		}
	#endif


	deinit {
		sourceCancellation?()
	}


	public override var contentMode: UIViewContentMode {
		didSet {
			if contentMode == oldValue {
				return
			}

			if image != nil {
				setNeedsDisplay()
			}
		}
	}


	public override func drawRect(rect: CGRect) {
		if let image = image {
			updateDrawFrame()

			if !drawFrame.isEmpty {
				if image.renderingMode == .AlwaysTemplate {
					let viewSize = bounds.size
					
					let context = UIGraphicsGetCurrentContext()
					CGContextSaveGState(context)
					CGContextScaleCTM(context, 1, -1)
					CGContextTranslateCTM(context, 0, -viewSize.height)
					CGContextClipToMask(context, drawFrame, image.CGImage)
					tintColor.setFill()
					CGContextFillRect(context, drawFrame)
					CGContextRestoreGState(context)

					lastDrawnTintColor = tintColor
				}
				else {
					image.drawInRect(drawFrame)

					lastDrawnTintColor = nil
				}
			}
		}
	}


	@IBInspectable
	public var image: UIImage? {
		didSet {
			precondition(!isSettingImage, "Cannot recursively set ImageView's 'image'.")
			precondition(!isSettingSource || isSettingImageFromSource, "Cannot recursively set ImageView's 'image' and 'source'.")

			defer {
				isSettingImage = false
			}

			isSettingImage = true

			if image == oldValue {
				return
			}

			if !isSettingImageFromSource {
				isSettingSourceFromImage = true
				source = nil
				isSettingSourceFromImage = false
			}

			updateOpaque()
			setNeedsDisplay()

		}
	}


	public override func intrinsicContentSize() -> CGSize {
		return sizeThatFits()
	}


	@IBInspectable
	public var padding = UIEdgeInsets() {
		didSet {
			if padding == oldValue {
				return
			}

			if image != nil {
				updateOpaque()
				setNeedsDisplay()
			}
		}
	}


	public var preferredSize: CGSize?


	public override func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		if let preferredSize = preferredSize {
			return preferredSize
		}

		if let image = image {
			let imageSize = image.size
			return CGSize(width: imageSize.width + padding.left + padding.right, height: imageSize.height + padding.top + padding.bottom)
		}

		return .zero
	}


	public var source: Source? {
		didSet {
			precondition(!isSettingSource, "Cannot recursively set ImageView's 'source'.")
			precondition(!isSettingSource || isSettingSourceFromImage, "Cannot recursively set ImageView's 'source' and 'image'.")

			defer {
				isSettingSource = false
			}

			isSettingSource = true

			let protectionCount = ++sourceCallbackProtectionCount
			sourceImageRetrievalCompleted = false

			sourceCancellation?()
			sourceCancellation = nil

			if let source = source {
				sourceCancellation = source.retrieveImageForImageView(self) { [weak self] image in
					precondition(NSThread.isMainThread(), "ImageView.Source completion closure must be called on the main thread.")

					if let imageView = self {
						if protectionCount != imageView.sourceCallbackProtectionCount {
							LOG("ImageView.Source called the completion closure after it was cancelled. The call will be ignored.")
							return
						}
						if imageView.isSettingImageFromSource {
							LOG("ImageView.Source called the completion closure from within an 'image' property observer. The call will be ignored.")
							return
						}

						imageView.sourceImageRetrievalCompleted = true

						imageView.isSettingImageFromSource = true
						imageView.image = image
						imageView.isSettingImageFromSource = false
					}
				}
			}
			else if !isSettingSourceFromImage {
				isSettingImageFromSource = true
				image = nil
				isSettingImageFromSource = false
			}
		}
	}


	public override func tintColorDidChange() {
		super.tintColorDidChange()

		if tintColor != lastDrawnTintColor {
			setNeedsDisplay()
		}
	}


	private func updateDrawFrame() {
		var drawFrame = CGRect()

		let contentMode = self.contentMode
		let imageSize: CGSize
		let availableFrame = CGRect(size: bounds.size).insetBy(padding)

		if let image = image {
			imageSize = image.size

			if !imageSize.isEmpty && !availableFrame.isEmpty {
				drawFrame.top = availableFrame.top
				drawFrame.left = availableFrame.left
				drawFrame.size = imageSize

				switch contentMode {
				case .ScaleToFill:
					drawFrame = availableFrame

				case .ScaleAspectFill, .ScaleAspectFit:
					let horizontalScale = availableFrame.width / imageSize.width
					let verticalScale = availableFrame.height / imageSize.height
					let scale = (contentMode == .ScaleAspectFill ? max : min)(horizontalScale, verticalScale)

					drawFrame.width = imageSize.width * scale
					drawFrame.height = imageSize.height * scale

					fallthrough

				case .Center, .Redraw:
					drawFrame.left += (availableFrame.width - drawFrame.width) / 2
					drawFrame.top += (availableFrame.height - drawFrame.height) / 2

				case .Top:
					drawFrame.left += (availableFrame.width - drawFrame.width) / 2

				case .Bottom:
					drawFrame.left += (availableFrame.width - drawFrame.width) / 2
					drawFrame.bottom = availableFrame.bottom

				case .Left:
					drawFrame.top += (availableFrame.height - drawFrame.height) / 2

				case .Right:
					drawFrame.top += (availableFrame.height - drawFrame.height) / 2
					drawFrame.right = availableFrame.right

				case .TopLeft:
					break

				case .TopRight:
					drawFrame.right = availableFrame.right

				case .BottomLeft:
					drawFrame.bottom = availableFrame.bottom

				case .BottomRight:
					drawFrame.bottom = availableFrame.bottom
					drawFrame.right = availableFrame.right
				}

				drawFrame = roundScaled(drawFrame)
			}
		}
		else {
			imageSize = .zero
		}

		self.drawFrame = drawFrame
	}


	private func updateOpaque() {
		var opaque = true
		if !padding.isEmpty {
			opaque = false
		}
		else if (image?.hasAlphaChannel ?? true) {
			opaque = false
		}

		self.opaque = opaque
	}



	public struct StaticSource: Source {

		var image: UIImage


		public init(image: UIImage) {
			self.image = image
		}


		public func retrieveImageForImageView(imageView: ImageView, completion: UIImage? -> Void) -> (Void -> Void) {
			completion(image)

			return {}
		}
	}
}


public protocol _ImageViewSource {

	func retrieveImageForImageView (imageView: ImageView, completion: UIImage? -> Void) -> (Void -> Void)
}
