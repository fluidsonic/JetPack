import QuartzCore


@objc(JetPack_Layer)
public /* non-final */ class Layer: CALayer {

	public override init() {
		super.init()
	}


	public required override init(layer: AnyObject) {
		super.init(layer: layer)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	public override var bounds: CGRect {
		get { return super.bounds }
		set {
			let oldValue = super.bounds
			guard newValue != oldValue else {
				return
			}

			if newValue.size != oldValue.size, let view = delegate as? View {
				view.willResizeToSize(newValue.size)
				super.bounds = newValue
				view.didResizeFromSize(oldValue.size)
			}
			else {
				super.bounds = newValue
			}
		}
	}
}
