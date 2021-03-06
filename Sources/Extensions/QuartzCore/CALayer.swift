import QuartzCore


extension CALayer {

	@nonobjc
	private(set) static var removeAllAnimationsCallsAreDisabled = false


	@objc(JetPack_layoutWithSubtreeIfNeeded)
	func layoutWithSubtreeIfNeeded() {
		swizzled_layoutWithSubtreeIfNeeded()
	}


	@objc(JetPack_swizzled_layoutWithSubtreeIfNeeded)
	fileprivate dynamic func swizzled_layoutWithSubtreeIfNeeded() {
		layoutWithSubtreeIfNeeded()
	}


	@objc(JetPack_removeAllAnimations)
	fileprivate dynamic func swizzled_removeAllAnimations() {
		guard !CALayer.removeAllAnimationsCallsAreDisabled else {
			return
		}

		swizzled_removeAllAnimations()
	}


	@nonobjc
	static func withRemoveAllAnimationsDisabled(block: Closure) {
		if removeAllAnimationsCallsAreDisabled {
			block()
		}
		else {
			removeAllAnimationsCallsAreDisabled = true
			block()
			removeAllAnimationsCallsAreDisabled = false
		}
	}
}


@objc(_JetPack_Extensions_QuartzCore_CALayer_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		swizzleMethod(in: CALayer.self, from: #selector(CALayer.removeAllAnimations), to: #selector(CALayer.swizzled_removeAllAnimations))

		swizzleMethod(in: CALayer.self, from: obfuscatedSelector("layout", "Below", "If", "Needed"), to: #selector(CALayer.swizzled_layoutWithSubtreeIfNeeded))
	}
}
