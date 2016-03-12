import Foundation


public /* non-final */ class AsyncOperation: NSOperation {

	private var _executing = false
	private var _finished = false


	public final override var asynchronous: Bool {
		return true
	}


	public final override var executing: Bool {
		return _executing
	}


	private func finish() {
		guard _executing else {
			fatalError("Completion closure called while not executing")
		}

		willChangeValueForKey("isExecuting")
		_executing = false
		didChangeValueForKey("isExecuting")

		willChangeValueForKey("isFinished")
		_finished = true
		didChangeValueForKey("isFinished")
	}


	public final override var finished: Bool {
		return _finished
	}


	@available(*, unavailable, renamed="mainWithCompletion")
	public final override func main() {
		// no-op
	}


	public func mainWithCompletion(completion: Closure) {
		completion()
	}


	public final override func start() {
		guard !cancelled else {
			return
		}
		guard !_executing && !_finished else {
			fatalError("Operation is already executing or finished.")
		}

		willChangeValueForKey("isExecuting")
		_executing = true
		didChangeValueForKey("isExecuting")

		mainWithCompletion { [weak self] in
			self?.finish()
		}
	}
}
