import UIKit


@objc(JetPack_TableViewCell)
open class TableViewCell: UITableViewCell {

	fileprivate var defaultContentHeight = CGFloat(0)


	public required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	internal override func contentHeightThatFitsWidth(_ width: CGFloat, defaultHeight: CGFloat) -> CGFloat {
		defaultContentHeight = defaultHeight
		let contentHeight = contentHeightThatFitsWidth(width)
		defaultContentHeight = 0

		return contentHeight
	}


	open func contentHeightThatFitsWidth(_ width: CGFloat) -> CGFloat {
		return defaultContentHeight
	}


	open var minimumHeight = CGFloat(44) {
		didSet {
			guard minimumHeight != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
		}
	}


	// You cannot reliably implement this method due to UITableViewCell's private nature. Implement contentHeightThatFitsWidth(_:) instead.
	public final override func sizeThatFits(_ maximumSize: CGSize) -> CGSize {
		return self.sizeThatFitsSize(maximumSize)
	}


	// You cannot reliably implement this method due to UITableViewCell's private nature. Implement contentHeightThatFitsWidth(_:) instead.
	public final override func sizeThatFitsSize(_ maximumSize: CGSize) -> CGSize {
		var sizeThatFits = super.improvedSizeThatFitsSize(maximumSize)
		sizeThatFits.height = max(sizeThatFits.height, minimumHeight)
		return sizeThatFits
	}
}
