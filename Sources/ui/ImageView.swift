import UIKit


@IBDesignable
public /* non-final */ class ImageView: View {

	public typealias Source = _ImageViewSource

	private var activityIndicatorIsVisible = false
	private var drawFrame = CGRect()
	private var isSettingImage = false
	private var isSettingImageFromSource = false
	private var isSettingSource = false
	private var isSettingSourceFromImage = false
	private var lastDrawnTintColor: UIColor?
	private var sourceCallbackProtectionCount = 0
	private var sourceCancellation: CancelClosure?
	private var sourceImageRetrievalCompleted = false


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
		sourceCancellation?()
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
			startRetrievingImageFromSource()
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
		}
	}


	public override func drawRect(rect: CGRect) {
		if let image = image {
			updateDrawFrame()

			if !drawFrame.isEmpty {
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


	public override func layoutSubviews() {
		super.layoutSubviews()

		if let activityIndicator = _activityIndicator {
			activityIndicator.center = bounds.insetBy(padding).center
		}
	}


	@IBInspectable
	public var padding = UIEdgeInsets() {
		didSet {
			if padding == oldValue {
				return
			}

			if _activityIndicator != nil {
				setNeedsLayout()
			}
			if image != nil {
				updateOpaque()
				setNeedsDisplay()
			}

			invalidateIntrinsicContentSize()
		}
	}


	public var preferredSize: CGSize? {
		didSet {
			guard preferredSize != oldValue else {
				return
			}

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

		if let image = image {
			let imageSize = image.size
			return alignToGrid(CGSize(width: imageSize.width + padding.left + padding.right, height: imageSize.height + padding.top + padding.bottom))
		}

		return .zero
	}


	public var source: Source? {
		didSet {
			precondition(!isSettingSource, "Cannot recursively set ImageView's 'source'.")
			precondition(!isSettingSource || isSettingSourceFromImage, "Cannot recursively set ImageView's 'source' and 'image'.")

			if let source = source, oldSource = oldValue where source.equals(oldSource) {
				if sourceImageRetrievalCompleted && image == nil {
					stopRetrievingImageFromSource()
					startRetrievingImageFromSource()

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

			stopRetrievingImageFromSource()

			if !isSettingSourceFromImage {
				isSettingImageFromSource = true
				image = nil
				isSettingImageFromSource = false
			}

			if source != nil {
				startRetrievingImageFromSource()
			}

			updateActivityIndicatorAnimated(true)
		}
	}


	private func startRetrievingImageFromSource() {
		guard sourceCancellation == nil && window != nil, let source = source else {
			return
		}

		let protectionCount = ++sourceCallbackProtectionCount

		sourceCancellation = source.retrieveImageForImageView(self) { [weak self] image in
			precondition(NSThread.isMainThread(), "ImageView.Source completion closure must be called on the main thread.")

			guard let imageView = self else {
				return
			}

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

			imageView.updateActivityIndicatorAnimated(true)
		}

		if sourceCancellation == nil {
			fatalError("Although CancelClosure is an implicit optional this is just temporary workaround and must never be nil. ImageView source '\(source)' did return nil.")
		}
	}


	private func stopRetrievingImageFromSource() {
		guard let sourceCancellation = sourceCancellation else {
			return
		}

		sourceImageRetrievalCompleted = false

		++sourceCallbackProtectionCount

		sourceCancellation()
		self.sourceCancellation = nil
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

				drawFrame = alignToGrid(drawFrame)
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

	func equals                    (source: ImageView.Source) -> Bool
	func retrieveImageForImageView (imageView: ImageView, completion: UIImage? -> Void) -> CancelClosure
}


extension _ImageViewSource where Self: Equatable {

	public func equals(source: ImageView.Source) -> Bool {
		guard let source = source as? Self else {
			return false
		}

		return self == source
	}
}



public extension ImageView {

	public struct StaticSource: Source, Equatable {

		public var image: UIImage


		public init(image: UIImage) {
			self.image = image
		}


		public func retrieveImageForImageView(imageView: ImageView, completion: UIImage? -> Void) -> CancelClosure {
			completion(image)

			return {}
		}
	}
}


public func == (a: ImageView.StaticSource, b: ImageView.StaticSource) -> Bool {
	return a.image == b.image
}



public extension ImageView {

	public final class UrlSource: Source, Equatable {

		private let downloader: ImageDownloader

		public let isTemplate: Bool
		public let url: NSURL


		public init(url: NSURL, isTemplate: Bool = false) {
			self.isTemplate = isTemplate
			self.url = url

			downloader = ImageDownloader.forUrl(url)
		}


		public func retrieveImageForImageView(imageView: ImageView, completion: UIImage? -> Void) -> CancelClosure {
			return downloader.download { (var image) in
				if self.isTemplate {
					image = image.imageWithRenderingMode(.AlwaysTemplate)
				}

				completion(image)
			}
		}
	}
}


public func == (a: ImageView.UrlSource, b: ImageView.UrlSource) -> Bool {
	return a.url == b.url && a.isTemplate == b.isTemplate
}



private final class ImageCache {

	private let cache = NSCache()


	private init() {}


	private func costForImage(image: UIImage) -> Int {
		// TODO does CGImageGetHeight() include the scale?
		return CGImageGetBytesPerRow(image.CGImage) * CGImageGetHeight(image.CGImage)
	}


	private func imageForKey(key: AnyObject) -> UIImage? {
		return cache.objectForKey(key) as? UIImage
	}


	private func setImage(image: UIImage, forKey key: AnyObject) {
		cache.setObject(image, forKey: key, cost: costForImage(image))
	}


	private static let sharedInstance = ImageCache()
}



private final class ImageDownloader {

	private typealias Completion = UIImage -> Void

	private static var downloaders = [NSURL : ImageDownloader]()

	private var completions = [Int : Completion]()
	private var image: UIImage?
	private var nextId = 0
	private var task: NSURLSessionDataTask?
	private let url: NSURL


	private init(url: NSURL) {
		self.url = url
	}


	private func cancelCompletionWithId(id: Int) {
		completions[id] = nil

		if completions.isEmpty {
			onMainQueue { // wait one cycle. maybe someone cancelled just to retry immediately
				if self.completions.isEmpty {
					self.cancelDownload()
				}
			}
		}
	}


	private func cancelDownload() {
		precondition(completions.isEmpty)

		task?.cancel()
		task = nil
	}


	private func download(completion: Completion) -> CancelClosure {
		if let image = image {
			completion(image)
			return {}
		}

		if let image = ImageCache.sharedInstance.imageForKey(url) {
			self.image = image

			runAllCompletions()
			cancelDownload()

			completion(image)
			return {}
		}

		let id = nextId++
		completions[nextId] = completion

		startDownload()

		return {
			self.cancelCompletionWithId(id)
		}
	}


	private static func forUrl(url: NSURL) -> ImageDownloader {
		if let downloader = downloaders[url] {
			return downloader
		}

		let downloader = ImageDownloader(url: url)
		downloaders[url] = downloader

		return downloader
	}


	private func runAllCompletions() {
		guard let image = image else {
			fatalError("Cannot run completions unless an image was successfully loaded")
		}

		// careful: a completion might get removed while we're calling another one so don't copy the dictionary
		while let (id, completion) = self.completions.first {
			self.completions.removeValueForKey(id)
			completion(image)
		}

		ImageDownloader.downloaders[url] = nil
	}


	private func startDownload() {
		precondition(image == nil)
		precondition(!completions.isEmpty)

		guard self.task == nil else {
			return
		}

		let url = self.url
		let task = NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
			guard let data = data, image = UIImage(data: data) else {
				onMainQueue {
					self.task = nil
				}

				var failureReason: String
				if let error = error {
					failureReason = "\(error)"
				}
				else {
					failureReason = "server returned invalid response or image could not be parsed"
				}

				log("Cannot load image '\(url)': \(failureReason)")

				// TODO retry, handle 4xx, etc.
				return
			}

			image.inflate() // TODO doesn't UIImage(data:) already inflate the image?

			onMainQueue {
				self.task = nil
				self.image = image

				self.runAllCompletions()
			}
		}

		self.task = task
		task.resume()
	}
}
