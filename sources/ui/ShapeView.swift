import UIKit


@IBDesignable
public /* non-final */ class ShapeView: View {

	public override init() {
		super.init()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	#if TARGET_INTERFACE_BUILDER
		public convenience init(frame: CGRect) {
			self.init()

			self.frame = frame
		}
	#endif


	public override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
		if event == "path" {
			if let animation = super.actionForLayer(layer, forKey: "opacity") as? CABasicAnimation {
				animation.fromValue = shapeLayer.path
				animation.keyPath = event

				return animation
			}
		}

		return super.actionForLayer(layer, forKey: event)
	}


	@IBInspectable
	public var fillColor: UIColor? {
		get {
			guard let layerFillColor = shapeLayer.fillColor else {
				return nil
			}

			return UIColor(CGColor: layerFillColor)
		}
		set {
			shapeLayer.fillColor = newValue?.CGColor
		}
	}


	public override class func layerClass() -> AnyClass {
		return CAShapeLayer.self
	}


	public var path: UIBezierPath? {
		get {
			guard let layerPath = shapeLayer.path else {
				return nil
			}

			return UIBezierPath(CGPath: layerPath)
		}
		set {
			let shapeLayer = self.shapeLayer

			guard let path = newValue else {
				shapeLayer.path = nil
				return
			}

			shapeLayer.fillRule = path.usesEvenOddFillRule ? kCAFillRuleEvenOdd : kCAFillRuleNonZero

			switch path.lineCapStyle {
			case .Butt:   shapeLayer.lineCap = kCALineCapButt
			case .Round:  shapeLayer.lineCap = kCALineCapRound
			case .Square: shapeLayer.lineCap = kCALineCapSquare
			}

			var dashPatternCount = 0
			path.getLineDash(nil, count: &dashPatternCount, phase: nil)

			var dashPattern = [CGFloat](count: dashPatternCount, repeatedValue: 0)
			var dashPhase = CGFloat(0)
			path.getLineDash(&dashPattern, count: nil, phase: &dashPhase)

			shapeLayer.lineDashPattern = dashPattern.map { $0 as NSNumber }
			shapeLayer.lineDashPhase = dashPhase

			switch path.lineJoinStyle {
			case .Bevel: shapeLayer.lineJoin = kCALineJoinBevel
			case .Miter: shapeLayer.lineJoin = kCALineJoinMiter
			case .Round: shapeLayer.lineJoin = kCALineJoinRound
			}

			shapeLayer.lineWidth = path.lineWidth
			shapeLayer.miterLimit = path.miterLimit
			shapeLayer.path = path.CGPath
		}
	}


	public private(set) final lazy var shapeLayer: CAShapeLayer = self.layer as! CAShapeLayer


	@IBInspectable
	public var strokeEnd: CGFloat {
		get {
			return shapeLayer.strokeEnd
		}
		set {
			shapeLayer.strokeEnd = newValue
		}
	}


	@IBInspectable
	public var strokeColor: UIColor? {
		get {
			guard let layerStrokeColor = shapeLayer.strokeColor else {
				return nil
			}

			return UIColor(CGColor: layerStrokeColor)
		}
		set {
			shapeLayer.strokeColor = newValue?.CGColor
		}
	}


	@IBInspectable
	public var strokeStart: CGFloat {
		get {
			return shapeLayer.strokeStart
		}
		set {
			shapeLayer.strokeStart = newValue
		}
	}
}
