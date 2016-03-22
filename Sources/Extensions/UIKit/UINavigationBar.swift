import UIKit


public extension UINavigationBar {

	@nonobjc
	internal private(set) static var isSettingPromptCount = 0


	@objc(JetPack_setPrompt:)
	private dynamic func swizzled_setPrompt(prompt: String?) {
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
	}
}
