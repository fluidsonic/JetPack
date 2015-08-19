public /* non-final */ class ImageView: View {

	public typealias Source = _ImageViewSource

	private var drawFrame = CGRect()
	private var isSettingImage = false
	private var isSettingImageFromSource = false
	private var isSettingSource = false
	private var isSettingSourceFromImage = false
	private var sourceCallbackProtectionCount = 0
	private var sourceCancellation: (Void -> Void)?
	private var sourceImageRetrievalCompleted = false


	public override init() {
		super.init()

		contentMode = .ScaleAspectFill
		opaque = false
		userInteractionEnabled = false
	}


	deinit {
		sourceCancellation?()
	}


	public required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
					let context = UIGraphicsGetCurrentContext()
					CGContextSaveGState(context)
					CGContextClipToMask(context, drawFrame, image.CGImage)
					tintColor.setFill()
					CGContextFillRect(context, drawFrame)
					CGContextRestoreGState(context)
				}
				else {
					image.drawInRect(drawFrame)
				}
			}
		}
	}


	public var image: UIImage? {
		didSet {
			precondition(!isSettingImage, "Cannot recursively set ImageView's 'image'.")
			precondition(!isSettingSource || isSettingImageFromSource, "Cannot recursively set ImageView's 'image' and 'source'.")

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

			isSettingImage = false
		}
	}


	public var padding = UIEdgeInsets() {
		didSet {
			if padding == oldValue {
				return
			}

			if let image = image {
				updateOpaque()
				setNeedsDisplay()
			}
		}
	}


	public var preferredSize: CGSize?


	public override func sizeThatFits(maximumSize: CGSize) -> CGSize {
		if let size = preferredSize {
			return size.sizeConstrainedToSize(maximumSize)
		}


		if let image = image {
			let imageSize = image.size
			let size = CGSize(width: imageSize.width + padding.left + padding.right, height: imageSize.height + padding.top + padding.bottom)

			return size.sizeConstrainedToSize(maximumSize)
		}

		return .zeroSize
	}


	public var source: Source? {
		didSet {
			precondition(!isSettingSource, "Cannot recursively set ImageView's 'source'.")
			precondition(!isSettingSource || isSettingSourceFromImage, "Cannot recursively set ImageView's 'source' and 'image'.")

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

			isSettingSource = false
		}
	}


	private func updateDrawFrame() {
		var drawFrame = CGRect()

		let contentMode = self.contentMode
		let imageSize: CGSize
		let availableFrame = padding.insetRect(CGRect(size: bounds.size))

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
					drawFrame.top += (availableFrame.width - drawFrame.width) / 2

				case .Top:
					drawFrame.left += (availableFrame.width - drawFrame.width) / 2

				case .Bottom:
					drawFrame.left += (availableFrame.width - drawFrame.width) / 2
					drawFrame.bottom = availableFrame.bottom

				case .Left:
					drawFrame.top += (availableFrame.width - drawFrame.width) / 2

				case .Right:
					drawFrame.top += (availableFrame.width - drawFrame.width) / 2
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
			imageSize = .zeroSize
		}

		self.drawFrame = drawFrame
	}


	private func updateOpaque() {
		var opaque = true
		if !padding.isEmpty {
			opaque = false
		}
		else if !(image?.hasAlphaChannel ?? true) {
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
