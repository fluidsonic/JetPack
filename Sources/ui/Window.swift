import UIKit


@IBDesignable
public /* non-final */ class Window: UIWindow {

	public convenience init() {
		self.init(frame: .zero)
	}


	public override init(frame: CGRect) {
		super.init(frame: frame)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	public override var rootViewController: UIViewController? {
		get { return super.rootViewController }
		set {
			// Due to a bug in iOS 8 changing the rootViewController doesn't remove modally presented view controllers.

			super.rootViewController = nil
			removeAllSubviews()
			super.rootViewController = newValue
		}
	}
}
