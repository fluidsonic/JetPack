import UIKit


public class Window: UIWindow {

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
