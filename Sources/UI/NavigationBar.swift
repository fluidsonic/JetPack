import UIKit


private let backgroundViewKey = ["_", "backgroundView"].joinWithSeparator("")
private let titleViewKey = ["_", "titleView"].joinWithSeparator("")


@objc(JetPack_NavigationBar)
public /* non-final */ class NavigationBar: UINavigationBar {

	public convenience init() {
		self.init(frame: .zero)
	}


	public required override init(frame: CGRect) {
		super.init(frame: frame)
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	public final var backgroundView: UIView? {
		return valueForKey(backgroundViewKey) as? UIView
	}


	internal override func popNavigationItemWithTransition(transition: Int32) -> UINavigationItem {
		let item = super.popNavigationItemWithTransition(transition)

		if let navigationController = delegate as? NavigationController {
			navigationController.updateNavigationBarVisibilityOfTopViewController()
		}

		return item
	}


	internal override func pushNavigationItem(item: UINavigationItem, transition: Int32) {
		super.pushNavigationItem(item, transition: transition)

		if let navigationController = delegate as? NavigationController {
			navigationController.updateNavigationBarVisibilityOfTopViewController()
		}
	}


	public final var titleView: UIView? {
		return valueForKey(titleViewKey) as? UIView
	}


	public internal(set) final var visibility = Visibility.Visible {
		didSet {
			guard visibility != oldValue else {
				return
			}

			visibilityDidChange()
		}
	}


	public func visibilityDidChange() {
		if let backgroundView = backgroundView {
			switch visibility {
			case .Hidden, .Invisible, .Visible:
				backgroundView.alpha = 1

			case .InvisibleBackground, .InvisibleBackgroundAndTitle:
				backgroundView.alpha = 0
			}
		}

		if let titleView = titleView {
			switch visibility {
			case .Hidden, .Invisible, .InvisibleBackground, .Visible:
				titleView.alpha = 1

			case .InvisibleBackgroundAndTitle:
				titleView.alpha = 0
			}
		}
	}



	@objc
	public enum Visibility: Int {
		case Visible
		case Invisible
		case InvisibleBackground
		case InvisibleBackgroundAndTitle
		case Hidden


		public func wrapped() -> Wrapper {
			return Wrapper(value: self)
		}



		public final class Wrapper: NSObject {

			public let value: Visibility


			public init(value: Visibility) {
				self.value = value
			}
		}
	}
}
