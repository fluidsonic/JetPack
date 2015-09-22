@IBDesignable
public class Label: UILabel {

	private var defaultTextColor: UIColor?


	public init() {
		super.init(frame: .zero)

		defaultTextColor = textColor
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		defaultTextColor = textColor
	}


	#if TARGET_INTERFACE_BUILDER
		public required override convenience init(frame: CGRect) {
			self.init()

			self.frame = frame
		}
	#endif


	public override func drawTextInRect(rect: CGRect) {
		super.drawTextInRect(rect.insetBy(padding))
	}


	@IBInspectable
	public var padding: UIEdgeInsets = .zero {
		didSet {
			guard padding != oldValue else {
				return
			}

			setNeedsDisplay()
		}
	}


	public override var textColor: UIColor? {
		get { return defaultTextColor }
		set {
			guard newValue != defaultTextColor else {
				return
			}

			defaultTextColor = newValue

			updateTextColor()
		}
	}


	@IBInspectable
	public var textTintColorAlpha: CGFloat = 0 {
		didSet {
			textTintColorAlpha = textTintColorAlpha.clamp(min: 0, max: 1)

			guard textTintColorAlpha != oldValue else {
				return
			}

			updateTextColor()
		}
	}


	public override func tintColorDidChange() {
		super.tintColorDidChange()

		updateTextColor()
	}


	public override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		return super.textRectForBounds(bounds.insetBy(padding), limitedToNumberOfLines: numberOfLines).insetBy(padding.inverse)
	}


	private func updateTextColor() {
		let textColor: UIColor?
		if textTintColorAlpha > 0 {
			textColor = tintColor.colorWithAlphaComponent(textTintColorAlpha)
		}
		else {
			textColor = defaultTextColor
		}

		super.textColor = textColor
	}
}
