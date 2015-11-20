import UIKit


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


	public static func ignore(@noescape changes: Closure) {
		UIView.performWithoutAnimation(makeEscapable(changes))
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


	public static func runWithCompletion(animation: Animation?, @noescape changes: (complete: CompletionRegistration) -> Void) {
		if let animation = animation {
			animation.runWithCompletion(changes)
		}
		else {
			var completions = [Completion]()

			changes { completion in
				completions.append(completion)
			}

			for completion in completions {
				completion(finished: true)
			}
		}
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

		let curveOptions: UIViewAnimationOptions?

		switch timing {
		case .EaseIn:           curveOptions = .CurveEaseIn
		case .EaseInEaseOut:    curveOptions = .CurveEaseInOut
		case .EaseOut:          curveOptions = .CurveEaseOut
		case .Linear:           curveOptions = .CurveLinear
		case let .Curve(curve): curveOptions = UIViewAnimationOptions(curve: curve)

		case let .Spring(initialVelocity, damping):
			curveOptions = nil
			UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: options, animations: performChanges, completion: completion)
		}

		if let curveOptions = curveOptions {
			options.insert(curveOptions)
			UIView.animateWithDuration(duration, delay: delay, options: options, animations: performChanges, completion: completion)
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
		case Curve(UIViewAnimationCurve)
		case Spring(initialVelocity: CGFloat, damping: CGFloat)
	}



	public final class Wrapper: NSObject {

		public let animation: Animation


		public init(animation: Animation) {
			self.animation = animation

			super.init()
		}


		public override var description: String {
			return animation.description
		}
	}
}


extension Animation: CustomStringConvertible {

	public var description: String {
		var description = "Animation(duration: "
		description += String(duration)
		description += ", timing: "
		description += String(timing)
		if allowsUserInteraction {
			description += ", allowsUserInteraction: true"
		}
		if autoreverses {
			description += ", autoreverses: true"
		}
		if beginsFromCurrentState {
			description += ", beginsFromCurrentState: true"
		}
		if delay != 0 {
			description += ", delay: "
			description += String(delay)
		}
		if layoutsSubviews {
			description += ", layoutsSubviews: true"
		}
		if overridesInheritedDuration {
			description += ", overridesInheritedDuration: true"
		}
		if overridesInheritedOptions {
			description += ", overridesInheritedOptions: true"
		}
		if overridesInheritedTiming {
			description += ", overridesInheritedTiming: true"
		}
		if repeats {
			description += ", repeats: true"
		}
		description += ")"

		return description
	}
}


extension Animation.Timing: CustomStringConvertible {

	public var description: String {
		switch self {
		case .EaseIn:                               return "Timing.EaseIn"
		case .EaseInEaseOut:                        return "Timing.EaseInEaseOut"
		case .EaseOut:                              return "Timing.EaseOut"
		case .Linear:                               return "Timing.Linear"
		case let .Curve(curve):                     return "Timing.Curve(\(curve))"
		case let .Spring(initialVelocity, damping): return "Timing.Spring(initialVelocity: \(initialVelocity), damping: \(damping))"
		}
	}
}
