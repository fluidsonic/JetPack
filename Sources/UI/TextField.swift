import UIKit


@objc(JetPack_TextField)
public /* non-final */ class TextField: UITextField {

	public var additionalHitZone = UIEdgeInsets() // TODO don't use UIEdgeInsets because actually we outset
	public var hitZoneFollowsCornerRadius = true
	public var userInteractionLimitedToSubviews = false
	

	public init() {
		super.init(frame: .zero)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	public override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
		switch event {
		case "borderColor", "cornerRadius", "shadowColor", "shadowOffset", "shadowOpacity", "shadowPath", "shadowRadius":
			if let animation = super.actionForLayer(layer, forKey: "opacity") as? CABasicAnimation {
				animation.fromValue = layer.valueForKey(event)
				animation.keyPath = event

				return animation
			}

			fallthrough

		default:
			return super.actionForLayer(layer, forKey: event)
		}
	}


	public var borderColor: UIColor? {
		get { return layer.borderColor.map { UIColor(CGColor: $0) } }
		set { layer.borderColor = newValue?.CGColor }
	}


	public var borderWidth: CGFloat {
		get { return layer.borderWidth }
		set { layer.borderWidth = newValue }
	}


	public var cornerRadius: CGFloat {
		get { return layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}


	@warn_unused_result
	public final override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
		return pointInside(point, withEvent: event, additionalHitZone: additionalHitZone)
	}


	@warn_unused_result
	public func pointInside(point: CGPoint, withEvent event: UIEvent?, additionalHitZone: UIEdgeInsets) -> Bool {
		let originalHitZone = bounds
		let extendedHitZone = originalHitZone.insetBy(additionalHitZone.inverse)

		let hitZoneCornerRadius: CGFloat
		if hitZoneFollowsCornerRadius && cornerRadius > 0 {
			let halfOriginalHitZoneSize = (originalHitZone.width + originalHitZone.height) / 4  // middle between half height and half width
			let halfExtendedHitZoneSize = (extendedHitZone.width + extendedHitZone.height) / 4  // middle between half extended height and half extended width
			hitZoneCornerRadius = halfExtendedHitZoneSize * (cornerRadius / halfOriginalHitZoneSize)
		}
		else {
			hitZoneCornerRadius = 0
		}

		return extendedHitZone.contains(point, atCornerRadius: hitZoneCornerRadius)
	}


	// reference implementation
	@warn_unused_result
	public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		guard participatesInHitTesting else {
			return nil
		}
		guard pointInside(point, withEvent: event) else {
			return nil
		}

		var hitView: UIView?
		for subview in subviews.reverse() {
			hitView = subview.hitTest(convertPoint(point, toView: subview), withEvent: event)
			if hitView != nil {
				break
			}
		}

		if hitView == nil && !userInteractionLimitedToSubviews {
			hitView = self
		}

		return hitView
	}
}
