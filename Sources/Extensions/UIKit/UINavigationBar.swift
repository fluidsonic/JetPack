import UIKit


public extension UINavigationBar {

	@nonobjc
	internal fileprivate(set) static var isSettingPromptCount = 0


	@objc(JetPack_popNavigationItemWithTransition:)
	internal func popNavigationItemWithTransition(_ transition: Int32) -> UINavigationItem {
		return swizzled_popNavigationItemWithTransition(transition)
	}


	@objc(JetPack_pushNavigationItem:transition:)
	internal func pushNavigationItem(_ item: UINavigationItem, transition: Int32) {
		swizzled_pushNavigationItem(item, transition: transition)
	}


	@objc(JetPack_setItems:transition:reset:resetOwningRelationship:)
	internal func setItems(_ items: NSArray, transition: Int32, reset: Bool, resetOwningRelationship: Bool) {
		swizzled_setItems(items, transition: transition, reset: reset, resetOwningRelationship: resetOwningRelationship)
	}


	@objc(JetPack_swizzled_popNavigationItemWithTransition:)
	fileprivate dynamic func swizzled_popNavigationItemWithTransition(_ transition: Int32) -> UINavigationItem {
		return popNavigationItemWithTransition(transition)
	}


	@objc(JetPack_swizzled_pushNavigationItem:transition:)
	fileprivate dynamic func swizzled_pushNavigationItem(_ item: UINavigationItem, transition: Int32) {
		pushNavigationItem(item, transition: transition)
	}


	@objc(JetPack_swizzled_setItems:transition:reset:resetOwningRelationship:)
	fileprivate dynamic func swizzled_setItems(_ items: NSArray, transition: Int32, reset: Bool, resetOwningRelationship: Bool) {
		setItems(items, transition: transition, reset: reset, resetOwningRelationship: resetOwningRelationship)
	}


	@objc(JetPack_setPrompt:)
	fileprivate dynamic func swizzled_setPrompt(_ prompt: String?) {
		// work around http://stackoverflow.com/questions/22115821/uinavigationitem-prompt-issue

		UINavigationBar.isSettingPromptCount += 1
		defer { UINavigationBar.isSettingPromptCount -= 1 }

		swizzled_setPrompt(prompt)
	}


	@nonobjc
	internal static func UINavigationBar_setUp() {
		// yep, private API necessary :(
		// If the private method is removed/renamed the related feature will cease to work but we won't crash.
		swizzleMethodInType(self, fromSelector: Selector("setPrompt:"), toSelector: #selector(swizzled_setPrompt(_:)))
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("_", "popNavigationItemWithTransition:"), toSelector: #selector(swizzled_popNavigationItemWithTransition(_:)))
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("_", "pushNavigationItem:", "transition:"), toSelector: #selector(swizzled_pushNavigationItem(_:transition:)))
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("_", "setItems:", "transition:", "reset:", "resetOwningRelationship:"), toSelector: #selector(swizzled_setItems(_:transition:reset:resetOwningRelationship:)))
	}
}
