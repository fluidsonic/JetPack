import UIKit


public extension UIWindow {

	@nonobjc
	internal static var isPrivate: Bool {
		let typeName = NSStringFromClass(self)
		return typeName.hasPrefix("UIRemote") || typeName.hasPrefix("UIText")
	}


	@objc(JetPack_layoutIfNeeded)
	fileprivate dynamic func swizzled_layoutIfNeeded() {
		guard UINavigationBar.isSettingPromptCount <= 0 else {
			// work around http://stackoverflow.com/questions/22115821/uinavigationitem-prompt-issue
			return
		}

		swizzled_layoutIfNeeded()
	}
}



internal protocol _NonSystemWindow {}


@objc(_JetPack_Extensions_UIKit_UIWindow_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		copyMethod(selector: #selector(UIWindow.layoutIfNeeded), from: UIView.self, to: UIWindow.self)
		swizzleMethod(in: UIWindow.self, from: #selector(UIWindow.swizzled_layoutIfNeeded), to: #selector(UIWindow.layoutIfNeeded))
	}
}
