import UIKit


@objc(JetPack_TableViewCell)
public /* non-final */ class TableViewCell: UITableViewCell {

	private var defaultContentHeight = CGFloat(0)


	public required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	internal override func contentHeightThatFitsWidth(width: CGFloat, defaultHeight: CGFloat) -> CGFloat {
		defaultContentHeight = defaultHeight
		let contentHeight = contentHeightThatFitsWidth(width)
		defaultContentHeight = 0

		return contentHeight
	}


	public func contentHeightThatFitsWidth(width: CGFloat) -> CGFloat {
		return defaultContentHeight
	}


	public var minimumHeight = CGFloat(44) {
		didSet {
			guard minimumHeight != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
		}
	}


	// You cannot reliably implement this method due to UITableViewCell's private nature. Implement contentSizeThatFitsSize(_:) instead.
	public final override func sizeThatFits(maximumSize: CGSize) -> CGSize {
		return self.sizeThatFitsSize(maximumSize)
	}


	// You cannot reliably implement this method due to UITableViewCell's private nature. Implement contentSizeThatFitsSize(_:) instead.
	public final override func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		var sizeThatFits = super.improvedSizeThatFitsSize(maximumSize)
		sizeThatFits.height = max(sizeThatFits.height, minimumHeight)
		return sizeThatFits
	}
}
