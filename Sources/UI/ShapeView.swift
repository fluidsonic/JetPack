import UIKit


@objc(JetPack_ShapeView)
open /* non-final */ class ShapeView: View {

	fileprivate var originalFillColor: UIColor?
	fileprivate var originalStrokeColor: UIColor?


	public override init() {
		super.init()

		if let layerFillColor = shapeLayer.fillColor {
			fillColor = UIColor(cgColor: layerFillColor)
		}
		if let layerStrokeColor = shapeLayer.strokeColor {
			strokeColor = UIColor(cgColor: layerStrokeColor)
		}
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		if let layerFillColor = shapeLayer.fillColor {
			fillColor = UIColor(cgColor: layerFillColor)
		}
		if let layerStrokeColor = shapeLayer.strokeColor {
			strokeColor = UIColor(cgColor: layerStrokeColor)
		}
	}


	open override func action(for layer: CALayer, forKey event: String) -> CAAction? {
		switch event {
		case "fillColor", "path", "strokeColor":
			if let animation = super.action(for: layer, forKey: "opacity") as? CABasicAnimation {
				animation.fromValue = shapeLayer.path
				animation.keyPath = event

				return animation
			}

			fallthrough

		default:
			return super.action(for: layer, forKey: event)
		}
	}


	open var fillColor: UIColor? {
		get { return originalFillColor }
		set {
			guard newValue != originalFillColor else {
				return
			}

			originalFillColor = newValue

			shapeLayer.fillColor = newValue?.tintedWithColor(tintColor).cgColor
		}
	}


	
	public final override class var layerClass : AnyObject.Type {
		return CAShapeLayer.self
	}


	open var path: UIBezierPath? {
		get {
			guard let layerPath = shapeLayer.path else {
				return nil
			}

			return UIBezierPath(cgPath: layerPath)
		}
		set {
			let shapeLayer = self.shapeLayer

			guard let path = newValue else {
				shapeLayer.path = nil
				return
			}

			shapeLayer.fillRule = path.usesEvenOddFillRule ? kCAFillRuleEvenOdd : kCAFillRuleNonZero

			switch path.lineCapStyle {
			case .butt:   shapeLayer.lineCap = kCALineCapButt
			case .round:  shapeLayer.lineCap = kCALineCapRound
			case .square: shapeLayer.lineCap = kCALineCapSquare
			}

			var dashPatternCount = 0
			path.getLineDash(nil, count: &dashPatternCount, phase: nil)

			var dashPattern = [CGFloat](repeating: 0, count: dashPatternCount)
			var dashPhase = CGFloat(0)
			path.getLineDash(&dashPattern, count: nil, phase: &dashPhase)

			shapeLayer.lineDashPattern = dashPattern.map { $0 as NSNumber }
			shapeLayer.lineDashPhase = dashPhase

			switch path.lineJoinStyle {
			case .bevel: shapeLayer.lineJoin = kCALineJoinBevel
			case .miter: shapeLayer.lineJoin = kCALineJoinMiter
			case .round: shapeLayer.lineJoin = kCALineJoinRound
			}

			shapeLayer.lineWidth = path.lineWidth
			shapeLayer.miterLimit = path.miterLimit
			shapeLayer.path = path.cgPath
		}
	}


	public fileprivate(set) final lazy var shapeLayer: CAShapeLayer = self.layer as! CAShapeLayer


	open var strokeEnd: CGFloat {
		get {
			return shapeLayer.strokeEnd
		}
		set {
			shapeLayer.strokeEnd = newValue
		}
	}


	open var strokeColor: UIColor? {
		get { return originalStrokeColor }
		set {
			guard newValue != originalStrokeColor else {
				return
			}

			originalStrokeColor = newValue

			shapeLayer.strokeColor = newValue?.tintedWithColor(tintColor).cgColor
		}
	}


	open var strokeStart: CGFloat {
		get {
			return shapeLayer.strokeStart
		}
		set {
			shapeLayer.strokeStart = newValue
		}
	}


	open override func tintColorDidChange() {
		super.tintColorDidChange()

		if let originalFillColor = originalFillColor, originalFillColor.tintAlpha != nil {
			shapeLayer.fillColor = originalFillColor.tintedWithColor(tintColor).cgColor
		}

		if let originalStrokeColor = originalStrokeColor, originalStrokeColor.tintAlpha != nil {
			shapeLayer.strokeColor = originalStrokeColor.tintedWithColor(tintColor).cgColor
		}
	}
}
