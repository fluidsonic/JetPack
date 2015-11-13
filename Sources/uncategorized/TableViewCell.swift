import UIKit


public /* non-final */ class TableViewCell: UITableViewCell {

	public required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	public func contentSizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		return maximumSize
	}


	// You cannot reliably implement this method due to UITableViewCell's private nature. Implement contentSizeThatFitsSize(_:) instead.
	public final override func sizeThatFits(maximumSize: CGSize) -> CGSize {
		let testFrame = CGRect(width: 45, height: 320) // must not be too large or else we run into a large inaccuracy
		let contentInsets = UIEdgeInsets(fromRect: testFrame, toRect: contentFrameForSize(testFrame.size))
		let maximumContentFrame = contentFrameForSize(maximumSize)
		let contentSizeThatFits = contentSizeThatFitsSize(maximumContentFrame.size)
		let sizeThatFits = contentSizeThatFits.insetBy(contentInsets.inverse)

		return sizeThatFits
	}


	// You cannot reliably implement this method due to UITableViewCell's private nature. Implement contentSizeThatFitsSize(_:) instead.
	public final override func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		return sizeThatFits(maximumSize)
	}
}
