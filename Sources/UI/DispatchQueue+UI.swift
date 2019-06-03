import Dispatch


public func assert(queue: DispatchQueue) {
	dispatchPrecondition(condition: .onQueue(queue))
}
