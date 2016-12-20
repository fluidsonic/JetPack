import Foundation


public typealias ObservatoryExit = (Void) -> Bool


open class Observatory<Event> {

	public typealias Observer = (Event, ObservatoryExit) -> Void

	fileprivate typealias Subscription = ObservatorySubscription<Event>

	fileprivate var subscriptions = [Subscription]()


	/// Subscribes to events from this observatory and returns a closure which can be called to unsubscribe.
	///
	/// Getting 'expression resolves to an unused function' error when calling this method? You have to store the method's return value somewhere, even if temporary!
	open func enter(observer: @escaping Observer) -> ObservatoryExit {
		var subscription: Subscription?

		var exitedBefore = false
		let exit: ObservatoryExit = { [ weak self ] in
			var exited = false

			if !exitedBefore { // TODO temporary non-threadsafe hack since we cannot use dispatch_once
				exitedBefore = true

				if let observatory = self {
					observatory.subscriptions.removeFirstIdentical(subscription!)
					subscription = nil
				}

				exited = true
			}

			return exited
		}

		subscription = Subscription(observer: observer, exit: exit)
		subscriptions.append(subscription!)

		return exit
	}


	public init() {}


	open func notify(event: Event) {
		let subscriptions = self.subscriptions
		for subscription in subscriptions {
			subscription.notify(event: event)
		}
	}


	open var observerCount: Int {
		return subscriptions.count
	}
}



private class ObservatorySubscription<Event> {

	typealias Observer = (Event, ObservatoryExit) -> Void

	let exit:     ObservatoryExit
	let observer: Observer


	init(observer: @escaping Observer, exit: @escaping ObservatoryExit) {
		self.exit = exit
		self.observer = observer
	}


	func notify(event: Event) {
		observer(event, exit)
	}
}
