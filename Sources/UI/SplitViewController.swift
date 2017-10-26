import UIKit


open class SplitViewController: UISplitViewController {

	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		// iOS 11's UISplitViewController.viewDidLayoutSubview doesn't call super's implementation anymore
		if isInLayout {
			self.default_viewDidLayoutSubviews()
		}
	}
}
