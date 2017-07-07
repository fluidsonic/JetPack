import UIKit


extension UIApplication {

	@objc(JetPack_statusBarHeightForOrientation:ignoringHidden:)
	fileprivate dynamic func private_statusBarHeight(for orientation: UIInterfaceOrientation, ignoringHidden: Bool) -> CGFloat {
		return statusBarFrame.height
	}


	@nonobjc
	public func statusBarHeight(for orientation: UIInterfaceOrientation) -> CGFloat {
		return private_statusBarHeight(for: orientation, ignoringHidden: true)
	}
}


@objc(_JetPack_Extensions_UIKit_UIApplication_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		redirectMethod(in: UIApplication.self, from: #selector(UIApplication.private_statusBarHeight(for:ignoringHidden:)), to: obfuscatedSelector("status", "Bar", "Height", "For", "Orientation:", "ignore", "Hidden:"))
	}
}
