import UIKit


@IBDesignable
public/* non-final */ class GradientView: View {

	public override init() {
		super.init()

		userInteractionEnabled = false
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	#if TARGET_INTERFACE_BUILDER
		public convenience init(frame: CGRect) {
			self.init()

			self.frame = frame

			userInteractionEnabled = false
		}
	#endif


	@IBInspectable
	public var colors: [UIColor] {
		get {
			let cgColors = gradientLayer.colors as? [CGColorRef]
			return cgColors?.map { UIColor(CGColor: $0) } ?? []
		}
		set {
			gradientLayer.colors = newValue.map { $0.CGColor }
		}
	}


	@IBInspectable
	public var endPoint: CGPoint {
		get { return gradientLayer.endPoint }
		set { gradientLayer.endPoint = newValue }
	}


	public private(set) final lazy var gradientLayer: CAGradientLayer = self.layer as! CAGradientLayer


	public override class func layerClass() -> AnyClass {
		return CAGradientLayer.self
	}


	@IBInspectable
	public var locations: [CGFloat] {
		get { return gradientLayer.locations?.map { $0 as CGFloat } ?? [] }
		set { gradientLayer.locations = newValue }
	}


	@IBInspectable
	public var startPoint: CGPoint {
		get { return gradientLayer.startPoint }
		set { gradientLayer.startPoint = newValue }
	}
}
