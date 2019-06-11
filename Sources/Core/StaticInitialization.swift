import Foundation


public enum JetPackKit { // for now named *Kit until this is solved: https://bugs.swift.org/browse/SR-898

	private static let typeNames = [
		// Initialization classes to be invoked. Note that the order of initialization may be relevant in some cases.

		"_JetPack_Extensions_QuartzCore_CALayer_Initialization",

		"_JetPack_Extensions_UIKit_Keyboard_Initialization",
		"_JetPack_Extensions_UIKit_UIApplication_Initialization",
		"_JetPack_Extensions_UIKit_UIBlurEffect_Initialization",
		"_JetPack_Extensions_UIKit_UINavigationBar_Initialization",
		"_JetPack_Extensions_UIKit_UINavigationController_Initialization",
		"_JetPack_Extensions_UIKit_UIPresentationController_Initialization",
		"_JetPack_Extensions_UIKit_UISearchBar_Initialization",
		"_JetPack_Extensions_UIKit_UITabBarController_Initialization",
		"_JetPack_Extensions_UIKit_UITableView_Initialization",
		"_JetPack_Extensions_UIKit_UITableViewCell_Initialization",
		"_JetPack_Extensions_UIKit_UITextField_Initialization",
		"_JetPack_Extensions_UIKit_UIView_Initialization",
		"_JetPack_Extensions_UIKit_UIViewController_Initialization",
		"_JetPack_Extensions_UIKit_UIWindow_Initialization",

		"_JetPack_UI_UIViewController_Initialization",

		"_JetPack_UI_ImagePickerController_Initialization",
		"_JetPack_UI_NavigationController_Initialization",
		"_JetPack_UI_OldTextLayout_Initialization",
		"_JetPack_UI_TextLayout_Initialization",
		"_JetPack_UI_ViewController_Initialization"
	]
	private static var isInitialized = false


	public static func initialize() {
		guard !isInitialized else {
			return
		}

		isInitialized = true

		for typeName in typeNames {
			guard let type = NSClassFromString(typeName) else {
				log("Static initialization not invoked for type \(typeName). Either the submodule isn't used or type name is wrong.") // TODO remove once we have unit testing for static initialization
				continue
			}

			(type as! StaticInitializable.Type).staticInitialize()
		}
	}
}
