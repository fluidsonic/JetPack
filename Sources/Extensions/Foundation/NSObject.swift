import Foundation


public extension NSObject {

	@nonobjc
	static func overridesSelector(_ selector: Selector, ofBaseClass baseClass: NSObject.Type) -> Bool {
		return class_getMethodImplementation(self, selector) != class_getMethodImplementation(baseClass, selector)
	}
}
