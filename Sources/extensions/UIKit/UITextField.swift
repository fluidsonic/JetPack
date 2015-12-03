import UIKit


public extension UITextField {

	private struct AssociatedKeys {
		private static var automaticallyScrollsIntoSight = UInt8()
	}



	@nonobjc
	public var automaticallyScrollsIntoSight: Bool {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.automaticallyScrollsIntoSight) as? Bool ?? true }
		set { objc_setAssociatedObject(self, &AssociatedKeys.automaticallyScrollsIntoSight, newValue ? nil : false, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@objc(JetPack_scrollIntoSight)
	private dynamic func swizzled_scrollIntoSight() {
		if automaticallyScrollsIntoSight {
			swizzled_scrollIntoSight()
		}
	}


	@nonobjc
	internal static func UITextField_setUp() {
		// yep, private API necessary :(
		// If the private method is removed/renamed the related feature will cease to work but we won't crash.
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("scroll", "Text", "Field", "To", "Visible"), toSelector: "JetPack_scrollIntoSight")
	}
}
