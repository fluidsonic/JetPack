import UIKit


@IBDesignable
public class Label: UILabel {

	private var originalTextColor: UIColor?


	public init() {
		super.init(frame: .zero)

		textColor = super.textColor
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		textColor = super.textColor
	}


	#if TARGET_INTERFACE_BUILDER
		public override convenience init(frame: CGRect) {
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
		get { return originalTextColor }
		set {
			guard newValue != originalTextColor else {
				return
			}

			originalTextColor = newValue

			super.textColor = newValue?.tintedWithColor(tintColor)
		}
	}


	public override func tintColorDidChange() {
		super.tintColorDidChange()

		if let originalTextColor = originalTextColor where originalTextColor.tintAlpha != nil {
			super.textColor = originalTextColor.tintedWithColor(tintColor)
		}
	}


	public override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		return super.textRectForBounds(bounds.insetBy(padding), limitedToNumberOfLines: numberOfLines).insetBy(padding.inverse)
	}
}
