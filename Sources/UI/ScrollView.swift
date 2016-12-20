import UIKit


@objc(JetPack_ScrollView)
open /* non-final */ class ScrollView: UIScrollView {

	fileprivate var delegateRespondsToViewForZooming = false

	fileprivate weak var newDelegate: ScrollViewDelegate?

	open var additionalHitZone = UIEdgeInsets() // TODO don't use UIEdgeInsets because actually we outset
	open var centersViewForZooming = true
	open var hitZoneFollowsCornerRadius = true
	open var userInteractionLimitedToSubviews = false


	public init() {
		super.init(frame: .zero)
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	fileprivate func centerViewForZooming() {
		guard centersViewForZooming && delegateRespondsToViewForZooming else {
			return
		}

		guard let viewForZooming = delegate?.viewForZooming?(in: self), viewForZooming.superview === self else {
			return
		}

		let availableSize = bounds.size.insetBy(self.contentInset)

		var viewForZoomingFrame = viewForZooming.convert(viewForZooming.bounds, to: self)
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


	open var cornerRadius: CGFloat {
		get { return layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}


	open override var contentInset: UIEdgeInsets {
		get { return super.contentInset }
		set {
			guard newValue != contentInset else {
				return
			}

			super.contentInset = newValue

			centerViewForZooming()
		}
	}


	open override var contentOffset: CGPoint {
		get { return super.contentOffset }
		set {
			guard newValue != contentOffset else {
				return
			}

			super.contentOffset = newValue

			centerViewForZooming()
		}
	}


	open override var contentSize: CGSize {
		get { return super.contentSize }
		set {
			guard newValue != contentSize else {
				return
			}

			super.contentSize = newValue

			centerViewForZooming()
		}
	}


	fileprivate func defaultShouldReceiveTouch(_ touch: UITouch) -> Bool {
		return true
	}


	open override weak var delegate: UIScrollViewDelegate? {
		get { return super.delegate }
		set {
			super.delegate = newValue

			delegateRespondsToViewForZooming = super.delegate?.responds(to: #selector(UIScrollViewDelegate.viewForZooming(`in`:))) ?? false
			newDelegate = super.delegate as? ScrollViewDelegate
		}
	}


	open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		return newDelegate?.scrollView(self, shouldReceiveTouch: touch) ?? defaultShouldReceiveTouch(touch)
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


	open override func layoutSubviews() {
		super.layoutSubviews()

		centerViewForZooming()
	}


	
	public final override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return pointInside(point, withEvent: event, additionalHitZone: additionalHitZone)
	}


	
	open func pointInside(_ point: CGPoint, withEvent event: UIEvent?, additionalHitZone: UIEdgeInsets) -> Bool {
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


	
	open override func sizeThatFitsSize(_ maximumSize: CGSize) -> CGSize {
		return bounds.size
	}


	// Override `sizeThatFitsSize(_:)` instead!
	@available(*, unavailable, renamed: "sizeThatFitsSize")
	
	public final override func sizeThatFits(_ maximumSize: CGSize) -> CGSize {
		return sizeThatFitsSize(maximumSize)
	}
}


public protocol ScrollViewDelegate: UIScrollViewDelegate {

	func scrollView(_ scrollView: ScrollView, shouldReceiveTouch touch: UITouch) -> Bool
}


public extension ScrollViewDelegate {

	public func scrollView(_ scrollView: ScrollView, shouldReceiveTouch touch: UITouch) -> Bool {
		return scrollView.defaultShouldReceiveTouch(touch)
	}
}
