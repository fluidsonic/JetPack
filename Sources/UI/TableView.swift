import UIKit


@objc(JetPack_TableView)
open class TableView: UITableView {

	public init(style: UITableView.Style) {
		super.init(frame: .zero, style: style)

		if #available(iOS 11.0, *) {
			contentInsetAdjustmentBehavior = .never
			insetsContentViewsToSafeArea = false
		}
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
