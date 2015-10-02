import UIKit


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

		opaque = false
		userInteractionEnabled = false
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	#if TARGET_INTERFACE_BUILDER
		public convenience init(frame: CGRect) {
			self.init()

			self.frame = frame
		}
	#endif


	deinit {
		sourceCancellation?()
	}


	@available(*, unavailable, message="Use .gravity and .scaleMode instead.")
	public final override var contentMode: UIViewContentMode {
		get { return super.contentMode }
		set { super.contentMode = newValue }
	}


	@IBInspectable
	public var gravity: Gravity = .Center {
		didSet {
			guard gravity != oldValue else {
				return
			}

			if image != nil && scaling != .FitIgnoringAspectRatio {
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
					let transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1, -1), 0, -viewSize.height)
					let drawFrame = self.drawFrame.transform(transform)

					let context = UIGraphicsGetCurrentContext()
					CGContextSaveGState(context)
					CGContextConcatCTM(context, transform)
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


	@IBInspectable
	public var scaling: Scaling = .FitInside {
		didSet {
			guard scaling != oldValue else {
				return
			}

			if image != nil {
				setNeedsDisplay()
			}
		}
	}


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
							log("ImageView.Source called the completion closure after it was cancelled. The call will be ignored.")
							return
						}
						if imageView.isSettingImageFromSource {
							log("ImageView.Source called the completion closure from within an 'image' property observer. The call will be ignored.")
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

		let gravity = self.gravity
		let scaling = self.scaling
		let imageSize: CGSize
		let availableFrame = CGRect(size: bounds.size).insetBy(padding)

		if let image = image {
			imageSize = image.size

			if !imageSize.isEmpty && !availableFrame.isEmpty {
				switch scaling {
				case .FitIgnoringAspectRatio:
					drawFrame.size = availableFrame.size

				case .FitInside, .FitOutside:
					let horizontalScale = availableFrame.width / imageSize.width
					let verticalScale = availableFrame.height / imageSize.height
					let scale = (scaling == .FitInside ? min : max)(horizontalScale, verticalScale)

					drawFrame.size = imageSize.scaleBy(scale)

				case .FitHorizontally:
					drawFrame.width = availableFrame.width
					drawFrame.height = imageSize.height * (drawFrame.width / imageSize.width)

				case .FitHorizontallyIgnoringAspectRatio:
					drawFrame.width = availableFrame.width
					drawFrame.height = imageSize.height

				case .FitVertically:
					drawFrame.height = availableFrame.height
					drawFrame.width = imageSize.width * (drawFrame.height / imageSize.height)

				case .FitVerticallyIgnoringAspectRatio:
					drawFrame.height = availableFrame.height
					drawFrame.width = imageSize.width

				case .None:
					drawFrame.size = imageSize
				}

				switch gravity.horizontal {
				case .Left:
					drawFrame.left = availableFrame.left

				case .Center:
					drawFrame.horizontalCenter = availableFrame.horizontalCenter

				case .Right:
					drawFrame.right = availableFrame.right
				}

				switch gravity.vertical {
				case .Top:
					drawFrame.top = availableFrame.top

				case .Center:
					drawFrame.verticalCenter = availableFrame.verticalCenter

				case .Bottom:
					drawFrame.bottom = availableFrame.bottom
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



	public enum Gravity {
		case BottomCenter
		case BottomLeft
		case BottomRight
		case Center
		case CenterLeft
		case CenterRight
		case TopCenter
		case TopLeft
		case TopRight


		public init(horizontal: Horizontal, vertical: Vertical) {
			switch vertical {
			case .Bottom:
				switch horizontal {
					case .Left:   self = .BottomLeft
					case .Center: self = .BottomCenter
					case .Right:  self = .BottomRight
				}

			case .Center:
				switch horizontal {
					case .Left:   self = .CenterLeft
					case .Center: self = .Center
					case .Right:  self = .CenterRight
				}

			case .Top:
				switch horizontal {
				case .Left:   self = .TopLeft
				case .Center: self = .TopCenter
				case .Right:  self = .TopRight
				}
			}
		}


		public var horizontal: Horizontal {
			switch self {
			case .BottomLeft, .CenterLeft, .TopLeft:
				return .Left

			case .BottomCenter, .Center, .TopCenter:
				return .Center

			case .BottomRight, .CenterRight, .TopRight:
				return .Right
			}
		}


		public var vertical: Vertical {
			switch self {
			case .BottomCenter, .BottomLeft, .BottomRight:
				return .Bottom

			case .Center, .CenterLeft, .CenterRight:
				return .Center

			case .TopCenter, .TopLeft, .TopRight:
				return .Top
			}
		}



		public enum Horizontal {
			case Center
			case Left
			case Right
		}


		public enum Vertical {
			case Bottom
			case Center
			case Top
		}
	}


	public enum Scaling {
		case FitIgnoringAspectRatio
		case FitInside
		case FitHorizontally
		case FitHorizontallyIgnoringAspectRatio
		case FitOutside
		case FitVertically
		case FitVerticallyIgnoringAspectRatio
		case None
	}
}


public protocol _ImageViewSource {

	func retrieveImageForImageView (imageView: ImageView, completion: UIImage? -> Void) -> (Void -> Void)
}
