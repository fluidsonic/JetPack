import UIKit


internal class TextLayer: Layer {

	private var configuration = Configuration()
	private var textLayout: TextLayout?


	internal override init() {
		super.init()

		backgroundColor = UIColor.red.withAlphaComponent(0.25).cgColor // FIXME
		isOpaque = false
		textColor = UIColor.darkText.cgColor
		tintColor = UIColor.red.cgColor
	}


	internal required init(layer: Any) {
		let layer = layer as! TextLayer
		additionalLinkHitZone = layer.additionalLinkHitZone
		configuration = layer.configuration
		textLayout = layer.textLayout

		_links = layer._links

		super.init(layer: layer)
	}


	internal required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	internal override func action(forKey key: String) -> CAAction? {
		switch key {
		case "textColor", "tintColor":
			if let animation = UIView.defaultActionForLayer(self, forKey: "backgroundColor") as? CABasicAnimation {
				animation.fromValue = value(forKey: key)
				animation.keyPath = key

				return animation
			}

			fallthrough

		default:
			return super.action(forKey: key)
		}
	}


	internal var additionalLinkHitZone = UIEdgeInsets(all: 8) // TODO don't use UIEdgeInsets because we outset


	internal var attributedText: NSAttributedString {
		get { return configuration.text }
		set {
			configuration.text = newValue
			checkConfiguration()
		}
	}


	private func buildTextLayout(maximumSize: CGSize) -> TextLayout {
		return TextLayout.build(
			text:                 configuration.finalText,
			lineBreakMode:        configuration.lineBreakMode,
			maximumNumberOfLines: configuration.maximumNumberOfLines,
			maximumSize:          maximumSize,
			minimumScaleFactor:   configuration.minimumScaleFactor,
			renderingScale:       contentsScale
		)
	}


	private func checkConfiguration() {
		if configuration.needsRebuildFinalText {
			invalidateTextLayout()
		}
	}


	internal var contentInsets: UIEdgeInsets {
		return ensureTextLayout()?.contentInsets ?? .zero
	}


	private func convertPoint(point: CGPoint, fromTextLayout textLayout: TextLayout) -> CGPoint {
		let contentInsets = textLayout.contentInsets

		var pointFromTextLayout = point
		pointFromTextLayout.left -= contentInsets.left
		pointFromTextLayout.top -= contentInsets.top

		return pointFromTextLayout
	}


	private func convertPoint(point: CGPoint, toTextLayout textLayout: TextLayout) -> CGPoint {
		let contentInsets = textLayout.contentInsets

		var pointInTextLayout = point
		pointInTextLayout.left += contentInsets.left
		pointInTextLayout.top += contentInsets.top

		return pointInTextLayout
	}


	private func convertRect(rect: CGRect, fromTextLayout textLayout: TextLayout) -> CGRect {
		var rectFromTextLayout = rect
		rectFromTextLayout.origin = convertPoint(point: rectFromTextLayout.origin, fromTextLayout: textLayout)

		return rectFromTextLayout
	}


	private func convertRect(rect: CGRect, toTextLayout textLayout: TextLayout) -> CGRect {
		var rectFromTextLayout = rect
		rectFromTextLayout.origin = convertPoint(point: rectFromTextLayout.origin, toTextLayout: textLayout)

		return rectFromTextLayout
	}


	internal override func draw(in context: CGContext) {
		super.draw(in: context)

		ensureTextLayout()?.draw(in: context, defaultTextColor: UIColor(cgColor: textColor), tintColor: UIColor(cgColor: tintColor))
	}


	private func ensureTextLayout() -> TextLayout? {
		if let textLayout = self.textLayout {
			return textLayout
		}

		guard textSize.isPositive else {
			return nil
		}

		let textLayout = buildTextLayout(maximumSize: textSize)
		self.textLayout = textLayout
		return textLayout
	}


	internal var font: UIFont {
		get { return configuration.font }
		set {
			configuration.font = newValue
			checkConfiguration()
		}
	}


	internal var horizontalAlignment: TextAlignment.Horizontal {
		get { return configuration.horizontalAlignment }
		set {
			configuration.horizontalAlignment = newValue
			checkConfiguration()
		}
	}


	internal var kerning: TextKerning? {
		get { return configuration.kerning }
		set {
			configuration.kerning = newValue
			checkConfiguration()
		}
	}


	private func invalidateTextLayout() {
		_links = nil
		textLayout = nil

		setNeedsDisplay()
	}


	internal var lineBreakMode: NSLineBreakMode {
		get { return configuration.lineBreakMode }
		set {
			configuration.lineBreakMode = newValue
			checkConfiguration()
		}
	}


	internal var lineHeightMultiple: CGFloat {
		get { return configuration.lineHeightMultiple }
		set {
			configuration.lineHeightMultiple = newValue
			checkConfiguration()
		}
	}


	internal func link(at point: CGPoint) -> Link? {
		let additionalLinkHitZone = self.additionalLinkHitZone

		var bestLink: Link?
		var bestLinkDistance = CGFloat.infinity

		for link in links {
			for frame in link.frames {
				let hitTestFrame = frame.insetBy(additionalLinkHitZone.inverse)
				guard hitTestFrame.contains(point) else {
					continue
				}

				// distance starts negative from inside the frame and increases the farther the point lies outside
				let distance = frame.distance(to: point) * (frame.contains(point) ? -1 : 1)
				guard distance < bestLinkDistance else {
					continue
				}

				bestLink = link
				bestLinkDistance = distance
			}
		}

		return bestLink
	}


