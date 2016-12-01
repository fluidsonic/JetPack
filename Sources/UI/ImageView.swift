import UIKit


@objc(JetPack_ImageView)
public /* non-final */ class ImageView: View {

	public typealias Session = _ImageViewSession
	public typealias SessionListener = _ImageViewSessionListener
	public typealias Source = _ImageViewSource

	private var activityIndicatorIsVisible = false
	private var imageLayer = ImageLayer()
	private var isLayouting = false
	private var isSettingImage = false
	private var isSettingImageFromSource = false
	private var isSettingSource = false
	private var isSettingSourceFromImage = false
	private var lastAppliedTintColor: UIColor?
	private var lastLayoutedSize = CGSize()
	private var sourceImageRetrievalCompleted = false
	private var sourceSession: Session?
	private var sourceSessionConfigurationIsValid = true
	private var tintedImage: UIImage?

	public var imageChanged: Closure?


	public override init() {
		super.init()

		userInteractionEnabled = false

		layer.addSublayer(imageLayer)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	deinit {
		sourceSession?.stopRetrievingImage()
	}


	private var _activityIndicator: UIActivityIndicatorView?
	public final var activityIndicator: UIActivityIndicatorView {
		return _activityIndicator ?? {
			let child = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
			child.hidesWhenStopped = false
			child.alpha = 0
			child.startAnimating()

			_activityIndicator = child

			return child
		}()
	}


	private var activityIndicatorShouldBeVisible: Bool {
		guard showsActivityIndicatorWhileLoading else {
			return false
		}
		guard source != nil && !sourceImageRetrievalCompleted else {
			return false
		}

		return true
	}


	private func computeImageLayerFrame() -> CGRect {
		guard let image = image else {
			return .zero
		}

		let imageSize = image.size
		let maximumImageLayerFrame = CGRect(size: bounds.size).insetBy(padding)

		guard imageSize.isPositive && maximumImageLayerFrame.size.isPositive else {
			return .zero
		}

		let gravity = self.gravity
		let scaling = self.scaling

		var imageLayerFrame = CGRect()

		switch scaling {
		case .FitIgnoringAspectRatio:
			imageLayerFrame.size = maximumImageLayerFrame.size

		case .FitInside, .FitOutside:
			let horizontalScale = maximumImageLayerFrame.width / imageSize.width
			let verticalScale = maximumImageLayerFrame.height / imageSize.height
			let scale = (scaling == .FitInside ? min : max)(horizontalScale, verticalScale)

			imageLayerFrame.size = imageSize.scaleBy(scale)

		case .FitHorizontally:
			imageLayerFrame.width = maximumImageLayerFrame.width
			imageLayerFrame.height = imageSize.height * (imageLayerFrame.width / imageSize.width)

		case .FitHorizontallyIgnoringAspectRatio:
			imageLayerFrame.width = maximumImageLayerFrame.width
			imageLayerFrame.height = imageSize.height

		case .FitVertically:
			imageLayerFrame.height = maximumImageLayerFrame.height
			imageLayerFrame.width = imageSize.width * (imageLayerFrame.height / imageSize.height)

		case .FitVerticallyIgnoringAspectRatio:
			imageLayerFrame.height = maximumImageLayerFrame.height
			imageLayerFrame.width = imageSize.width

		case .None:
			imageLayerFrame.size = imageSize
		}

		switch gravity.horizontal {
		case .Left:
			imageLayerFrame.left = maximumImageLayerFrame.left

		case .Center:
			imageLayerFrame.horizontalCenter = maximumImageLayerFrame.horizontalCenter

		case .Right:
			imageLayerFrame.right = maximumImageLayerFrame.right
		}

		switch gravity.vertical {
		case .Top:
			imageLayerFrame.top = maximumImageLayerFrame.top

		case .Center:
			imageLayerFrame.verticalCenter = maximumImageLayerFrame.verticalCenter

		case .Bottom:
			imageLayerFrame.bottom = maximumImageLayerFrame.bottom
		}

		switch image.imageOrientation {
		case .Left, .LeftMirrored, .Right, .RightMirrored:
			let center = imageLayerFrame.center
			swap(&imageLayerFrame.width, &imageLayerFrame.height)
			imageLayerFrame.center = center

		case .Down, .DownMirrored, .Up, .UpMirrored:
			break
		}

		imageLayerFrame = alignToGrid(imageLayerFrame)

		return imageLayerFrame
	}


	private func computeImageLayerTransform() -> CGAffineTransform {
		guard let image = image else {
			return CGAffineTransformIdentity
		}

		// TODO support mirrored variants
		let transform: CGAffineTransform
		switch image.imageOrientation {
		case .Down:          transform = CGAffineTransformMakeRotation(.Pi)
		case .DownMirrored:  transform = CGAffineTransformMakeRotation(.Pi)
		case .Left:          transform = CGAffineTransformMakeRotation(-.Pi / 2)
		case .LeftMirrored:  transform = CGAffineTransformMakeRotation(-.Pi / 2)
		case .Right:         transform = CGAffineTransformMakeRotation(.Pi / 2)
		case .RightMirrored: transform = CGAffineTransformMakeRotation(.Pi / 2)
		case .Up:            transform = CGAffineTransformIdentity
		case .UpMirrored:    transform = CGAffineTransformIdentity
		}

		return transform
	}


	@available(*, unavailable, message="Use .gravity and .scaling instead.")
	public final override var contentMode: UIViewContentMode {
		get { return super.contentMode }
		set { super.contentMode = newValue }
	}


	public override func didMoveToWindow() {
		super.didMoveToWindow()

		if window != nil {
			setNeedsLayout()
		}
	}


	public var gravity = Gravity.Center {
		didSet {
			guard gravity != oldValue else {
				return
			}

			setNeedsLayout()

			invalidateConfiguration()
		}
	}


	public var image: UIImage? {
		didSet {
			precondition(!isSettingImage, "Cannot recursively set ImageView's 'image'.")
			precondition(!isSettingSource || isSettingImageFromSource, "Cannot recursively set ImageView's 'image' and 'source'.")

			isSettingImage = true
			defer { isSettingImage = false }

			if image == oldValue {
				return
			}

			if !isSettingImageFromSource {
				isSettingSourceFromImage = true
				source = nil
				isSettingSourceFromImage = false
			}

			lastAppliedTintColor = nil

			setNeedsLayout()

			if (image?.size ?? .zero) != (oldValue?.size ?? .zero) {
				invalidateIntrinsicContentSize()
			}

			updateActivityIndicatorAnimated(true)
		}
	}


	public override func intrinsicContentSize() -> CGSize {
		return sizeThatFits()
	}


	private func invalidateConfiguration() {
		guard sourceSessionConfigurationIsValid else {
			return
		}

		sourceSessionConfigurationIsValid = false
		setNeedsLayout()
	}


	public override func layoutSubviews() {
		isLayouting = true
		defer { isLayouting = false }

		super.layoutSubviews()

		let bounds = self.bounds
		if bounds.size != lastLayoutedSize {
			lastLayoutedSize = bounds.size
			sourceSessionConfigurationIsValid = false
		}

		if let activityIndicator = _activityIndicator {
			activityIndicator.center = bounds.insetBy(padding).center
		}

		let imageLayerFrame = computeImageLayerFrame()
		imageLayer.bounds = CGRect(size: imageLayerFrame.size)
		imageLayer.position = imageLayerFrame.center

		if let image = image where image.renderingMode == .AlwaysTemplate {
			if tintColor != lastAppliedTintColor {
				lastAppliedTintColor = tintColor

				tintedImage = image.imageWithColor(tintColor)
			}
		}
		else {
			tintedImage = nil
		}

		if let contentImage = tintedImage ?? image {
			imageLayer.contents = contentImage.CGImage
			imageLayer.transform = CATransform3DMakeAffineTransform(computeImageLayerTransform())
		}
		else {
			imageLayer.contents = nil
			imageLayer.transform = CATransform3DIdentity
		}

		startOrUpdateSourceSession()
	}


	public var optimalImageSize: CGSize {
		let size = bounds.size.insetBy(padding).scaleBy(gridScaleFactor)
		guard size.width > 0 && size.height > 0 else {
			return .zero
		}

		return size
	}


	public var padding = UIEdgeInsets() {
		didSet {
			if padding == oldValue {
				return
			}

			setNeedsLayout()

			invalidateConfiguration()
			invalidateIntrinsicContentSize()
		}
	}


	public var preferredSize: CGSize? {
		didSet {
			guard preferredSize != oldValue else {
				return
			}

			invalidateConfiguration()
			invalidateIntrinsicContentSize()
		}
	}


	public var scaling = Scaling.FitInside {
		didSet {
			guard scaling != oldValue else {
				return
			}

			setNeedsLayout()

			invalidateConfiguration()
		}
	}


	public var showsActivityIndicatorWhileLoading = true {
		didSet {
			guard showsActivityIndicatorWhileLoading != oldValue else {
				return
			}

			updateActivityIndicatorAnimated(true)
		}
	}


	public override func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		if let preferredSize = preferredSize {
			return alignToGrid(preferredSize)
		}

		let imageSizeThatFits: CGSize

		let availableSize = maximumSize.insetBy(padding)
		if availableSize.isPositive, let imageSize = image?.size where imageSize.isPositive {
			let imageRatio = imageSize.width / imageSize.height

			switch scaling {
			case .FitHorizontally,
			     .FitHorizontallyIgnoringAspectRatio:

				imageSizeThatFits = CGSize(
					width:  availableSize.width,
					height: availableSize.width / imageRatio
				)

			case .FitVertically,
			     .FitVerticallyIgnoringAspectRatio:

				imageSizeThatFits = CGSize(
					width:  availableSize.height * imageRatio,
					height: availableSize.height
				)

			case .FitIgnoringAspectRatio,
			     .FitInside,
			     .FitOutside,
			     .None:
				imageSizeThatFits = imageSize
			}
		}
		else {
			imageSizeThatFits = .zero
		}

		return alignToGrid(CGSize(
			width:  imageSizeThatFits.width  + padding.left + padding.right,
			height: imageSizeThatFits.height + padding.top  + padding.bottom
		))
	}


	public var source: Source? {
		didSet {
			precondition(!isSettingSource, "Cannot recursively set ImageView's 'source'.")
			precondition(!isSettingSource || isSettingSourceFromImage, "Cannot recursively set ImageView's 'source' and 'image'.")

			if let source = source, oldSource = oldValue where source.equals(oldSource) {
				if sourceImageRetrievalCompleted && image == nil {
					stopSourceSession()
					startOrUpdateSourceSession()

					updateActivityIndicatorAnimated(true)
				}

				return
			}
			if source == nil && oldValue == nil {
				return
			}

			isSettingSource = true
			defer {
				isSettingSource = false
			}

			stopSourceSession()

			if !isSettingSourceFromImage {
				isSettingImageFromSource = true
				image = nil
				isSettingImageFromSource = false
			}

			if source != nil {
				sourceSessionConfigurationIsValid = false
				startOrUpdateSourceSession()
			}

			updateActivityIndicatorAnimated(true)
		}
	}


	private func startOrUpdateSourceSession() {
		guard !sourceSessionConfigurationIsValid && window != nil && (isLayouting || !needsLayout), let source = source else {
			return
		}

		let optimalImageSize = self.optimalImageSize
		guard !optimalImageSize.isEmpty else {
			return
		}

		sourceSessionConfigurationIsValid = true

		if let sourceSession = sourceSession {
			sourceSession.imageViewDidChangeConfiguration(self)
		}
		else {
			if let sourceSession = source.createSession() {
				let listener = ClosureSessionListener { [weak self] image in
					precondition(NSThread.isMainThread(), "ImageView.SessionListener.sessionDidRetrieveImage(_:) must be called on the main thread.")

					guard let imageView = self else {
						return
					}

					if sourceSession !== imageView.sourceSession {
						log("ImageView.SessionListener.sessionDidRetrieveImage(_:) was called after session was stopped. The call will be ignored.")
						return
					}
					if imageView.isSettingImageFromSource {
						log("ImageView.SessionListener.sessionDidRetrieveImage(_:) was called from within an 'image' property observer. The call will be ignored.")
						return
					}

					imageView.sourceImageRetrievalCompleted = true

					imageView.isSettingImageFromSource = true
					imageView.image = image
					imageView.isSettingImageFromSource = false

					imageView.updateActivityIndicatorAnimated(true)

					imageView.imageChanged?()
				}

				self.sourceSession = sourceSession

				sourceSession.startRetrievingImageForImageView(self, listener: listener)
			}
			else if let image = source.staticImage {
				sourceImageRetrievalCompleted = true

				isSettingImageFromSource = true
				self.image = image
				isSettingImageFromSource = false

				updateActivityIndicatorAnimated(true)
			}
		}
	}


	private func stopSourceSession() {
		guard let sourceSession = sourceSession else {
			return
		}

		sourceImageRetrievalCompleted = false
		self.sourceSession = nil

		sourceSession.stopRetrievingImage()
	}


	public override func tintColorDidChange() {
		super.tintColorDidChange()

		setNeedsLayout()
	}


	private func updateActivityIndicatorAnimated(animated: Bool) {
		if activityIndicatorShouldBeVisible {
			guard !activityIndicatorIsVisible else {
				return
			}

			let activityIndicator = self.activityIndicator

			activityIndicatorIsVisible = true

			addSubview(activityIndicator)

			Animation.run(animated ? Animation() : nil) {
				activityIndicator.alpha = 1
			}
		}
		else {
			guard activityIndicatorIsVisible, let activityIndicator = _activityIndicator else {
				return
			}

			activityIndicatorIsVisible = false

			Animation.runWithCompletion(animated ? Animation() : nil) { complete in
				activityIndicator.alpha = 0

				complete { _ in
					if !self.activityIndicatorIsVisible {
						activityIndicator.removeFromSuperview()
					}
				}
			}
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
		case FitHorizontally
		case FitHorizontallyIgnoringAspectRatio
		case FitIgnoringAspectRatio
		case FitInside
		case FitOutside
		case FitVertically
		case FitVerticallyIgnoringAspectRatio
		case None
	}
}


public protocol _ImageViewSession: class {

	func imageViewDidChangeConfiguration  (imageView: ImageView)
	func startRetrievingImageForImageView (imageView: ImageView, listener: ImageView.SessionListener)
	func stopRetrievingImage              ()
}


public protocol _ImageViewSessionListener {

	func sessionDidFailToRetrieveImageWithFailure (failure: Failure)
	func sessionDidRetrieveImage                  (image: UIImage)
}


public protocol _ImageViewSource {

	var staticImage: UIImage? { get }

	func createSession () -> ImageView.Session?
	func equals        (source: ImageView.Source) -> Bool
}


extension _ImageViewSource where Self: Equatable {

	public func equals(source: ImageView.Source) -> Bool {
		guard let source = source as? Self else {
			return false
		}

		return self == source
	}
}


public func == (a: ImageView.Source?, b: ImageView.Source?) -> Bool {
	if let a = a, let b = b {
		return a.equals(b)
	}
	else {
		return a == nil && b == nil
	}
}



private struct ClosureSessionListener: ImageView.SessionListener {

	private let didRetrieveImage: UIImage -> Void


	private init(didRetrieveImage: UIImage -> Void) {
		self.didRetrieveImage = didRetrieveImage
	}


	private func sessionDidFailToRetrieveImageWithFailure(failure: Failure) {
		// TODO support this case
	}


	private func sessionDidRetrieveImage(image: UIImage) {
		didRetrieveImage(image)
	}
}



private final class ImageLayer: Layer {

	private override func actionForKey(event: String) -> CAAction? {
		return nil
	}
}
