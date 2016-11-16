import UIKit


public extension UIBlurEffect {

	@nonobjc
	private static let customBlurEffectType: UIBlurEffect.Type? = {
		if #available(iOS 10, *) {
			return NSClassFromString(["_", "UI", "Custom", "Blur", "Effect"].joinWithSeparator("")) as? UIBlurEffect.Type
		}
		else {
			// The method is available on iOS 9 but it's implementation is broken and causes an endless recursion.
			return nil
		}
	}()


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
