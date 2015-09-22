@IBDesignable
public class Label: UILabel {

	public init() {
		super.init(frame: .zero)
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	public override func drawTextInRect(rect: CGRect) {
		super.drawTextInRect(rect.insetBy(padding))
	}


	public override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		return super.textRectForBounds(bounds.insetBy(padding), limitedToNumberOfLines: numberOfLines).insetBy(padding.inverse)
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
}
