import UIKit


@objc(JetPack_ShapeView)
open class ShapeView: View {

	private var normalFillColor: UIColor?
	private var normalStrokeColor: UIColor?


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
			if
				let animation = super.action(for: layer, forKey: "opacity") as? NSObject,
				let basicAnimation = (animation as? CABasicAnimation) ?? (animation.value(forKey: "pendingAnimation") as? CABasicAnimation)
			{
				basicAnimation.fromValue = layer.value(forKey: event)
				basicAnimation.isRemovedOnCompletion = true
				basicAnimation.keyPath = event

				return basicAnimation
			}

			fallthrough

		default:
			return super.action(for: layer, forKey: event)
		}
	}


	open override func didMoveToWindow() {
		super.didMoveToWindow()

		if window != nil {
			layer.rasterizationScale = gridScaleFactor
		}
	}


	open var fillColor: UIColor? {
		get { return normalFillColor }
		set {
			guard newValue != normalFillColor else {
				return
			}

			normalFillColor = newValue

			shapeLayer.fillColor = newValue?.tinted(with: tintColor).cgColor
		}
	}


	public var fillColorDimsWithTint = false {
		didSet {
			guard fillColorDimsWithTint != oldValue else {
				return
			}

			updateActualFillColor()
		}
	}


	@available(*, unavailable, message: "Don't override this.") // cannot mark as final
	open override class var layerClass: AnyClass {
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

			shapeLayer.fillRule = path.usesEvenOddFillRule ? .evenOdd : .nonZero

			switch path.lineCapStyle {
			case .butt:       shapeLayer.lineCap = .butt
			case .round:      shapeLayer.lineCap = .round
			case .square:     shapeLayer.lineCap = .square
			@unknown default: fatalError()
			}

			var dashPatternCount = 0
			path.getLineDash(nil, count: &dashPatternCount, phase: nil)

			var dashPattern = [CGFloat](repeating: 0, count: dashPatternCount)
			var dashPhase = CGFloat(0)
			path.getLineDash(&dashPattern, count: nil, phase: &dashPhase)

			shapeLayer.lineDashPattern = dashPattern.map { $0 as NSNumber }
			shapeLayer.lineDashPhase = dashPhase

			switch path.lineJoinStyle {
			case .bevel:      shapeLayer.lineJoin = .bevel
			case .miter:      shapeLayer.lineJoin = .miter
			case .round:      shapeLayer.lineJoin = .round
			@unknown default: fatalError()
			}

			shapeLayer.lineWidth = path.lineWidth
			shapeLayer.miterLimit = path.miterLimit
			shapeLayer.path = path.cgPath
		}
	}


	public private(set) final lazy var shapeLayer: CAShapeLayer = self.layer as! CAShapeLayer


	open var strokeEnd: CGFloat {
		get {
			return shapeLayer.strokeEnd
		}
		set {
			shapeLayer.strokeEnd = newValue
		}
	}


	open var strokeColor: UIColor? {
		get { return normalStrokeColor }
		set {
			guard newValue != normalStrokeColor else {
				return
			}

			normalStrokeColor = newValue

			shapeLayer.strokeColor = newValue?.tinted(with: tintColor).cgColor
		}
	}


	public var strokeColorDimsWithTint = false {
		didSet {
			guard strokeColorDimsWithTint != oldValue else {
				return
			}

			updateActualStrokeColor()
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

		if let originalFillColor = normalFillColor, originalFillColor.tintAlpha != nil {
			shapeLayer.fillColor = originalFillColor.tinted(with: tintColor).cgColor
		}

		if let originalStrokeColor = normalStrokeColor, originalStrokeColor.tintAlpha != nil {
			shapeLayer.strokeColor = originalStrokeColor.tinted(with: tintColor).cgColor
		}
	}


	private func updateActualFillColor() {
		let actualFillColor = normalFillColor?.tinted(for: self, dimsWithTint: fillColorDimsWithTint).cgColor
		guard actualFillColor != shapeLayer.fillColor else {
			return
		}

		shapeLayer.fillColor = actualFillColor
	}


	private func updateActualStrokeColor() {
		let actualStrokeColor = normalStrokeColor?.tinted(for: self, dimsWithTint: strokeColorDimsWithTint).cgColor
		guard actualStrokeColor != shapeLayer.strokeColor else {
			return
		}

		shapeLayer.strokeColor = actualStrokeColor
	}
}
