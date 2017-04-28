import QuartzCore


extension CALayer {

	@nonobjc
	private(set) static var removeAllAnimationsCallsAreDisabled = false


	@objc(JetPack_layoutWithSubtreeIfNeeded)
	func layoutWithSubtreeIfNeeded() {
		swizzled_layoutWithSubtreeIfNeeded()
	}


	@nonobjc
	static func CALayer_setUp() {
		swizzleMethod(in: self, from: #selector(removeAllAnimations), to: #selector(swizzled_removeAllAnimations))

		swizzleMethod(in: self, from: obfuscatedSelector("layout", "Below", "If", "Needed"), to: #selector(swizzled_layoutWithSubtreeIfNeeded))
	}


	@objc(JetPack_swizzled_layoutWithSubtreeIfNeeded)
	private dynamic func swizzled_layoutWithSubtreeIfNeeded() {
		layoutWithSubtreeIfNeeded()
	}


	@objc(JetPack_removeAllAnimations)
	private dynamic func swizzled_removeAllAnimations() {
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
