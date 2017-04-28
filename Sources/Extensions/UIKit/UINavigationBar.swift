import UIKit


extension UINavigationBar {

	@nonobjc
	private(set) static var isSettingPromptCount = 0


	@objc(JetPack_hasBackButton)
	var hasBackButton: Bool {
		return swizzled_hasBackButton
	}


	@objc(JetPack_popNavigationItemWithTransition:)
	func popNavigationItemWithTransition(_ transition: Int32) -> UINavigationItem {
		return swizzled_popNavigationItemWithTransition(transition)
	}


	@objc(JetPack_pushNavigationItem:transition:)
	func pushNavigationItem(_ item: UINavigationItem, transition: Int32) {
		swizzled_pushNavigationItem(item, transition: transition)
	}


	@objc(JetPack_setItems:transition:reset:resetOwningRelationship:)
	func setItems(_ items: NSArray, transition: Int32, reset: Bool, resetOwningRelationship: Bool) {
		swizzled_setItems(items, transition: transition, reset: reset, resetOwningRelationship: resetOwningRelationship)
	}


	@objc(JetPack_swizzled_hasBackButton)
	private dynamic var swizzled_hasBackButton: Bool {
		return hasBackButton
	}


	@objc(JetPack_swizzled_popNavigationItemWithTransition:)
	private dynamic func swizzled_popNavigationItemWithTransition(_ transition: Int32) -> UINavigationItem {
		return popNavigationItemWithTransition(transition)
	}


	@objc(JetPack_swizzled_pushNavigationItem:transition:)
	private dynamic func swizzled_pushNavigationItem(_ item: UINavigationItem, transition: Int32) {
		pushNavigationItem(item, transition: transition)
	}


	@objc(JetPack_swizzled_setItems:transition:reset:resetOwningRelationship:)
	private dynamic func swizzled_setItems(_ items: NSArray, transition: Int32, reset: Bool, resetOwningRelationship: Bool) {
		setItems(items, transition: transition, reset: reset, resetOwningRelationship: resetOwningRelationship)
	}


	@objc(JetPack_setPrompt:)
	private dynamic func swizzled_setPrompt(_ prompt: String?) {
		// work around http://stackoverflow.com/questions/22115821/uinavigationitem-prompt-issue

		UINavigationBar.isSettingPromptCount += 1
		defer { UINavigationBar.isSettingPromptCount -= 1 }

		swizzled_setPrompt(prompt)
	}


	@nonobjc
	static func UINavigationBar_setUp() {
		swizzleMethod(in: self, from: #selector(setter: UINavigationItem.prompt), to: #selector(swizzled_setPrompt(_:)))

		// yep, private API necessary :(
		// If the private method is removed/renamed the related feature will cease to work but we won't crash.
		swizzleMethod(in: self, from: obfuscatedSelector("_", "has", "Back", "Button"),                                          to: #selector(getter: swizzled_hasBackButton))
		swizzleMethod(in: self, from: obfuscatedSelector("_", "popNavigationItemWithTransition:"),                               to: #selector(swizzled_popNavigationItemWithTransition(_:)))
		swizzleMethod(in: self, from: obfuscatedSelector("_", "pushNavigationItem:", "transition:"),                             to: #selector(swizzled_pushNavigationItem(_:transition:)))
		swizzleMethod(in: self, from: obfuscatedSelector("_", "setItems:", "transition:", "reset:", "resetOwningRelationship:"), to: #selector(swizzled_setItems(_:transition:reset:resetOwningRelationship:)))
	}
}
