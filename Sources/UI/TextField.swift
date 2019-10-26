import UIKit


@objc(JetPack_TextField)
open class TextField: UITextField {

	open var additionalHitZone = UIEdgeInsets() // TODO don't use UIEdgeInsets because actually we outset
	open var hitZoneFollowsCornerRadius = true
	open var userInteractionLimitedToSubviews = false
	

	public init() {
		super.init(frame: .zero)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	open var borderColor: UIColor? {
		get { return layer.borderColor.map { UIColor(cgColor: $0) } }
		set { layer.borderColor = newValue?.cgColor }
	}


	open var borderWidth: CGFloat {
		get { return layer.borderWidth }
		set { layer.borderWidth = newValue }
	}


	open var cornerRadius: CGFloat {
		get { return layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}


	// reference implementation
	open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		guard participatesInHitTesting else {
			return nil
		}
		guard self.point(inside: point, with: event) else {
			return nil
		}

		var hitView: UIView?
		for subview in subviews.reversed() {
			hitView = subview.hitTest(convert(point, to: subview), with: event)
			if hitView != nil {
				break
			}
		}

		if hitView == nil && !userInteractionLimitedToSubviews {
			hitView = self
		}

		return hitView
	}

	
	public final override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return pointInside(point, withEvent: event, additionalHitZone: additionalHitZone)
	}


	open func pointInside(_ point: CGPoint, withEvent event: UIEvent?, additionalHitZone: UIEdgeInsets) -> Bool {
		let originalHitZone = bounds
		let extendedHitZone = originalHitZone.inset(by: -additionalHitZone)

		let hitZoneCornerRadius: CGFloat
		if hitZoneFollowsCornerRadius && cornerRadius > 0 {
			let halfOriginalHitZoneSize = (originalHitZone.width + originalHitZone.height) / 4  // middle between half height and half width
			let halfExtendedHitZoneSize = (extendedHitZone.width + extendedHitZone.height) / 4  // middle between half extended height and half extended width
			hitZoneCornerRadius = halfExtendedHitZoneSize * (cornerRadius / halfOriginalHitZoneSize)
		}
		else {
			hitZoneCornerRadius = 0
		}

		return extendedHitZone.contains(point, cornerRadius: hitZoneCornerRadius)
	}


	open override func shouldAnimateProperty(_ property: String) -> Bool {
		if super.shouldAnimateProperty(property) {
			return true
		}

		switch property {
		case "borderColor", "cornerRadius", "shadowColor", "shadowOffset", "shadowOpacity", "shadowPath", "shadowRadius":
			return true

		default:
			return false
		}
	}
}
