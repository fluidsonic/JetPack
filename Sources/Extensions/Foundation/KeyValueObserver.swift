import Foundation

// This is workaround so that we don't have to implement observeValue(forKeyPath:of:change:context:) in public classes directly due to
// https://bugs.swift.org/browse/SR-4266


internal protocol KeyValueObserver: class {

	func valueChangeObserved(forKeyPath keyPath: String, of object: Any, change: [NSKeyValueChangeKey : Any], context: UnsafeMutableRawPointer?)
}



internal class KeyValueObserverProxy: NSObject {

	private unowned let observer: KeyValueObserver


	internal init(observer: KeyValueObserver) {
		self.observer = observer
	}


	internal override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard let keyPath = keyPath, let object = object, let change = change else {
			return
		}

		observer.valueChangeObserved(forKeyPath: keyPath, of: object, change: change, context: context)
	}
}
