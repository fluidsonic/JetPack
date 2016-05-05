import UIKit


public extension UIPresentationController {

	@objc(JetPack_enableBlocking:)
	private dynamic func swizzled_enableBlocking(enable: Bool) {
		// workaround for https://openradar.appspot.com/22323444
		UIView.onetimeTintAdjustmentModeOverride = enable ? .Dimmed : .Automatic

		swizzled_enableBlocking(enable)
	}


	@nonobjc
	internal static func UIPresentationController_setUp() {
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("_", "enable", "Occlusion:"), toSelector: #selector(swizzled_enableBlocking(_:)))
	}
}
