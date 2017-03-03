import QuartzCore


@objc(JetPack_Layer)
open class Layer: CALayer {

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


	open func size(thatFits maximumSize: CGSize) -> CGSize {
		return preferredFrameSize()
	}


	open func willResizeToSize(_ newSize: CGSize) {
		(delegate as? View)?.willResizeToSize(newSize)
	}
}
