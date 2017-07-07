import UIKit


public extension UISearchBar {

	@objc(JetPack_setAutomaticallyDisablesCancelButton:)
	dynamic func private_setAutomaticallyDisablesCancelButton(_ automaticallyDisablesCancelButton: Bool) {
		// UIKit automatically disables the cancel button unless the search bar is first responder.
		// Going through the subviews to find the cancel button is more fragile than disabling it using a private method.
		// If the private method no longer exists or changes signature the fix will simply stop working without harming the app.
	}
}


@objc(_JetPack_Extensions_UIKit_UISearchBar_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		redirectMethod(in: UISearchBar.self, from: #selector(UISearchBar.private_setAutomaticallyDisablesCancelButton(_:)), to: obfuscatedSelector("_", "set", "Auto", "Disable", "Cancel", "Button:"))
	}
}
