import UIKit


@IBDesignable
public /* non-final */ class ShapeView: View {

	private var originalFillColor: UIColor?
	private var originalStrokeColor: UIColor?


	public override init() {
		super.init()

		if let layerFillColor = shapeLayer.fillColor {
			fillColor = UIColor(CGColor: layerFillColor)
		}
		if let layerStrokeColor = shapeLayer.strokeColor {
			strokeColor = UIColor(CGColor: layerStrokeColor)
		}
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		if let layerFillColor = shapeLayer.fillColor {
			fillColor = UIColor(CGColor: layerFillColor)
		}
		if let layerStrokeColor = shapeLayer.strokeColor {
			strokeColor = UIColor(CGColor: layerStrokeColor)
		}
	}


	#if TARGET_INTERFACE_BUILDER
		public convenience init(frame: CGRect) {
			self.init()

			self.frame = frame
		}
	#endif


	public override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
		switch event {
		case "fillColor", "path", "strokeColor":
			if let animation = super.actionForLayer(layer, forKey: "opacity") as? CABasicAnimation {
				animation.fromValue = shapeLayer.path
				animation.keyPath = event

				return animation
			}

			fallthrough

		default:
			return super.actionForLayer(layer, forKey: event)
		}
	}


	@IBInspectable
	public var fillColor: UIColor? {
		get { return originalFillColor }
		set {
			guard newValue != originalFillColor else {
				return
			}

			originalFillColor = newValue

			shapeLayer.fillColor = newValue?.tintedWithColor(tintColor).CGColor
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
		get { return originalStrokeColor }
		set {
			guard newValue != originalStrokeColor else {
				return
			}

			originalStrokeColor = newValue

			shapeLayer.strokeColor = newValue?.tintedWithColor(tintColor).CGColor
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


	public override func tintColorDidChange() {
		super.tintColorDidChange()

		if let originalFillColor = originalFillColor where originalFillColor.tintAlpha != nil {
			shapeLayer.fillColor = originalFillColor.tintedWithColor(tintColor).CGColor
		}

		if let originalStrokeColor = originalStrokeColor where originalStrokeColor.tintAlpha != nil {
			shapeLayer.strokeColor = originalStrokeColor.tintedWithColor(tintColor).CGColor
		}
	}
}
