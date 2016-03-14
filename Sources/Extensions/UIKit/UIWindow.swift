import UIKit


public extension UIWindow {

	@objc(JetPack_layoutIfNeeded)
	private dynamic func swizzled_layoutIfNeeded() {
		guard UINavigationBar.isSettingPromptCount <= 0 else {
			// work around http://stackoverflow.com/questions/22115821/uinavigationitem-prompt-issue
			return
		}

		swizzled_layoutIfNeeded()
	}


	@nonobjc
	internal static func UIWindow_setUp() {
		copyMethodWithSelector("layoutIfNeeded", fromType: UIView.self, toType: self)
		swizzleMethodInType(self, fromSelector: "JetPack_layoutIfNeeded", toSelector: "layoutIfNeeded")
	}
}



internal protocol _NonSystemWindow {}
