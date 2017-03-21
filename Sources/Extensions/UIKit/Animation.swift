import UIKit


public struct Animation {

	public typealias Completion = (_ finished: Bool) -> Void
	public typealias CompletionRegistration = (@escaping Completion) -> Void

	public var allowsUserInteraction = false
	public var autoreverses = false
	public var beginsFromCurrentState = false
	public var delay = TimeInterval(0)
	public var duration: TimeInterval
	public var layoutsSubviews = false
	public var overridesInheritedDuration = false
	public var overridesInheritedOptions = false
	public var overridesInheritedTiming = false
	public var repeats = false
	public var timing: Timing

	public private(set) static var current: Animation?


	public init(duration: TimeInterval = 0.3, timing: Timing = .spring(initialVelocity: 0, damping: 1)) {
		self.duration = duration
		self.timing = timing
	}


	public static func ignore(_ changes: Closure) {
		UIView.performWithoutAnimation(changes)
	}


	public func run(_ changes: (Void) -> Void) {
		runWithCompletion { _ in changes() }
	}


	public func runWithCompletion(_ changes: (_ complete: CompletionRegistration) -> Void) {
		let outerAnimation = Animation.current
		Animation.current = self
		defer { Animation.current = outerAnimation }

		var completions = [Completion]()

		var options = UIViewAnimationOptions()
		if allowsUserInteraction {
			options.insert(.allowUserInteraction)
		}
		if autoreverses {
			options.insert(.autoreverse)
		}
		if beginsFromCurrentState {
			options.insert(.beginFromCurrentState)
		}
		if layoutsSubviews {
			options.insert(.layoutSubviews)
		}
		if overridesInheritedDuration {
			options.insert(.overrideInheritedDuration)
		}
		if overridesInheritedOptions {
			options.insert(.overrideInheritedOptions)
		}
		if overridesInheritedTiming {
			options.insert(.overrideInheritedCurve)
		}
		if repeats {
			options.insert(.repeat)
		}


		let escapableChanges = makeEscapable(changes)

		func performChanges() {
			escapableChanges() { completion in
				completions.append(completion)
			}
		}


		func completion(_ finished: Bool) {
			for completion in completions {
				completion(finished)
			}
		}

		let curveOptions: UIViewAnimationOptions?

		switch timing {
		case .easeIn:           curveOptions = .curveEaseIn
		case .easeInEaseOut:    curveOptions = UIViewAnimationOptions()
		case .easeOut:          curveOptions = .curveEaseOut
		case .linear:           curveOptions = .curveLinear
		case let .curve(curve): curveOptions = UIViewAnimationOptions(curve: curve)

		case let .spring(initialVelocity, damping):
			curveOptions = nil
			UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: options, animations: performChanges, completion: completion)
		}

		if let curveOptions = curveOptions {
			options.insert(curveOptions)
			UIView.animate(withDuration: duration, delay: delay, options: options, animations: performChanges, completion: completion)
		}
	}


	public func wrap() -> Wrapper {
		return Wrapper(animation: self)
	}



	public enum Timing {
		case easeIn
		case easeInEaseOut
		case easeOut
		case linear
		case curve(UIViewAnimationCurve)
		case spring(initialVelocity: CGFloat, damping: CGFloat)
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
		description += String(describing: timing)
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
		case .easeIn:                               return "Timing.EaseIn"
		case .easeInEaseOut:                        return "Timing.EaseInEaseOut"
		case .easeOut:                              return "Timing.EaseOut"
		case .linear:                               return "Timing.Linear"
		case let .curve(curve):                     return "Timing.Curve(\(curve))"
		case let .spring(initialVelocity, damping): return "Timing.Spring(initialVelocity: \(initialVelocity), damping: \(damping))"
		}
	}
}



extension _Optional where Wrapped == Animation {

	public func runAlways(_ changes: (Void) -> Void) {
		if let animation = value {
			animation.run(changes)
		}
		else {
			changes()
		}
	}


	public func runAlwaysWithCompletion(_ changes: (_ complete: Animation.CompletionRegistration) -> Void) {
		if let animation = value {
			animation.runWithCompletion(changes)
		}
		else {
			var completions = Array<Animation.Completion>()

			changes { completion in
				completions.append(completion)
			}

			for completion in completions {
				completion(true)
			}
		}
	}
}
