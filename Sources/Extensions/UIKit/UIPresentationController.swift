import UIKit


public extension UIPresentationController {

	@nonobjc
	private static var enableBlocking_activeCallCount = 0


	@objc(JetPack_enableBlocking:)
	private dynamic func swizzled_enableBlocking(enable: Bool) {
		UIPresentationController.enableBlocking_activeCallCount += 1
		defer { UIPresentationController.enableBlocking_activeCallCount -= 1 }

		swizzled_enableBlocking(enable)
	}


	@objc(JetPack_parent)
	private dynamic func swizzled_parent() -> UIPresentationController? {
		guard UIPresentationController.enableBlocking_activeCallCount <= 0 else {
			return nil
		}

		return swizzled_parent()
	}


	@nonobjc
	internal static func UIPresentationController_setUp() {
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("_", "enable", "Occlusion:"), toSelector: #selector(swizzled_enableBlocking(_:)))
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("_", "parent", "Presentation", "Controller"), toSelector: #selector(swizzled_parent))
	}
}
