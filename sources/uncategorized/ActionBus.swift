public class ActionBus {

	private var handlersByActionId = [ObjectIdentifier : AnyActionHandler]()
	private let lock = EmptyObject()



	public init() {}


	public func handle<A: Action>(run: (A) -> A.ResultType) -> Block {
		return synchronized(lock) {
			let actionId = ObjectIdentifier(A.Type)
			let handler = ActionHandler(run: run)

			if let previousHandler = handlersByActionId.updateValue(handler, forKey: actionId) {
				preconditionFailure("Cannot provide multiple handlers for action `\(A.self)!")
			}

			var unsubscribeToken: dispatch_once_t = 0

			return {
				dispatch_once(&unsubscribeToken) {
					synchronized(self.lock) {
						if let currentHandler = self.handlersByActionId[actionId] as! ActionHandler<A>? where currentHandler === handler {
							self.handlersByActionId[actionId] = nil
						}
					}
				}
			}
		}
	}


	public func pool() -> Pool {
		return Pool(actionBus: self)
	}


	public func run<A: Action>(action: A) -> A.ResultType {
		return synchronized(lock) {
			let actionId = ObjectIdentifier(A.Type)

			if let actionHandler = handlersByActionId[actionId] as! ActionHandler<A>? {
				return actionHandler.run(action)
			}
			else {
				preconditionFailure("No handler provided for action `\(action)`!")
			}
		}
	}



	public final class Pool {

		private let actionBus: ActionBus
		private let lock = EmptyObject()
		private var removalCallbacks = [Block]()


		private init(actionBus: ActionBus) {
			self.actionBus = actionBus
		}


		deinit {
			removeAll()
		}


		public func handle<A: Action>(run: (A) -> A.ResultType) {
			synchronized(lock) {
				removalCallbacks.append(actionBus.handle(run))
			}
		}


		public func removeAll() {
			synchronized(lock) {
				for removalCallback in removalCallbacks {
					removalCallback()
				}

				removalCallbacks.removeAll(keepCapacity: false)
			}
		}
	}
}


public protocol Action {

	typealias ResultType = Void
}


private protocol AnyActionHandler {}

private class ActionHandler<A: Action>: AnyActionHandler {

	private let run: (A) -> A.ResultType


	private init(run: (A) -> A.ResultType) {
		self.run = run
	}
}
