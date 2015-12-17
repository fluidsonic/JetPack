import UIKit


@objc(JetPack_Label)
public class Label: UILabel {

	private var originalBackgroundColor: UIColor?
	private var originalTextColor: UIColor?


	public init() {
		super.init(frame: .zero)

		clipsToBounds = true
		backgroundColor = super.backgroundColor
		textColor = super.textColor
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		backgroundColor = super.backgroundColor
		textColor = super.textColor
	}


	public override var backgroundColor: UIColor? {
		get { return originalBackgroundColor }
		set {
			guard newValue != originalBackgroundColor else {
				return
			}

			originalBackgroundColor = newValue

			super.backgroundColor = newValue?.tintedWithColor(tintColor)
		}
	}


	public override func drawTextInRect(rect: CGRect) {
		super.drawTextInRect(rect.insetBy(padding))
	}


	public var padding = UIEdgeInsets() {
		didSet {
			guard padding != oldValue else {
				return
			}

			setNeedsDisplay()
			invalidateIntrinsicContentSize()
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

		if let originalBackgroundColor = originalBackgroundColor where originalBackgroundColor.tintAlpha != nil {
			super.backgroundColor = originalBackgroundColor.tintedWithColor(tintColor)
		}

		if let originalTextColor = originalTextColor where originalTextColor.tintAlpha != nil {
			super.textColor = originalTextColor.tintedWithColor(tintColor)
		}
	}


	public override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		return super.textRectForBounds(bounds.insetBy(padding), limitedToNumberOfLines: numberOfLines).insetBy(padding.inverse)
	}
}
