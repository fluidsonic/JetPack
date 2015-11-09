import UIKit


public extension UIView {

	@nonobjc
	@warn_unused_result
	public final func alignToGrid(rect: CGRect) -> CGRect {
		return CGRect(origin: alignToGrid(rect.origin), size: alignToGrid(rect.size))
	}


	@nonobjc
	@warn_unused_result
	public final func alignToGrid(point: CGPoint) -> CGPoint {
		return CGPoint(left: roundToGrid(point.left), top: roundToGrid(point.top))
	}


	@nonobjc
	@warn_unused_result
	public final func alignToGrid(size: CGSize) -> CGSize {
		return CGSize(width: ceilToGrid(size.width), height: ceilToGrid(size.height))
	}


	@nonobjc
	@warn_unused_result
	public final func ceilToGrid(value: CGFloat) -> CGFloat {
		let scale = gridScaleFactor
		return ceil(value * scale) / scale
	}


	@nonobjc
	@warn_unused_result
	public final func floorToGrid(value: CGFloat) -> CGFloat {
		let scale = gridScaleFactor
		return floor(value * scale) / scale
	}


	@nonobjc
	public final var gridScaleFactor: CGFloat {
		return max(contentScaleFactor, (window?.screen.scale ?? UIScreen.mainScreen().scale))
	}


	@nonobjc
	@warn_unused_result
	public final func heightThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).height
	}


	@nonobjc
	@warn_unused_result
	public final func heightThatFitsWidth(maximumWidth: CGFloat) -> CGFloat {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .max)).height
	}


	@nonobjc
	public var needsLayout: Bool {
		return layer.needsLayout()
	}


	@nonobjc
	public var participatesInHitTesting: Bool {
		return (!hidden && userInteractionEnabled && alpha >= 0.01)
	}


	@nonobjc
	public func removeAllSubviews() {
		for subview in subviews.reverse() {
			subview.removeFromSuperview()
		}
	}


	@nonobjc
	@warn_unused_result
	public final func roundToGrid(value: CGFloat) -> CGFloat {
		let scale = gridScaleFactor
		return round(value * scale) / scale
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFits() -> CGSize {
		return sizeThatFitsSize(.max)
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFitsHeight(maximumHeight: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: .max, height: maximumHeight), allowsTruncation: allowsTruncation)
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFitsWidth(maximumWidth: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .max), allowsTruncation: allowsTruncation)
	}


	// @nonobjc // cannot be used due to compiler limitation: subclasses cannot override non-objc functions defined in extensions
	@warn_unused_result
	public func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		return sizeThatFits(maximumSize)
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFitsSize(maximumSize: CGSize, allowsTruncation: Bool) -> CGSize {
		var fittingSize = sizeThatFitsSize(maximumSize)
		if allowsTruncation {
			fittingSize = fittingSize.constrainTo(maximumSize)
		}

		return fittingSize
	}


	@nonobjc
	@warn_unused_result
	public final func widthThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).width
	}


	@nonobjc
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


		public static func run(animation: Animation?, @noescape changes: Void -> Void) {
			if let animation = animation {
				animation.run(changes)
			}
			else {
				changes()
			}
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


		public func wrap() -> Wrapper {
			return Wrapper(animation: self)
		}



		public enum Timing {
			case EaseIn
			case EaseInEaseOut
			case EaseOut
			case Linear
			case Spring(initialVelocity: CGFloat, damping: CGFloat)
		}



		public final class Wrapper: NSObject {

			public let animation: Animation


			public init(animation: Animation) {
				self.animation = animation

				super.init()
			}
		}
	}
}
