import Foundation


open class AsyncOperation: Operation {

	private var _executing = false
	private var _finished = false


	public final override var isAsynchronous: Bool {
		return true
	}


	public final override var isExecuting: Bool {
		return _executing
	}


	private func finish() {
		guard _executing else {
			fatalError("Completion closure called while not executing")
		}

		willChangeValue(forKey: "isExecuting")
		_executing = false
		didChangeValue(forKey: "isExecuting")

		willChangeValue(forKey: "isFinished")
		_finished = true
		didChangeValue(forKey: "isFinished")
	}


	public final override var isFinished: Bool {
		return _finished
	}


	@available(*, unavailable, renamed: "mainWithCompletion")
	public final override func main() {
		// no-op
	}


	open func mainWithCompletion(_ completion: @escaping Closure) {
		completion()
	}


	public final override func start() {
		guard !isCancelled else {
			return
		}
		guard !_executing && !_finished else {
			fatalError("Operation is already executing or finished.")
		}

		willChangeValue(forKey: "isExecuting")
		_executing = true
		didChangeValue(forKey: "isExecuting")

		mainWithCompletion { [weak self] in
			self?.finish()
		}
	}
}
