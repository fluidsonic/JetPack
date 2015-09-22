// TODO
// - rethink *Scaled methods

public extension UIView {

	@nonobjc
	@warn_unused_result
	public final func ceilScaled(value: CGFloat) -> CGFloat {
		let offset = 0.5 / contentScaleFactor
		return roundScaled(value + offset)
	}


	@nonobjc
	@warn_unused_result
	public final func ceilScaled(value: CGSize) -> CGSize {
		let offset = 0.5 / contentScaleFactor
		return roundScaled(CGSize(width: value.width + offset, height: value.height + offset))
	}


	@nonobjc
	@warn_unused_result
	public final func ceilScaled(value: CGRect) -> CGRect {
		let offset = 0.5 / contentScaleFactor
		return roundScaled(CGRect(left: value.left, top: value.top, width: value.width + offset, height: value.height + offset))
	}


	@warn_unused_result
	public final func heightThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).height
	}


	@warn_unused_result
	public final func heightThatFitsWidth(maximumWidth: CGFloat) -> CGFloat {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .max)).height
	}


	public func removeAllSubviews() {
		for subview in subviews.reverse() {
			subview.removeFromSuperview()
		}
	}


	@nonobjc
	@warn_unused_result
	public final func roundScaled(value: CGFloat) -> CGFloat {
		let scale = contentScaleFactor

		return round(value * scale) / scale
	}


	@nonobjc
	@warn_unused_result
	public final func roundScaled(value: CGPoint) -> CGPoint {
		let scale = contentScaleFactor

		return CGPoint(
			left: round(value.left * scale) / scale,
			top:  round(value.top * scale) / scale
		)
	}


	@nonobjc
	@warn_unused_result
	public final func roundScaled(value: CGSize) -> CGSize {
		let scale = contentScaleFactor

		return CGSize(
			width:  round(value.width * scale) / scale,
			height: round(value.height * scale) / scale
		)
	}


	@nonobjc
	@warn_unused_result
	public final func roundScaled(value: CGRect) -> CGRect {
		let scale = contentScaleFactor

		return CGRect(
			left:   round(value.left * scale) / scale,
			top:    round(value.top * scale) / scale,
			width:  round(value.width * scale) / scale,
			height: round(value.height * scale) / scale
		)
	}


	@warn_unused_result
	public final func sizeThatFits() -> CGSize {
		return sizeThatFitsSize(.max)
	}


	@warn_unused_result
	public final func sizeThatFitsHeight(maximumHeight: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: .max, height: maximumHeight), allowsTruncation: allowsTruncation)
	}


	@warn_unused_result
	public final func sizeThatFitsWidth(maximumWidth: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .max), allowsTruncation: allowsTruncation)
	}


	@warn_unused_result
	public func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		return sizeThatFitsSize(maximumSize, allowsTruncation: false)
	}


	@warn_unused_result
	public func sizeThatFitsSize(maximumSize: CGSize, allowsTruncation: Bool) -> CGSize {
		var fittingSize = sizeThatFits(maximumSize)
		if allowsTruncation {
			fittingSize = fittingSize.constrainTo(maximumSize)
		}

		return fittingSize
	}


	@warn_unused_result
	public final func widthThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).width
	}


	@warn_unused_result
	public final func widthThatFitsHeight(maximumHeight: CGFloat) -> CGFloat {
		return sizeThatFitsSize(CGSize(width: .max, height: maximumHeight)).width
	}



	public struct Animation {

		public typealias Completion = (finished: Bool) -> Void
		public typealias CompletionRegistration = Completion -> Void

		public var allowsUserInteraction = false
		public var autoreverses = false
		public var beginsFromCurrentState = false
		public var delay = NSTimeInterval(0)
		public var duration: NSTimeInterval
		public var layoutsSubviews = false
		public var overridesInheritedDuration = false
		public var overridesInheritedOptions = false
		public var overridesInheritedTiming = false
		public var repeats = false
		public var timing: Timing


		public init(duration: NSTimeInterval = 0.3, timing: Timing = .Spring(initialVelocity: 0, damping: 1)) {
			self.duration = duration
			self.timing = timing
		}


		public func run(@noescape changes: Void -> Void) {
			runWithCompletion { _ in changes() }
		}


		public func runWithCompletion(@noescape changes: (complete: CompletionRegistration) -> Void) {
			var completions = [Completion]()

			var options = UIViewAnimationOptions()
			if allowsUserInteraction {
				options.insert(.AllowUserInteraction)
			}
			if autoreverses {
				options.insert(.Autoreverse)
			}
			if beginsFromCurrentState {
				options.insert(.BeginFromCurrentState)
			}
			if layoutsSubviews {
				options.insert(.LayoutSubviews)
			}
			if overridesInheritedDuration {
				options.insert(.OverrideInheritedDuration)
			}
			if overridesInheritedOptions {
				options.insert(.OverrideInheritedOptions)
			}
			if overridesInheritedTiming {
				options.insert(.OverrideInheritedCurve)
			}
			if repeats {
				options.insert(.Repeat)
			}


			let escapableChanges = makeEscapable(changes)

			func performChanges() {
				escapableChanges() { completion in
					completions.append(completion)
				}
			}


			func completion(finished: Bool) {
				for completion in completions {
					completion(finished: finished)
				}
			}


			switch timing {
			case .EaseIn:
				options.insert(.CurveEaseIn)
				UIView.animateWithDuration(duration, delay: delay, options: options, animations: performChanges, completion: completion)

			case .EaseInEaseOut:
				options.insert(.CurveEaseInOut)
				UIView.animateWithDuration(duration, delay: delay, options: options, animations: performChanges, completion: completion)

			case .EaseOut:
				options.insert(.CurveEaseOut)
				UIView.animateWithDuration(duration, delay: delay, options: options, animations: performChanges, completion: completion)

			case .Linear:
				options.insert(.CurveLinear)
				UIView.animateWithDuration(duration, delay: delay, options: options, animations: performChanges, completion: completion)

			case let .Spring(initialVelocity, damping):
				UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: options, animations: performChanges, completion: completion)
			}
		}



		public enum Timing {
			case EaseIn
			case EaseInEaseOut
			case EaseOut
			case Linear
			case Spring(initialVelocity: CGFloat, damping: CGFloat)
		}
	}
}
