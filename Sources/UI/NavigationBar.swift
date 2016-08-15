import UIKit


private let backgroundViewKey = ["_", "backgroundView"].joinWithSeparator("")
private let navigationItemViewClassName = ["UINavigationItem", "View"].joinWithSeparator("")
private let titleViewKey = ["_", "titleView"].joinWithSeparator("")


@objc(JetPack_NavigationBar)
public /* non-final */ class NavigationBar: UINavigationBar {

	private var originalAlpha = CGFloat(1)
	private var originalTintColor: UIColor? = nil


	public convenience init() {
		self.init(frame: .zero)
	}


	public required override init(frame: CGRect) {
		super.init(frame: frame)

		originalAlpha = alpha
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		originalAlpha = alpha
	}


	public override var alpha: CGFloat {
		get { return originalAlpha }
		set {
			guard newValue != originalAlpha else {
				return
			}

			originalAlpha = newValue

			updateAlpha()
		}
	}


	public final var backgroundView: UIView? {
		return valueForKey(backgroundViewKey) as? UIView
	}


	public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		guard visibility != .Invisible else {
			return nil
		}

		return super.hitTest(point, withEvent: event)
	}


	private func isTitleView(view: UIView, checkingSubviews: Bool = true) -> Bool {
		return view === titleView || NSStringFromClass(view.dynamicType) == navigationItemViewClassName
	}


	internal var overridingTintColor: UIColor? {
		didSet {
			guard overridingTintColor != oldValue else {
				return
			}

			updateTintColor()
		}
	}


	public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
		guard visibility != .Invisible else {
			return false
		}

		return super.pointInside(point, withEvent: event)
	}


	internal override func popNavigationItemWithTransition(transition: Int32) -> UINavigationItem {
		let item = super.popNavigationItemWithTransition(transition)

		if let navigationController = delegate as? NavigationController {
			navigationController.updateNavigationBarStyleForTopViewController()
		}

		return item
	}


	internal override func pushNavigationItem(item: UINavigationItem, transition: Int32) {
		super.pushNavigationItem(item, transition: transition)

		if let navigationController = delegate as? NavigationController {
			navigationController.updateNavigationBarStyleForTopViewController()
		}
	}


	internal override func setItems(items: NSArray, transition: Int32, reset: Bool, resetOwningRelationship: Bool) {
		super.setItems(items, transition: transition, reset: reset, resetOwningRelationship: resetOwningRelationship)

		if let navigationController = delegate as? NavigationController {
			navigationController.updateNavigationBarStyleForTopViewController()
		}
	}


	public override var tintColor: UIColor! {
		get { return super.tintColor }
		set {
			originalTintColor = newValue

			updateTintColor()
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

		// TODO find another way to hide the titleView since this approach messes up the navigation hierarchy when using back-swipe gesture
		/*
		if let titleView = titleView {
			switch visibility {
			case .Hidden, .Invisible, .InvisibleBackground, .Visible:
				titleView.alpha = 1

			case .InvisibleBackgroundAndTitle:
				titleView.alpha = 0
			}
		}
		*/

		updateAlpha()
	}


	private func updateAlpha() {
		super.alpha = (visibility == .Invisible ? 0 : originalAlpha)
	}


	private func updateTintColor() {
		super.tintColor = overridingTintColor ?? originalTintColor
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
