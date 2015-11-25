import UIKit


@IBDesignable
public /* non-final */ class ImageView: View {

	public typealias Session = _ImageViewSession
	public typealias SessionListener = _ImageViewSessionListener
	public typealias Source = _ImageViewSource

	private var activityIndicatorIsVisible = false
	private var drawFrame = CGRect()
	private var isLayouting = false
	private var isSettingImage = false
	private var isSettingImageFromSource = false
	private var isSettingSource = false
	private var isSettingSourceFromImage = false
	private var lastDrawnTintColor: UIColor?
	private var lastLayoutedSize = CGSize()
	private var sourceImageRetrievalCompleted = false
	private var sourceSession: Session?
	private var sourceSessionConfigurationIsValid = true


	public override init() {
		super.init()

		super.contentMode = .Redraw

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


	public var clipsImageToPadding = false {
		didSet {
			guard clipsImageToPadding != oldValue else{
				return
			}

			if image != nil {
				setNeedsDisplay()
			}

			invalidateConfiguration()
		}
	}


	@available(*, unavailable, message="Use .gravity and .scaleMode instead.")
	public final override var contentMode: UIViewContentMode {
		get { return super.contentMode }
		set { super.contentMode = newValue }
	}


	public override func didMoveToWindow() {
		super.didMoveToWindow()

		if window != nil {
			startOrUpdateSourceSession()
		}
	}


	public override func drawRect(rect: CGRect) {
		guard let image = image else {
			return
		}

		updateDrawFrame()

		guard !drawFrame.isEmpty else {
			return
		}

		let bounds = self.bounds
		let padding = self.padding

		let needsClipping = clipsImageToPadding && !padding.isEmpty
		let needsTinting = image.renderingMode == .AlwaysTemplate
		let needsSavingState = needsClipping || needsTinting

		let context = UIGraphicsGetCurrentContext()
		if needsSavingState {
			CGContextSaveGState(context)
		}
		if needsClipping {
			CGContextClipToRect(context, bounds.insetBy(padding))
		}

		if needsTinting {
			let transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1, -1), 0, -bounds.height)
			let drawFrame = self.drawFrame.transform(transform)

			CGContextConcatCTM(context, transform)
			CGContextClipToMask(context, drawFrame, image.CGImage)
			tintColor.setFill()
			CGContextFillRect(context, drawFrame)

			lastDrawnTintColor = tintColor
		}
		else {
			image.drawInRect(drawFrame)

			lastDrawnTintColor = nil
		}

		if needsSavingState {
			CGContextRestoreGState(context)
		}
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

			invalidateConfiguration()
		}
	}


	@IBInspectable
	public var image: UIImage? {
		didSet {
			precondition(!isSettingImage, "Cannot recursively set ImageView's 'image'.")
			precondition(!isSettingSource || isSettingImageFromSource, "Cannot recursively set ImageView's 'image' and 'source'.")

			isSettingImage = true
			defer {
				isSettingImage = false
			}

			if image == oldValue {
				return
			}

			if !isSettingImageFromSource {
				isSettingSourceFromImage = true
				source = nil
				isSettingSourceFromImage = false
			}

			updateScales()
			updateOpaque()
			setNeedsDisplay()

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

		startOrUpdateSourceSession()
	}


	public var optimalImageSize: CGSize {
		let size = bounds.size.insetBy(padding).scaleBy(gridScaleFactor)
		guard size.width > 0 && size.height > 0 else {
			return .zero
		}

		return size
	}


	@IBInspectable
	public var padding = UIEdgeInsets() {
		didSet {
			if padding == oldValue {
				return
			}

			setNeedsLayout()

			if image != nil {
				updateOpaque()
				setNeedsDisplay()
			}

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


	@IBInspectable
	public var scaling: Scaling = .FitInside {
		didSet {
			guard scaling != oldValue else {
				return
			}

			if image != nil {
				setNeedsDisplay()
			}

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

		guard let image = image else {
			return .zero
		}

		let imageSize = image.size
		return alignToGrid(CGSize(width: imageSize.width + padding.left + padding.right, height: imageSize.height + padding.top + padding.bottom))
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

		if tintColor != lastDrawnTintColor {
			setNeedsDisplay()
		}
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


	private func updateDrawFrame() {
		guard let image = image else {
			self.drawFrame = .zero
			return
		}

		let imageSize = image.size
		let availableFrame = CGRect(size: bounds.size).insetBy(padding)

		guard !imageSize.isEmpty && availableFrame.width > 0 && availableFrame.height > 0 else {
			self.drawFrame = .zero
			return
		}

		var drawFrame = CGRect()

		let gravity = self.gravity
		let scaling = self.scaling

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

		self.drawFrame = alignToGrid(drawFrame)
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


	private func updateScales() {
		let scale = image?.scale ?? 1
		contentScaleFactor = scale
		layer.rasterizationScale = scale
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
