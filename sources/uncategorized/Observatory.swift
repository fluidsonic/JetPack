import Foundation


typealias ObservatoryExit = Void -> Bool


class Observatory<Event> {

	typealias Observer = (Event, ObservatoryExit) -> Void

	private typealias Subscription = ObservatorySubscription<Event>

	private var subscriptions = [Subscription]()


	/// Subscribes to events from this observatory and returns a closure which can be called to unsubscribe.
	///
	/// Getting 'expression resolves to an unused function' error when calling this method? You have to store the method's return value somewhere, even if temporary!
	func enter(#observer: Observer) -> ObservatoryExit {
		var subscription: Subscription?

		var exitToken: dispatch_once_t = 0
		let exit: ObservatoryExit = { [ weak self ] in
			var exited = false

			dispatch_once(&exitToken) {
				if let observatory = self {
					removeFirstIdentical(&observatory.subscriptions, subscription!)
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


	func notify(#event: Event) {
		let subscriptions = self.subscriptions
		for subscription in subscriptions {
			subscription.notify(event: event)
		}
	}


	var observerCount: Int {
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


	func notify(#event: Event) {
		observer(event, exit)
	}
}
