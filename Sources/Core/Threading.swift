import Foundation


public func onBackgroundQueue(execute work: @escaping Closure) {
	onBackgroundQueue(qos: .default, execute: work)
}


public func onBackgroundQueue(qos: DispatchQoS.QoSClass, execute work: @escaping Closure) {
	DispatchQueue.global(qos: qos).async(execute: work)
}


public func onMainQueue(execute work: @escaping Closure) {
	DispatchQueue.main.async(execute: work)
}


public func onMainQueue(after delay: TimeInterval, execute work: @escaping Closure) {
	DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
}
