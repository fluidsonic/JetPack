import Dispatch


public class EventBus {

	private let lock = EmptyObject()
	private var subscriptionsByScope = [ObjectIdentifier : AnySubscriptions]()


	public init() {}


	public func publish<T>(object: T) {
		synchronized(lock) {
			let scope = ObjectIdentifier(T.Type)

			if let subscriptions = subscriptionsByScope[scope] as! Subscriptions<T>? {
				for subscription in subscriptions.list {
					subscription.callback?(object)
				}
			}
		}
	}


	public func pool() -> Pool {
		return Pool(eventBus: self)
	}


	public func subscribe<T>(callback: (T) -> Void) -> Closure {
		return synchronized(lock) {
			let scope = ObjectIdentifier(T.Type)
			let subscription = Subscription(callback: callback)

			if let subscriptions = subscriptionsByScope[scope] as! Subscriptions<T>? {
				subscriptions.list.append(subscription)
			}
			else {
				let subscriptions = Subscriptions<T>()
				subscriptions.list.append(subscription)
				subscriptionsByScope[scope] = subscriptions
			}

			var unsubscribeToken: dispatch_once_t = 0

			return {
				dispatch_once(&unsubscribeToken) {
					synchronized(self.lock) {
						subscription.callback = nil

						if let subscriptions = self.subscriptionsByScope[scope] as! Subscriptions<T>? {
							subscriptions.list.removeFirstIdentical(subscription)

							if subscriptions.list.isEmpty {
								self.subscriptionsByScope[scope] = nil
							}
						}
					}
				}
			}
		}
	}



	public final class Pool {

		private let eventBus: EventBus
		private let lock = EmptyObject()
		private var unsubscribes = [Closure]()


		private init(eventBus: EventBus) {
			self.eventBus = eventBus
		}


		deinit {
			unsubscribeAll()
		}


		public func subscribe<T>(callback: (T) -> Void) {
			synchronized(lock) {
				unsubscribes.append(eventBus.subscribe(callback))
			}
		}


		public func unsubscribeAll() {
			synchronized(lock) {
				for unsubscribe in unsubscribes {
					unsubscribe()
				}

				unsubscribes.removeAll(keepCapacity: false)
			}
		}
	}
}



private class Subscription<T> {

	private var callback: (T -> Void)?


	private init(callback: T -> Void) {
		self.callback = callback
	}
}



private protocol AnySubscriptions {}

private class Subscriptions<T>: AnySubscriptions {

	private var list = [Subscription<T>]()
}
