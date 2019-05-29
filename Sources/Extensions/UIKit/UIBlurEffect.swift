import UIKit


public extension UIBlurEffect {

	@nonobjc
	fileprivate static let customBlurEffectType: UIBlurEffect.Type? = {
		return NSClassFromString(["_", "UI", "Custom", "Blur", "Effect"].joined(separator: "")) as? UIBlurEffect.Type
	}()


	@nonobjc
	static func create(style: UIBlurEffect.Style, tintColor: UIColor, tintAlpha: CGFloat) -> UIBlurEffect {
		if let customBlurEffectType = customBlurEffectType {
			let effect = customBlurEffectType.customEffectWithStyle(style)
			if type(of: effect) != UIBlurEffect.self {
				effect.setValue(tintColor, forKey: "colorTint")
				effect.setValue(tintAlpha, forKey: "colorTintAlpha")
			}
			return effect
		}
		else {
			return UIBlurEffect(style: style)
		}
	}


	@objc(JetPack_customEffectWithStyle:)
	fileprivate dynamic class func customEffectWithStyle(_ style: UIBlurEffect.Style) -> UIBlurEffect {
		return UIBlurEffect(style: style)
	}
}


@objc(_JetPack_Extensions_UIKit_UIBlurEffect_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		// yep, private API necessary :(
		if let customBlurEffectType = UIBlurEffect.customBlurEffectType {
			let factorySelectorName = "effectWithStyle:"
			redirectMethod(in: object_getClass(UIBlurEffect.self)!, from: #selector(UIBlurEffect.customEffectWithStyle(_:)), to: Selector(factorySelectorName), in: object_getClass(customBlurEffectType))
		}
		else {
			log("Cannot find type for custom blur effect.")
		}
	}
}
