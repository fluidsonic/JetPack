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


	@nonobjc
	internal static func UIWindow_setUp() {
		copyMethod(selector: #selector(layoutIfNeeded), from: UIView.self, to: self)
		swizzleMethod(in: self, from: #selector(swizzled_layoutIfNeeded), to: #selector(layoutIfNeeded))
	}
}



internal protocol _NonSystemWindow {}
