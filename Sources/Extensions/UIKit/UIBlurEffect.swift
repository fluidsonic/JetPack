import UIKit


public extension UIBlurEffect {

	@nonobjc
	private static let customBlurEffectType = NSClassFromString(["_", "UI", "Custom", "Blur", "Effect"].joinWithSeparator("")) as? UIBlurEffect.Type


	@nonobjc
	public static func create(style style: UIBlurEffectStyle, tintColor: UIColor, tintAlpha: CGFloat) -> UIBlurEffect {
		if let customBlurEffectType = customBlurEffectType {
			let effect = customBlurEffectType.customEffectWithStyle(style)
			if effect.dynamicType != UIBlurEffect.self {
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
	private dynamic class func customEffectWithStyle(style: UIBlurEffectStyle) -> UIBlurEffect {
		return UIBlurEffect(style: style)
	}


	@nonobjc
	internal static func UIBlurEffect_setUp() {
		// yep, private API necessary :(
		if let customBlurEffectType = customBlurEffectType {
			let factorySelectorName = "effectWithStyle:"
			redirectMethodInType(object_getClass(self), fromSelector: #selector(customEffectWithStyle(_:)), toSelector: Selector(factorySelectorName), inType: object_getClass(customBlurEffectType))
		}
		else {
			log("Cannot find type for custom blur effect.")
		}
	}
}
