import QuartzCore


@objc(JetPack_Layer)
open class Layer: CALayer {

	// needsLayout() and layoutBelowIfNeeded() don't behave correctly when we're in a layout pass, so let's help the layer a bit…
	private var reallyNeedsLayout = false


	public override init() {
		super.init()
	}


	public required override init(layer: Any) {
		super.init(layer: layer)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	open override var bounds: CGRect {
		get { return super.bounds }
		set {
			let oldValue = super.bounds
			guard newValue != oldValue else {
				return
			}

			if newValue.size != oldValue.size {
				willResizeToSize(newValue.size)
				super.bounds = newValue
				didResizeFromSize(oldValue.size)
			}
			else {
				super.bounds = newValue
			}
		}
	}


	open func didResizeFromSize(_ oldSize: CGSize) {
		(delegate as? View)?.didResizeFromSize(oldSize)
	}


	open override func layoutIfNeeded() {
		guard reallyNeedsLayout else {
			return
		}

		if !super.needsLayout() {
			// CALayer sometimes queues a layout and sets needsLayout to false so any call to layoutIfNeeded() between the queuing and the actual layout call does
			// not result in an immediate call to layoutSublayers().
			super.setNeedsLayout()
		}

		super.layoutIfNeeded()
	}


	open override func layoutSublayers() {
		guard reallyNeedsLayout else {
			// CALayer sometimes unnecessarily calls this twice if setNeedsLayout()/layoutIfNeeded() was called and another layout call was already queued for
			// the current layout cycle.
			return
		}

		reallyNeedsLayout = false

		super.layoutSublayers()
	}


	override func layoutWithSubtreeIfNeeded() {
		guard reallyNeedsLayout else {
			return
		}

		if !super.needsLayout() {
			// CALayer sometimes queues a layout and sets needsLayout to false so any call to layoutIfNeeded() between the queuing and the actual layout call does
			// not result in an immediate call to layoutSublayers().
			super.setNeedsLayout()
		}

		super.layoutWithSubtreeIfNeeded()
	}


	open override func needsLayout() -> Bool {
		return reallyNeedsLayout
	}


	open override func setNeedsLayout() {
		reallyNeedsLayout = true

		super.setNeedsLayout()
	}


	open func size(thatFits maximumSize: CGSize) -> CGSize {
		return preferredFrameSize()
	}


	open func willResizeToSize(_ newSize: CGSize) {
		(delegate as? View)?.willResizeToSize(newSize)
	}
}
