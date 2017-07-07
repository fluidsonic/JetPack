import UIKit


public extension UITextField {

	fileprivate struct AssociatedKeys {
		fileprivate static var automaticallyScrollsIntoSight = UInt8()
	}


	@nonobjc
	public var automaticallyScrollsIntoSight: Bool {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.automaticallyScrollsIntoSight) as? Bool ?? true }
		set { objc_setAssociatedObject(self, &AssociatedKeys.automaticallyScrollsIntoSight, newValue ? nil : false, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@objc(JetPack_scrollIntoSight)
	fileprivate dynamic func swizzled_scrollIntoSight() {
		if automaticallyScrollsIntoSight {
			swizzled_scrollIntoSight()
		}
	}
}


@objc(_JetPack_Extensions_UIKit_UITextField_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		// yep, private API necessary :(
		// If the private method is removed/renamed the related feature will cease to work but we won't crash.
		swizzleMethod(in: UITextField.self, from: obfuscatedSelector("scroll", "Text", "Field", "To", "Visible"), to: #selector(UITextField.swizzled_scrollIntoSight))
	}
}
