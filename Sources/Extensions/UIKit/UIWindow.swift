import UIKit


public extension UIWindow {

	@nonobjc
	internal static var isPrivate: Bool {
		let typeName = NSStringFromClass(self)
		return typeName.hasPrefix("UIRemote") || typeName.hasPrefix("UIText")
	}


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
		copyMethodWithSelector(#selector(layoutIfNeeded), fromType: UIView.self, toType: self)
		swizzleMethodInType(self, fromSelector: #selector(swizzled_layoutIfNeeded), toSelector: #selector(layoutIfNeeded))
	}
}



internal protocol _NonSystemWindow {}
