import Foundation


public extension NSObject {

	@nonobjc
	public static func overridesSelector(_ selector: Selector, ofBaseClass baseClass: NSObject.Type) -> Bool {
		return class_getMethodImplementation(self, selector) != class_getMethodImplementation(baseClass, selector)
	}
}
