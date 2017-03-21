import UIKit


extension UIApplication {

	@objc(JetPack_statusBarHeightForOrientation:ignoringHidden:)
	private dynamic func private_statusBarHeight(for orientation: UIInterfaceOrientation, ignoringHidden: Bool) -> CGFloat {
		return statusBarFrame.height
	}


	@nonobjc
	public func statusBarHeight(for orientation: UIInterfaceOrientation) -> CGFloat {
		return private_statusBarHeight(for: orientation, ignoringHidden: true)
	}


	@nonobjc
	internal static func UIApplication_setUp() {
		redirectMethod(in: self, from: #selector(private_statusBarHeight(for:ignoringHidden:)), to: obfuscatedSelector("status", "Bar", "Height", "For", "Orientation:", "ignore", "Hidden:"))
	}
}