	private var _links: [Link]?
	internal var links: [Link] {
		if let links = _links {
			return links
		}
		guard let textLayout = ensureTextLayout() else {
			return []
		}

		let text = textLayout.configuration.text

		var links = [Link]()
		text.enumerateAttribute(NSLinkAttributeName, in: NSRange(location: 0, length: text.length), options: []) { url, range, _ in
			guard let url = url as? URL else {
				return
			}

			links.append(Link(range: range, frames: [], url: url))
		}

		links = links.map { link in
			var frames = [CGRect]()
			textLayout.enumerateEnclosingRects(forCharacterRange: link.range) { enclosingRect in
				frames.append(convertRect(rect: enclosingRect, fromTextLayout: textLayout))
			}

			return Link(range: link.range, frames: frames, url: link.url)
		}
		
		_links = links
		return links
	}


	internal var maximumNumberOfLines: Int? {
		get { return configuration.maximumNumberOfLines }
		set {
			guard newValue != configuration.maximumNumberOfLines else {
				return
			}

			configuration.maximumNumberOfLines = newValue
			invalidateTextLayout()
		}
	}


	internal var minimumScaleFactor: CGFloat {
		get { return configuration.minimumScaleFactor }
		set {
			guard newValue != configuration.minimumScaleFactor else {
				return
			}

			configuration.minimumScaleFactor = newValue
			invalidateTextLayout()
		}
	}


	internal override class func needsDisplay(forKey key: String) -> Bool {
		switch key {
		case "textColor": return true
		case "tintColor": return true // TODO causes unnecessary redraws if label doesn't use .tintColor() - how to optimize?
		default:          return super.needsDisplay(forKey: key)
		}
	}


	internal var numberOfLines: Int {
		return ensureTextLayout()?.numberOfLines ?? 0
	}


	internal func textSize(thatFits maximumSize: CGSize) -> CGSize {
		precondition(maximumSize.isPositive)

		return buildTextLayout(maximumSize: maximumSize).size
	}


	internal var text: String {
		get { return attributedText.string }
		set { attributedText = NSAttributedString(string: newValue) }
	}


	internal var textSize = CGSize.zero {
		didSet {
			guard textSize != oldValue else {
				return
			}

			invalidateTextLayout()
		}
	}


	@objc @NSManaged
	internal dynamic var textColor: CGColor


	internal var textTransform: TextTransform? {
		get { return configuration.textTransform }
		set {
			configuration.textTransform = newValue
			checkConfiguration()
		}
	}


	@objc @NSManaged
	internal dynamic var tintColor: CGColor


	internal override func willResizeToSize(_ newSize: CGSize) {
		super.willResizeToSize(newSize)

		invalidateTextLayout()
	}



	private struct Configuration {

		private var _finalText: NSAttributedString?


		var finalText: NSAttributedString {
			mutating get {
				if let finalText = _finalText {
					return finalText
				}

				let paragraphStyle = NSMutableParagraphStyle()
				paragraphStyle.alignment = horizontalAlignment
				paragraphStyle.lineHeightMultiple = lineHeightMultiple

				switch lineBreakMode {
				case .byClipping, .byTruncatingHead, .byTruncatingMiddle, .byTruncatingTail:
					// clipping and truncation must only be set on the layout manager
					paragraphStyle.lineBreakMode = .byWordWrapping

				case .byCharWrapping, .byWordWrapping:
					paragraphStyle.lineBreakMode = lineBreakMode
				}

				let finalText = text.withDefaultAttributes(
					font:            font,
					kerning:         kerning,
					paragraphStyle:  paragraphStyle,
					transform:       textTransform
				)

				_finalText = finalText
				return finalText
			}
		}


		var font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body) {
			didSet {
				if font != oldValue {
					_finalText = nil
				}
			}
		}


		var horizontalAlignment = TextAlignment.Horizontal.natural {
			didSet {
				if horizontalAlignment != oldValue {
					_finalText = nil
				}
			}
		}


		var kerning: TextKerning? {
			didSet {
				if kerning != oldValue {
					_finalText = nil
				}
			}
		}


		var lineBreakMode = NSLineBreakMode.byTruncatingTail {
			didSet {
				if lineBreakMode != oldValue {
					_finalText = nil
				}
			}
		}


		var lineHeightMultiple = CGFloat(1) {
			didSet {
				precondition(lineHeightMultiple > 0, ".lineHeightMultiple must be > 0")

				if lineHeightMultiple != oldValue {
					_finalText = nil
				}
			}
		}


		var maximumNumberOfLines: Int? = 1 {
			didSet {
				if let maximumNumberOfLines = maximumNumberOfLines {
					precondition(maximumNumberOfLines > 0, ".maximumNumberOfLines must be > 0")
				}
			}
		}


		var minimumScaleFactor = CGFloat(1) {
			didSet {
				precondition((0 ... 1).contains(minimumScaleFactor), ".minimumScaleFactor must in 0 ... 1")
			}
		}


		var needsRebuildFinalText: Bool {
			return _finalText == nil
		}


		var text = NSAttributedString() {
			didSet {
				if text != oldValue {
					_finalText = nil
				}
			}
		}


		var textTransform: TextTransform? {
			didSet {
				if textTransform != oldValue {
					_finalText = nil
				}
			}
		}
	}



	internal struct Link {

		internal var range: NSRange
		internal var frames: [CGRect]
		internal var url: URL
	}
}
