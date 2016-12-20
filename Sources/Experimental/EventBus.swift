import Dispatch


open class EventBus {

	fileprivate let lock = EmptyObject()
	fileprivate var subscriptionsByScope = [ObjectIdentifier : AnySubscriptions]()


	public init() {}


	open func publish<T>(_ object: T) {
		synchronized(lock) {
			let scope = ObjectIdentifier(T.Type.self)

			if let subscriptions = subscriptionsByScope[scope] as! Subscriptions<T>? {
				for subscription in subscriptions.list {
					subscription.callback?(object)
				}
			}
		}
	}


	open func pool() -> Pool {
		return Pool(eventBus: self)
	}


	open func subscribe<Event>(for consumer: Consumer, callback: @escaping (Event) -> Void) {
		consumer.subscribe(to: self, callback: callback)
	}


	open func subscribe<Event>(_ callback: @escaping (Event) -> Void) -> Closure {
		return synchronized(lock) {
			let scope = ObjectIdentifier(Event.Type.self)
			let subscription = Subscription(callback: callback)

			if let subscriptions = subscriptionsByScope[scope] as! Subscriptions<Event>? {
				subscriptions.list.append(subscription)
			}
			else {
				let subscriptions = Subscriptions<Event>()
				subscriptions.list.append(subscription)
				subscriptionsByScope[scope] = subscriptions
			}

			return {
				synchronized(self.lock) {
					guard subscription.callback != nil else {
						return
					}

					subscription.callback = nil

					if let subscriptions = self.subscriptionsByScope[scope] as! Subscriptions<Event>? {
						subscriptions.list.removeFirstIdentical(subscription)

						if subscriptions.list.isEmpty {
							self.subscriptionsByScope[scope] = nil
						}
					}
				}
			}
		}
	}



	public final class Consumer {

		fileprivate let lock = EmptyObject()
		fileprivate var unsubscribes = [Closure]()


		public init() {}


		deinit {
			unsubscribeAll()
		}


		public func subscribe<Event>(to eventBus: EventBus, callback: @escaping (Event) -> Void) {
			synchronized(lock) {
				unsubscribes.append(eventBus.subscribe(callback))
			}
		}


		public func unsubscribeAll() {
			synchronized(lock) {
				for unsubscribe in unsubscribes {
					unsubscribe()
				}

				unsubscribes.removeAll(keepingCapacity: false)
			}
		}
	}



	public final class Pool {

		fileprivate let eventBus: EventBus
		fileprivate let lock = EmptyObject()
		fileprivate var unsubscribes = [Closure]()


		fileprivate init(eventBus: EventBus) {
			self.eventBus = eventBus
		}


		deinit {
			unsubscribeAll()
		}


		public func subscribe<T>(_ callback: @escaping (T) -> Void) {
			synchronized(lock) {
				unsubscribes.append(eventBus.subscribe(callback))
			}
		}


		public func unsubscribeAll() {
			synchronized(lock) {
				for unsubscribe in unsubscribes {
					unsubscribe()
				}

				unsubscribes.removeAll(keepingCapacity: false)
			}
		}
	}
}



private class Subscription<T> {

	fileprivate var callback: ((T) -> Void)?


	fileprivate init(callback: @escaping (T) -> Void) {
		self.callback = callback
	}
}



private protocol AnySubscriptions {}

private class Subscriptions<T>: AnySubscriptions {

	fileprivate var list = [Subscription<T>]()
}
