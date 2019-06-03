import Foundation


public typealias ObservatoryExit = Closure


open class Observatory<Event> {

	public typealias Observer = (Event, ObservatoryExit) -> Void

	private typealias Subscription = ObservatorySubscription<Event>

	private var subscriptions = [Subscription]()


	/// Subscribes to events from this observatory and returns a closure which can be called to unsubscribe.
	///
	/// Getting 'expression resolves to an unused function' error when calling this method? You have to store the method's return value somewhere, even if temporary!
	open func enter(observer: @escaping Observer) -> ObservatoryExit {
		var subscription: Subscription?

		var exitedBefore = false
		let exit: ObservatoryExit = { [ weak self ] in
			if !exitedBefore { // TODO temporary non-threadsafe hack since we cannot use dispatch_once
				exitedBefore = true

				if let observatory = self {
					observatory.subscriptions.removeFirstIdentical(subscription!)
					subscription = nil
				}
			}
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



fileprivate class ObservatorySubscription<Event> {

	fileprivate typealias Observer = (Event, ObservatoryExit) -> Void

	fileprivate let exit: ObservatoryExit
	fileprivate let observer: Observer


	fileprivate init(observer: @escaping Observer, exit: @escaping ObservatoryExit) {
		self.exit = exit
		self.observer = observer
	}


	fileprivate func notify(event: Event) {
		observer(event, exit)
	}
}
