import QuartzCore


extension CALayer {

	@nonobjc
	internal private(set) static var removeAllAnimationsCallsAreDisabled = false


	@nonobjc
	internal static func CALayer_setUp() {
		swizzleMethod(in: self, from: #selector(removeAllAnimations), to: #selector(swizzled_removeAllAnimations))
	}


	@objc(JetPack_removeAllAnimations)
	private dynamic func swizzled_removeAllAnimations() {
		guard !CALayer.removeAllAnimationsCallsAreDisabled else {
			return
		}

		swizzled_removeAllAnimations()
	}


	@nonobjc
	internal static func withRemoveAllAnimationsDisabled(block: Closure) {
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
