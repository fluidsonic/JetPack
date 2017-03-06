import UIKit


@objc(JetPack_Label)
open class Label: View {

	private lazy var delegateProxy: DelegateProxy = DelegateProxy(label: self)

	private let linkTapRecognizer = UITapGestureRecognizer()
	private let textLayer = TextLayer()

	open var linkTapped: ((URL) -> Void)?


	public override init() {
		super.init()

		clipsToBounds = false

		layer.addSublayer(textLayer)

		setUpLinkTapRecognizer()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	internal var additionalLinkHitZone = UIEdgeInsets(all: 8) // TODO don't use UIEdgeInsets because actually we outset


	open var attributedText: NSAttributedString {
		get { return textLayer.attributedText }
		set {
			guard newValue != textLayer.attributedText else {
				return
			}

			textLayer.attributedText = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open override func didMoveToWindow() {
		super.didMoveToWindow()

		if let window = window {
			textLayer.contentsScale = window.screen.scale
		}
	}


	open var font: UIFont {
		get { return textLayer.font }
		set {
			guard newValue != textLayer.font else {
				return
			}

			textLayer.font = newValue

			invalidateIntrinsicContentSize()
		}
	}


	@objc
	private func handleLinkTapRecognizer() {
		// FIXME 
		/*
		guard let link = link(at: linkTapRecognizer.location(in: self)) else {
			return
		}

		linkTapped?(link)*/
	}


	open var horizontalAlignment: TextAlignment.Horizontal {
		get { return textLayer.horizontalAlignment }
		set {
			guard newValue != textLayer.horizontalAlignment else {
				return
			}

			textLayer.horizontalAlignment = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open var kerning: TextKerning? {
		get { return textLayer.kerning }
		set {
			guard newValue != textLayer.kerning else {
				return
			}

			textLayer.kerning = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open override func layoutSubviews() {
		super.layoutSubviews()

		let bounds = self.bounds
		guard bounds.size.isPositive else {
			return
		}

		var textLayerFrame = CGRect(size: bounds.size)
		textLayer.textSize = textLayerFrame.size

		textLayerFrame.insetInPlace(textLayer.drawingOverflow)
		textLayer.frame = alignToGrid(textLayerFrame)
	}


	open var lineBreakMode: NSLineBreakMode {
		get { return textLayer.lineBreakMode }
		set {
			guard newValue != textLayer.lineBreakMode else {
				return
			}

			textLayer.lineBreakMode = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open var lineHeightMultiple: CGFloat {
		get { return textLayer.lineHeightMultiple }
		set {
			guard newValue != textLayer.lineHeightMultiple else {
				return
			}

			textLayer.lineHeightMultiple = newValue

			invalidateIntrinsicContentSize()
		}
	}

	// FIXME
/*
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

	public func link(at point: CGPoint) -> URL? {
		return textLayer.link(at: layer.convert(point, to: textLayer))?.url
	}
*/

	open var maximumNumberOfLines: Int? {
		get { return textLayer.maximumNumberOfLines }
		set {
			guard newValue != textLayer.maximumNumberOfLines else {
				return
			}

			textLayer.maximumNumberOfLines = newValue

			invalidateIntrinsicContentSize()
		}
	}

	// FIXME
/*
	open var minimumScaleFactor: CGFloat {
		get { return textLayer.minimumScaleFactor }
		set {
			let newValue = newValue.coerced(in: 0 ... 1)
			guard newValue != textLayer.minimumScaleFactor else {
				return
			}

			textLayer.minimumScaleFactor = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open var numberOfLines: Int {
		return textLayer.numberOfLines
	}


	open var padding: UIEdgeInsets {
		get { return textLayer.padding }
		set {
			guard newValue != textLayer.padding else {
				return
			}

			textLayer.padding = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open override func pointInside(_ point: CGPoint, withEvent event: UIEvent?, additionalHitZone: UIEdgeInsets) -> Bool {
		guard super.pointInside(point, withEvent: event, additionalHitZone: additionalHitZone) else {
			return false
		}
		guard userInteractionLimitedToLinks else {
			return true
		}

		return link(at: point) != nil
	}*/


	private func setUpLinkTapRecognizer() {
		let recognizer = linkTapRecognizer
		recognizer.delegate = delegateProxy
		recognizer.isEnabled = false
		recognizer.addTarget(self, action: #selector(handleLinkTapRecognizer))

		addGestureRecognizer(recognizer)
	}


	open override func sizeThatFitsSize(_ maximumSize: CGSize) -> CGSize {
		return alignToGrid(textLayer.textSize(thatFits: maximumSize))
	}


	open var text: String {
		get { return attributedText.string }
		set { attributedText = NSAttributedString(string: newValue) }
	}


	open var textColor: UIColor {
		get { return textLayer.textColor }
		set { textLayer.textColor = newValue }
	}


	open var textTransform: TextTransform? {
		get { return textLayer.textTransform }
		set {
			guard newValue != textLayer.textTransform else {
				return
			}

			textLayer.textTransform = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open override func tintColorDidChange() {
		super.tintColorDidChange()

		textLayer.tintColor = tintColor
	}


	open var userInteractionLimitedToLinks = true

	// FIXME
/*
	open var verticalAlignment: TextAlignment.Vertical {
		get { return textLayer.verticalAlignment }
		set { textLayer.verticalAlignment = newValue }
	}
*/


	private final class DelegateProxy: NSObject, UIGestureRecognizerDelegate {

		private unowned var label: Label


		init(label: Label) {
			self.label = label
		}


		@objc
		fileprivate func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
			return false // FIXME return label.link(at: touch.location(in: label)) != nil
		}
	}
}
