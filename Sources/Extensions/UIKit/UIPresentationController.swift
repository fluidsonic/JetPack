import UIKit


public extension UIPresentationController {

	@nonobjc
	fileprivate static var enableBlocking_activeCallCount = 0


	@objc(JetPack_enableBlocking:)
	fileprivate dynamic func swizzled_enableBlocking(_ enable: Bool) {
		UIPresentationController.enableBlocking_activeCallCount += 1
		defer { UIPresentationController.enableBlocking_activeCallCount -= 1 }

		swizzled_enableBlocking(enable)
	}


	@objc(JetPack_parent)
	fileprivate dynamic func swizzled_parent() -> UIPresentationController? {
		// workaround for tintColor not working correctly in modally presented view controllers

		guard UIPresentationController.enableBlocking_activeCallCount <= 0 else {
			return nil
		}

		return swizzled_parent()
	}
}


@objc(_JetPack_Extensions_UIKit_UIPresentationController_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		swizzleMethod(in: UIPresentationController.self, from: obfuscatedSelector("_", "enable", "Occlusion:"), to: #selector(UIPresentationController.swizzled_enableBlocking(_:)))
		swizzleMethod(in: UIPresentationController.self, from: obfuscatedSelector("_", "parent", "Presentation", "Controller"), to: #selector(UIPresentationController.swizzled_parent))
	}
}
