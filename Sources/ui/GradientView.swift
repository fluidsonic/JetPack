import UIKit


@objc(JetPack_GradientView)
public/* non-final */ class GradientView: View {

	public override init() {
		super.init()

		userInteractionEnabled = false
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	public var colors: [UIColor] {
		get {
			let cgColors = gradientLayer.colors as? [CGColorRef]
			return cgColors?.map { UIColor(CGColor: $0) } ?? []
		}
		set {
			gradientLayer.colors = newValue.map { $0.CGColor }
		}
	}


	public var endPoint: CGPoint {
		get { return gradientLayer.endPoint }
		set { gradientLayer.endPoint = newValue }
	}


	public private(set) final lazy var gradientLayer: CAGradientLayer = self.layer as! CAGradientLayer


	public override class func layerClass() -> AnyClass {
		return CAGradientLayer.self
	}


	public var locations: [CGFloat] {
		get { return gradientLayer.locations?.map { $0 as CGFloat } ?? [] }
		set { gradientLayer.locations = newValue }
	}


	public var startPoint: CGPoint {
		get { return gradientLayer.startPoint }
		set { gradientLayer.startPoint = newValue }
	}
}
