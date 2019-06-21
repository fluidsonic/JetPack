import UIKit


@objc(JetPack_Button)
open class Button: View {

	private var _activityIndicator: UIActivityIndicatorView?
	private var _imageView: ImageView?
	private var _textLabel: Label?

	private var defaultAlpha = CGFloat(1)
	private var defaultBackgroundColor: UIColor?
	private var defaultBorderColor: UIColor?
	private var defaultTintColor: UIColor?
	private var highlightingTouch: UITouch?

	open var cancelsTouchForScrollViewTracking = false
	open var tapped: Closure?
	open var touchTolerance = CGFloat(75)


	public override init() {
		super.init()

		clipsToBounds = false
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	public final var activityIndicator: UIActivityIndicatorView {
		get {
			return _activityIndicator ?? {
				let child = UIActivityIndicatorView(style: .white)
				child.hidesWhenStopped = false

				_activityIndicator = child

				return child
			}()
		}
	}


	open override var alpha: CGFloat {
		get { return defaultAlpha }
		set {
			let newAlpha = newValue.coerced(in: 0 ... 1)
			guard newAlpha != defaultAlpha else {
				return
			}

			defaultAlpha = newAlpha

			updateAlpha()
		}
	}


	open var arrangement = Arrangement.imageLeft {
		didSet {
			guard arrangement != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	open override var backgroundColor: UIColor? {
		get { return defaultBackgroundColor }
		set {
			guard newValue != defaultBackgroundColor else {
				return
			}

			defaultBackgroundColor = newValue

			updateBackgroundColor()
		}
	}


	open override var borderColor: UIColor? {
		get { return defaultBorderColor }
		set {
			guard newValue != defaultBorderColor else {
				return
			}

			defaultBorderColor = newValue

			updateBorderColor()
		}
	}


	open override func didMoveToWindow() {
		super.didMoveToWindow()

		if window != nil {
			if let activityIndicator = _activityIndicator, activityIndicator.superview === self {
				activityIndicator.startAnimating()
			}
		}
		else {
			highlighted = false
		}
	}


	open var disabledAlpha: CGFloat? {
		didSet {
			guard disabledAlpha != oldValue else {
				return
			}

			updateAlpha()
		}
	}


	open var disabledBackgroundColor: UIColor? {
		didSet {
			guard disabledBackgroundColor != oldValue else {
				return
			}

			updateBackgroundColor()
		}
	}


	open var enabled = true {
		didSet {
			isUserInteractionEnabled = enabled

			guard enabled != oldValue else {
				return
			}

			updateAlpha()
			updateBackgroundColor()
		}
	}


	open var highlighted = false {
		didSet {
			guard highlighted != oldValue else {
				return
			}

			var animation: Animation? = highlighted ? nil : Animation(duration: 0.3)
			animation?.allowsUserInteraction = true

			animation.runAlways {
				updateHighlightState()
			}
		}
	}


	open var highlightedAlpha: CGFloat? = 0.5 {
		didSet {
			guard highlightedAlpha != oldValue else {
				return
			}

			updateAlpha()
		}
	}


	open var highlightedBackgroundColor: UIColor? {
		didSet {
			guard highlightedBackgroundColor != oldValue else {
				return
			}

			updateBackgroundColor()
		}
	}


	open var highlightedBorderColor: UIColor? {
		didSet {
			guard highlightedBorderColor != oldValue else {
				return
			}

			updateBorderColor()
		}
	}


	open var highlightedTintColor: UIColor? {
		didSet {
			guard highlightedTintColor != oldValue else {
				return
			}

			updateTintColor()
		}
	}


	open var horizontalAlignment = HorizontalAlignment.center {
		didSet {
			guard horizontalAlignment != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	open var imageOffset = UIOffset() {
		didSet {
			guard imageOffset != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	public final var imageView: ImageView {
		get {
			return _imageView ?? {
				let child = ButtonImageView(button: self)
				_imageView = child

				return child
			}()
		}
	}


	fileprivate func imageViewDidChangeSource() {
		setNeedsLayout()
		invalidateIntrinsicContentSize()
	}


	open override var intrinsicContentSize : CGSize {
		return sizeThatFits()
	}


	private func layout(for size: CGSize) -> Layout {
		if size.isEmpty {
			return Layout()
		}

		let wantsActivityIndicator = showsActivityIndicatorAsImage
		let wantsImage = _imageView?.image != nil || _imageView?.source != nil
		let wantsText = !(_textLabel?.text.isEmpty ?? true)

		// step 1: show/hide views

		if !wantsActivityIndicator && !wantsImage && !wantsText {
			return Layout()
		}

		// lazy initialization
		let activityIndicator: UIActivityIndicatorView? = wantsActivityIndicator ? self.activityIndicator : nil
		let imageView: ImageView? = wantsImage ? self.imageView : nil
		let textLabel: Label? = wantsText ? self.textLabel : nil

		let padding = self.padding
		var remainingSize = size.inset(by: padding)

		var activityIndicatorFrame = CGRect()
		var imageViewFrame = CGRect()
		var textLabelFrame = CGRect()

		var numberOfElements = 0
		if wantsImage || wantsActivityIndicator {
			numberOfElements += 1
		}
		if wantsText {
			numberOfElements += 1
		}

		var horizontalAlignment = self.horizontalAlignment
		var verticalAlignment = self.verticalAlignment

		switch arrangement {
		case .imageBottom, .imageTop: // vertical
			// step 2: measure sizes

			if let imageView = imageView {
				if numberOfElements == 1 && verticalAlignment == .fill && horizontalAlignment == .fill {
					imageViewFrame.size = remainingSize
				}
				else {
					imageViewFrame.size = imageView.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(imageView.transform)

					if numberOfElements == 1 {
						if verticalAlignment == .fill {
							imageViewFrame.heightFromTop = remainingSize.height
						}
						else if horizontalAlignment == .fill {
							imageViewFrame.widthFromLeft = remainingSize.width
						}
					}
				}

				remainingSize.height -= imageViewFrame.height
			}
			else if let activityIndicator = activityIndicator {
				imageViewFrame.size = activityIndicator.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(activityIndicator.transform)
				remainingSize.height -= imageViewFrame.height
			}

			if let textLabel = textLabel {
				textLabelFrame.size = textLabel.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(textLabel.transform)
				remainingSize.height -= textLabelFrame.height
			}

			// step 3: measure vertical positions

			var top = CGFloat(0)
			let bottom = size.height

			if arrangement == .imageBottom {
				if wantsText {
					textLabelFrame.top = top
					top = textLabelFrame.bottom
				}
				if wantsImage || wantsActivityIndicator {
					imageViewFrame.top = top
				}
			}
			else {
				if wantsImage || wantsActivityIndicator {
					imageViewFrame.top = top
					top = imageViewFrame.bottom
				}
				if wantsText {
					textLabelFrame.top = top
				}
			}

			// step 4: adjust vertical positions

			if verticalAlignment == .fill && numberOfElements < 2 {
				verticalAlignment = .center
			}

			switch verticalAlignment {
			case .fill:
				if arrangement == .imageBottom {
					imageViewFrame.bottom = bottom
				}
				else {
					textLabelFrame.bottom = bottom
				}

			case .top:
				break // already top


			case .bottom:
				let verticalOffset = remainingSize.height
				textLabelFrame.top += verticalOffset
				imageViewFrame.top += verticalOffset

			case .center:
				let verticalOffset = remainingSize.height / 2
				textLabelFrame.top += verticalOffset
				imageViewFrame.top += verticalOffset
			}

			// step 5: measure horizontal positions

			if wantsImage || wantsActivityIndicator {
				switch horizontalAlignment {
				case .right:
					imageViewFrame.right = size.width

				case .left:
					imageViewFrame.left = 0

				case .center, .fill:
					imageViewFrame.horizontalCenter = size.width / 2
				}
			}

			if wantsText {
				switch horizontalAlignment {
				case .right:
					textLabelFrame.right = size.width

				case .left:
					textLabelFrame.left = 0

				case .center, .fill:
					textLabelFrame.horizontalCenter = size.width / 2
				}
			}

		case .imageLeft, .imageRight: // horizontal
			// step 2: measure sizes

			if let imageView = imageView {
				if numberOfElements == 1 && verticalAlignment == .fill && horizontalAlignment == .fill {
					imageViewFrame.size = remainingSize
				}
				else {
					imageViewFrame.size = imageView.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(imageView.transform)

					if numberOfElements == 1 {
						if verticalAlignment == .fill {
							imageViewFrame.heightFromTop = remainingSize.height
						}
						else if horizontalAlignment == .fill {
							imageViewFrame.widthFromLeft = remainingSize.width
						}
					}
				}

				remainingSize.width -= imageViewFrame.width
			}
			else if let activityIndicator = activityIndicator {
				imageViewFrame.size = activityIndicator.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(activityIndicator.transform)
				remainingSize.width -= imageViewFrame.width
			}

			if let textLabel = textLabel {
				textLabelFrame.size = textLabel.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(textLabel.transform)
				remainingSize.width -= textLabelFrame.width
			}

			// step 3: measure horizontal positions

			var left = CGFloat(0)
			let right = size.width

			if arrangement == .imageRight {
				if wantsText {
					textLabelFrame.left = left
					left = textLabelFrame.right
				}
				if wantsImage || wantsActivityIndicator {
					imageViewFrame.left = left
				}
			}
			else {
				if wantsImage || wantsActivityIndicator {
					imageViewFrame.left = left
					left = imageViewFrame.right
				}
				if wantsText {
					textLabelFrame.left = left
				}
			}

			// step 4: adjust horizontal positions

			if horizontalAlignment == .fill && numberOfElements < 2 {
				horizontalAlignment = .center
			}

			switch horizontalAlignment {
			case .fill:
				if arrangement == .imageRight {
					imageViewFrame.right = right
				}
				else {
					textLabelFrame.right = right
				}

			case .left:
				break // already left

			case .right:
				let horizontalOffset = remainingSize.width
				textLabelFrame.left += horizontalOffset
				imageViewFrame.left += horizontalOffset

			case .center:
				let horizontalOffset = remainingSize.width / 2
				textLabelFrame.left += horizontalOffset
				imageViewFrame.left += horizontalOffset
			}

			// step 5: measure vertical positions

			if wantsImage || wantsActivityIndicator {
				switch verticalAlignment {
				case .bottom:
					imageViewFrame.bottom = size.height

				case .top:
					imageViewFrame.top = 0

				case .center, .fill:
					imageViewFrame.verticalCenter = size.height / 2
				}
			}

			if wantsText {
				switch verticalAlignment {
				case .bottom:
					textLabelFrame.bottom = size.height
					
				case .top:
					textLabelFrame.top = 0
					
				case .center, .fill:
					textLabelFrame.verticalCenter = size.height / 2
				}
			}

		case .imageBehindText:
			// step 2: measure sizes

			if let imageView = imageView {
				if verticalAlignment == .fill && horizontalAlignment == .fill {
					imageViewFrame.size = remainingSize
				}
				else {
					imageViewFrame.size = imageView.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(imageView.transform)

					if verticalAlignment == .fill {
						imageViewFrame.heightFromTop = remainingSize.height
					}
					else if horizontalAlignment == .fill {
						imageViewFrame.widthFromLeft = remainingSize.width
					}
				}
			}
			else if let activityIndicator = activityIndicator {
				imageViewFrame.size = activityIndicator.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(activityIndicator.transform)
			}

			if let textLabel = textLabel {
				if verticalAlignment == .fill && horizontalAlignment == .fill {
					textLabelFrame.size = remainingSize
				}
				else {
					textLabelFrame.size = textLabel.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(textLabel.transform)
				}
			}

			// step 3: measure horizontal positions

			switch horizontalAlignment {
			case .fill, .left:
				imageViewFrame.left = 0
				textLabelFrame.left = 0

			case .right:
				imageViewFrame.right = size.width
				textLabelFrame.right = size.width

			case .center:
				imageViewFrame.horizontalCenter = size.width / 2
				textLabelFrame.horizontalCenter = size.width / 2
			}

			// step 4: measure vertical positions

			switch verticalAlignment {
			case .fill, .top:
				imageViewFrame.top = 0
				textLabelFrame.top = 0

			case .bottom:
				imageViewFrame.bottom = size.height
				textLabelFrame.bottom = size.height

			case .center:
				imageViewFrame.verticalCenter = size.height / 2
				textLabelFrame.verticalCenter = size.height / 2
			}
		}

		// step 6: apply offsets
		if wantsImage || wantsActivityIndicator {
			imageViewFrame += imageOffset
		}
		if wantsText {
			textLabelFrame += textOffset
		}

		// step 7: align activity indicator
		if let activityIndicator = activityIndicator {
			activityIndicatorFrame.size = activityIndicator.sizeThatFitsSize(imageViewFrame.size, allowsTruncation: true).applying(activityIndicator.transform)
			activityIndicatorFrame.center = imageViewFrame.center
		}

		// step 8: apply padding
		activityIndicatorFrame.left += padding.left
		activityIndicatorFrame.top += padding.top
		imageViewFrame.left += padding.left
		imageViewFrame.top += padding.top
		textLabelFrame.left += padding.left
		textLabelFrame.top += padding.top

		return Layout(
			activityIndicatorFrame: wantsActivityIndicator ? alignToGrid(activityIndicatorFrame) : nil,
			imageViewFrame:         (wantsImage && !wantsActivityIndicator) ? alignToGrid(imageViewFrame) : nil,
			textLabelFrame:         wantsText ? alignToGrid(textLabelFrame) : nil
		)
	}


	open override func layoutSubviews() {
		let layout = self.layout(for: bounds.size)

		var subviewIndex = subviews.count
		if let imageView = _imageView, let index = subviews.indexOfIdentical(imageView) {
			subviewIndex = min(subviewIndex, index)
		}
		if let textLabel = _textLabel, let index = subviews.indexOfIdentical(textLabel) {
			subviewIndex = min(subviewIndex, index)
		}
		if let activityIndicator = _activityIndicator, let index = subviews.indexOfIdentical(activityIndicator) {
			subviewIndex = min(subviewIndex, index)
		}

		if let imageViewFrame = layout.imageViewFrame {
			if imageView.superview == nil {
				insertSubview(imageView, at: subviewIndex)
			}
			subviewIndex += 1

			imageView.untransformedFrame = imageViewFrame
		}
		else {
			_imageView?.removeFromSuperview()
		}

		if let textLabelFrame = layout.textLabelFrame {
			if textLabel.superview == nil {
				insertSubview(textLabel, at: subviewIndex)
			}
			subviewIndex += 1

			textLabel.untransformedFrame = textLabelFrame
		}
		else {
			_textLabel?.removeFromSuperview()
		}

		if let activityIndicatorFrame = layout.activityIndicatorFrame {
			if activityIndicator.superview == nil {
				insertSubview(activityIndicator, at: subviewIndex)

				activityIndicator.startAnimating()
			}

			activityIndicator.untransformedFrame = activityIndicatorFrame
		}
		else {
			_activityIndicator?.removeFromSuperview()
		}

		if arrangement == .imageBehindText && layout.textLabelFrame != nil && (layout.imageViewFrame != nil || layout.activityIndicatorFrame != nil) {
			if layout.imageViewFrame != nil {
				insertSubview(imageView, belowSubview: textLabel)
			}
			else if layout.activityIndicatorFrame != nil {
				insertSubview(activityIndicator, belowSubview: textLabel)
			}
		}

		super.layoutSubviews()
	}


	open override func measureOptimalSize(forAvailableSize availableSize: CGSize) -> CGSize {
		let padding = self.padding
		let availableSize = availableSize.inset(by: padding)

		let wantsActivityIndicator = showsActivityIndicatorAsImage
		let wantsImage = (_imageView?.image != nil || _imageView?.source != nil)
		let wantsText = !(_textLabel?.text.isEmpty ?? true)

		// lazy initialization
		let activityIndicator: UIActivityIndicatorView? = wantsActivityIndicator ? self.activityIndicator : nil
		let imageView: ImageView? = wantsImage ? self.imageView : nil
		let textLabel: Label? = wantsText ? self.textLabel : nil

		var fittingSize = CGSize()
		var remainingSize = availableSize

		switch arrangement {
		case .imageBottom, .imageTop: // vertical
			if let imageView = imageView {
				let imageViewSize = imageView.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(imageView.transform)

				fittingSize.height += imageViewSize.height
				fittingSize.width = max(fittingSize.width, imageViewSize.width)
				remainingSize.height -= imageViewSize.height
			}
			else if let activityIndicator = activityIndicator {
				let activityIndicatorSize = activityIndicator.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(activityIndicator.transform)

				fittingSize.height += activityIndicatorSize.height
				fittingSize.width = max(fittingSize.width, activityIndicatorSize.width)
				remainingSize.height -= activityIndicatorSize.height
			}

			if let textLabel = textLabel {
				let textLabelSize = textLabel.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(textLabel.transform)

				fittingSize.height += textLabelSize.height
				fittingSize.width = max(fittingSize.width, textLabelSize.width)
			}

		case .imageLeft, .imageRight: // horizontal
			if let imageView = imageView {
				let imageViewSize = imageView.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(imageView.transform)

				fittingSize.width += imageViewSize.width
				fittingSize.height = max(fittingSize.height, imageViewSize.height)
				remainingSize.width -= imageViewSize.width
			}
			else if let activityIndicator = activityIndicator {
				let activityIndicatorSize = activityIndicator.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(activityIndicator.transform)

				fittingSize.width += activityIndicatorSize.width
				fittingSize.height = max(fittingSize.height, activityIndicatorSize.height)
				remainingSize.width -= activityIndicatorSize.width
			}

			if let textLabel = textLabel {
				let textLabelSize = textLabel.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(textLabel.transform)

				fittingSize.width += textLabelSize.width
				fittingSize.height = max(fittingSize.height, textLabelSize.height)
			}

		case .imageBehindText:
			if let imageView = imageView {
				let imageViewSize = imageView.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(imageView.transform)

				fittingSize.height = fittingSize.height.coerced(atLeast: imageViewSize.height)
				fittingSize.width = fittingSize.width.coerced(atLeast: imageViewSize.width)
			}
			else if let activityIndicator = activityIndicator {
				let activityIndicatorSize = activityIndicator.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(activityIndicator.transform)

				fittingSize.height = fittingSize.height.coerced(atLeast: activityIndicatorSize.height)
				fittingSize.width = fittingSize.width.coerced(atLeast: activityIndicatorSize.width)
			}

			if let textLabel = textLabel {
				let textLabelSize = textLabel.sizeThatFitsSize(remainingSize, allowsTruncation: true).applying(textLabel.transform)

				fittingSize.height = fittingSize.height.coerced(atLeast: textLabelSize.height)
				fittingSize.width = fittingSize.width.coerced(atLeast: textLabelSize.width)
			}
		}

		return fittingSize.inset(by: -padding)
	}


	open var padding = UIEdgeInsets.zero {
		didSet {
			guard padding != oldValue else {
				return
			}

			setNeedsLayout()
			invalidateIntrinsicContentSize()
		}
	}


	open var showsActivityIndicatorAsImage = false {
		didSet {
			guard showsActivityIndicatorAsImage != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	open override func subviewDidInvalidateIntrinsicContentSize(_ view: UIView) {
		setNeedsLayout()
		invalidateIntrinsicContentSize()
	}


	public final var textLabel: Label {
		get {
			return _textLabel ?? {
				let child = ButtonLabel(button: self)
				child.font = UIFont.preferredFont(forTextStyle: .body)
				child.textColor = .tint

				_textLabel = child

				return child
			}()
		}
	}


	fileprivate func textLabelDidChangeAttributedText() {
		setNeedsLayout()
		invalidateIntrinsicContentSize()
	}


	open var textOffset = UIOffset() {
		didSet {
			guard textOffset != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	// TODO this is hacky but tintColor is quite special anyway. We should split this up to normalTintColor, highlightedTintColor and appliedTintColor.
	open override var tintColor: UIColor? {
		get { return super.tintColor }
		set {
			guard newValue != defaultTintColor else {
				return
			}

			defaultTintColor = newValue

			updateTintColor()
		}
	}


	open override func tintColorDidChange() {
		super.tintColorDidChange()

		updateBackgroundColor()
		updateBorderColor()
	}


	open func touchIsAcceptableForTap(_ touch: UITouch, event: UIEvent?) -> Bool {
		return pointInside(touch.location(in: self), withEvent: event, additionalHitZone: additionalHitZone + UIEdgeInsets(all: touchTolerance))
	}


	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard !isUserInteractionLimitedToSubviews else {
			super.touchesBegan(touches, with: event)
			return
		}

		if let touch = touches.first, touchIsAcceptableForTap(touch, event: event) {
			highlighted = true
			highlightingTouch = touch
		}
		else {
			highlighted = false
		}
	}


	open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let highlightingTouch = highlightingTouch, touches.contains(highlightingTouch) else {
			super.touchesCancelled(touches, with: event)
			return
		}

		highlighted = false
	}


	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let highlightingTouch = highlightingTouch, touches.contains(highlightingTouch) else {
			super.touchesEnded(touches, with: event)
			return
		}

		highlighted = false

		if enabled, let tapped = tapped, let touch = touches.first, touchIsAcceptableForTap(touch, event: event) {
			tapped()
		}
	}


	open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let highlightingTouch = highlightingTouch, touches.contains(highlightingTouch) else {
			super.touchesMoved(touches, with: event)
			return
		}

		if let touch = touches.first, touchIsAcceptableForTap(touch, event: event) {
			highlighted = true
		}
		else {
			highlighted = false
		}
	}
	

	private func updateAlpha() {
		let alpha: CGFloat
		if !enabled, let disabledAlpha = disabledAlpha {
			alpha = disabledAlpha
		}
		else if highlighted, let highlightedAlpha = highlightedAlpha {
			alpha = highlightedAlpha
		}
		else {
			alpha = defaultAlpha
		}

		super.alpha = alpha
	}


	private func updateBackgroundColor() {
		let backgroundColor: UIColor?
		if !enabled, let disabledBackgroundColor = disabledBackgroundColor {
			backgroundColor = disabledBackgroundColor
		}
		else if highlighted, let highlightedBackgroundColor = highlightedBackgroundColor {
			backgroundColor = highlightedBackgroundColor
		}
		else {
			backgroundColor = defaultBackgroundColor
		}

		super.backgroundColor = backgroundColor
	}


	private func updateBorderColor() {
		let borderColor: UIColor?
		if highlighted, let highlightedBorderColor = highlightedBorderColor {
			borderColor = highlightedBorderColor
		}
		else {
			borderColor = defaultBorderColor
		}

		super.borderColor = borderColor
	}


	open func updateHighlightState() {
		updateAlpha()
		updateBackgroundColor()
		updateTintColor()
	}


	private func updateTintColor() {
		let tintColor: UIColor?
		if highlighted, let highlightedTintColor = highlightedTintColor {
			tintColor = highlightedTintColor
		}
		else {
			tintColor = defaultTintColor
		}

		super.tintColor = tintColor
	}


	open var verticalAlignment = VerticalAlignment.center {
		didSet {
			guard verticalAlignment != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}



	public enum Arrangement {

		case imageBehindText
		case imageBottom
		case imageLeft
		case imageRight
		case imageTop
	}



	public enum HorizontalAlignment {

		case center
		case fill
		case left
		case right
	}



	private struct Layout {

		var activityIndicatorFrame: CGRect?
		var imageViewFrame: CGRect?
		var textLabelFrame: CGRect?
	}



	public enum VerticalAlignment {

		case bottom
		case center
		case fill
		case top
	}
}



private class ButtonImageView: ImageView {

	private weak var button: Button?


	init(button: Button) {
		self.button = button

		super.init()
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	override var source: Source? {
		didSet {
			button?.imageViewDidChangeSource()
		}
	}
}



private class ButtonLabel: Label {

	private weak var button: Button?


	init(button: Button) {
		self.button = button

		super.init()
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	override var attributedText: NSAttributedString {
		didSet {
			guard attributedText != oldValue else {
				return
			}

			button?.textLabelDidChangeAttributedText()
		}
	}
}
