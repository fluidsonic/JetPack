import Foundation


public typealias ObservatoryExit = Void -> Bool


public class Observatory<Event> {

	public typealias Observer = (Event, ObservatoryExit) -> Void

	private typealias Subscription = ObservatorySubscription<Event>

	private var subscriptions = [Subscription]()


	/// Subscribes to events from this observatory and returns a closure which can be called to unsubscribe.
	///
	/// Getting 'expression resolves to an unused function' error when calling this method? You have to store the method's return value somewhere, even if temporary!
	public func enter(observer observer: Observer) -> ObservatoryExit {
		var subscription: Subscription?

		var exitToken: dispatch_once_t = 0
		let exit: ObservatoryExit = { [ weak self ] in
			var exited = false

			dispatch_once(&exitToken) {
				if let observatory = self {
					removeFirstIdentical(&observatory.subscriptions, element: subscription!)
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


	public func notify(event event: Event) {
		let subscriptions = self.subscriptions
		for subscription in subscriptions {
			subscription.notify(event: event)
		}
	}


	public var observerCount: Int {
		return subscriptions.count
	}
}



private class ObservatorySubscription<Event> {

	typealias Observer = (Event, ObservatoryExit) -> Void

	let exit:     ObservatoryExit
	let observer: Observer


	init(observer: Observer, exit: ObservatoryExit) {
		self.exit = exit
		self.observer = observer
	}


	func notify(event event: Event) {
		observer(event, exit)
	}
}
