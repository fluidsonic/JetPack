import UIKit


private let backgroundViewKey = ["_", "backgroundView"].joined(separator: "")
private let navigationItemViewClassName = ["UINavigationItem", "View"].joined(separator: "")
private let titleViewKey = ["_", "titleView"].joined(separator: "")


@objc(JetPack_NavigationBar)
open class NavigationBar: UINavigationBar {

	fileprivate var ignoresItemChanges = 0
	fileprivate var originalAlpha = CGFloat(1)
	fileprivate var originalTintColor: UIColor? = nil


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


	open override var alpha: CGFloat {
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
		return value(forKey: backgroundViewKey) as? UIView
	}


	internal func beginIgnoringItemChanges() {
		ignoresItemChanges += 1
	}


	internal func endIgnoringItemChanges() {
		ignoresItemChanges = max(ignoresItemChanges - 1, 0)
	}


	open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		guard visibility != .invisible else {
			return nil
		}

		return super.hitTest(point, with: event)
	}


	fileprivate func isTitleView(_ view: UIView, checkingSubviews: Bool = true) -> Bool {
		return view === titleView || NSStringFromClass(type(of: view)) == navigationItemViewClassName
	}


	internal var overridingTintColor: UIColor? {
		didSet {
			guard overridingTintColor != oldValue else {
				return
			}

			updateTintColor()
		}
	}


	open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		guard visibility != .invisible else {
			return false
		}

		return super.point(inside: point, with: event)
	}


	internal override func popNavigationItemWithTransition(_ transition: Int32) -> UINavigationItem {
		let item = super.popNavigationItemWithTransition(transition)

		if ignoresItemChanges == 0, let navigationController = delegate as? NavigationController {
			navigationController.updateNavigationBarStyleForTopViewController()
		}

		return item
	}


	internal override func pushNavigationItem(_ item: UINavigationItem, transition: Int32) {
		super.pushNavigationItem(item, transition: transition)

		if ignoresItemChanges == 0, let navigationController = delegate as? NavigationController {
			navigationController.updateNavigationBarStyleForTopViewController()
		}
	}


	internal override func setItems(_ items: NSArray, transition: Int32, reset: Bool, resetOwningRelationship: Bool) {
		super.setItems(items, transition: transition, reset: reset, resetOwningRelationship: resetOwningRelationship)

		if ignoresItemChanges == 0, let navigationController = delegate as? NavigationController {
			navigationController.updateNavigationBarStyleForTopViewController()
		}
	}


	open override var tintColor: UIColor! {
		get { return super.tintColor }
		set {
			originalTintColor = newValue

			updateTintColor()
		}
	}


	public final var titleView: UIView? {
		return value(forKey: titleViewKey) as? UIView
	}


	public internal(set) final var visibility = Visibility.visible {
		didSet {
			guard visibility != oldValue else {
				return
			}

			visibilityDidChange()
		}
	}


	open func visibilityDidChange() {
		if let backgroundView = backgroundView {
			switch visibility {
			case .hidden, .invisible, .visible:
				backgroundView.alpha = 1

			case .invisibleBackground, .invisibleBackgroundAndTitle:
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


	fileprivate func updateAlpha() {
		super.alpha = (visibility == .invisible ? 0 : originalAlpha)
	}


	fileprivate func updateTintColor() {
		super.tintColor = overridingTintColor ?? originalTintColor
	}



	@objc
	public enum Visibility: Int {
		case visible
		case invisible
		case invisibleBackground
		case invisibleBackgroundAndTitle
		case hidden


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
