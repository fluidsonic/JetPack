import UIKit


@objc(JetPack_ScrollView)
public /* non-final */ class ScrollView: UIScrollView {

	private var delegateRespondsToViewForZooming = false

	public var additionalHitZone = UIEdgeInsets() // TODO don't use UIEdgeInsets because actually we outset
	public var centersViewForZooming = true
	public var hitZoneFollowsCornerRadius = true
	public var userInteractionLimitedToSubviews = false


	public init() {
		super.init(frame: .zero)
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func centerViewForZooming() {
		guard centersViewForZooming && delegateRespondsToViewForZooming else {
			return
		}

		guard let viewForZooming = delegate?.viewForZoomingInScrollView?(self) where viewForZooming.superview === self else {
			return
		}

		let availableSize = bounds.size.insetBy(self.contentInset)

		var viewForZoomingFrame = viewForZooming.convertRect(viewForZooming.bounds, toView: self)
		if viewForZoomingFrame.width < availableSize.width {
			viewForZoomingFrame.left = (availableSize.width - viewForZoomingFrame.width) / 2
		}
		else {
			viewForZoomingFrame.left = 0
		}

		if viewForZoomingFrame.height < availableSize.height {
			viewForZoomingFrame.top = (availableSize.height - viewForZoomingFrame.height) / 2
		}
		else {
			viewForZoomingFrame.top = 0
		}

		viewForZooming.center = viewForZoomingFrame.center
	}


	public var cornerRadius: CGFloat {
		get { return layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}


	public override var contentInset: UIEdgeInsets {
		get { return super.contentInset }
		set {
			guard newValue != contentInset else {
				return
			}

			super.contentInset = newValue

			centerViewForZooming()
		}
	}


	public override var contentOffset: CGPoint {
		get { return super.contentOffset }
		set {
			guard newValue != contentOffset else {
				return
			}

			super.contentOffset = newValue

			centerViewForZooming()
		}
	}


	public override var contentSize: CGSize {
		get { return super.contentSize }
		set {
			guard newValue != contentSize else {
				return
			}

			super.contentSize = newValue

			centerViewForZooming()
		}
	}


	public override weak var delegate: UIScrollViewDelegate? {
		get { return super.delegate }
		set {
			super.delegate = newValue

			delegateRespondsToViewForZooming = super.delegate?.respondsToSelector(#selector(UIScrollViewDelegate.viewForZoomingInScrollView(_:))) ?? false
		}
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


	public override func layoutSubviews() {
		super.layoutSubviews()

		centerViewForZooming()
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


	@warn_unused_result
	public override func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		return bounds.size
	}


	// Override `sizeThatFitsSize(_:)` instead!
	@available(*, unavailable, renamed="sizeThatFitsSize")
	@warn_unused_result
	public final override func sizeThatFits(maximumSize: CGSize) -> CGSize {
		return sizeThatFitsSize(maximumSize)
	}
}
