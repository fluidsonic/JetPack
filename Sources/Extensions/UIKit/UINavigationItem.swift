import UIKit


public extension UINavigationItem {

	@nonobjc
	var backButtonTitles: Set<String> {
		get { return backBarButtonItem?.possibleTitles ?? [] }
		set {
			guard newValue.isEmpty || newValue != backButtonTitles else {
				return
			}

			if let anyTitle = newValue.first {
				let item = UIBarButtonItem(title: anyTitle)
				item.possibleTitles = newValue
				backBarButtonItem = item
			}
			else {
				backBarButtonItem = nil
			}
		}
	}
}
