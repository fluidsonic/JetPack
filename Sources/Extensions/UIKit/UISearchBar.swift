import UIKit


public extension UISearchBar {

	@objc(JetPack_setAutomaticallyDisablesCancelButton:)
	internal func private_setAutomaticallyDisablesCancelButton(_ automaticallyDisablesCancelButton: Bool) {
		// UIKit automatically disables the cancel button unless the search bar is first responder.
		// Going through the subviews to find the cancel button is more fragile than disabling it using a private method.
		// If the private method no longer exists or changes signature the fix will simply stop working without harming the app.
	}


	@nonobjc
	internal static func UISearchBar_setUp() {
		redirectMethodInType(self, fromSelector: #selector(private_setAutomaticallyDisablesCancelButton(_:)), toSelector: obfuscatedSelector("_", "set", "Auto", "Disable", "Cancel", "Button:"))
	}
}
