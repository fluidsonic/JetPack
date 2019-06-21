import UIKit


@objc(JetPack_TableView)
open class TableView: UITableView {

	public init(style: UITableView.Style) {
		super.init(frame: .zero, style: style)
		
		contentInsetAdjustmentBehavior = .never
		insetsContentViewsToSafeArea = false
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	open override func touchesShouldCancel(in view: UIView) -> Bool {
		guard super.touchesShouldCancel(in: view) else {
			return false
		}

		guard let button = view as? Button else {
			return true
		}

		return button.cancelsTouchForScrollViewTracking
	}
}
