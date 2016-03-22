import Foundation


public extension NSFileManager {

	@nonobjc
	public func asyncRemoveItem(item: NSURL, handler: (Result<Void> -> Void)? = nil) {
		asyncWithHandler(handler, errorMessage: "Cannot remove item '\(item)'") {
			return try self.removeItemAtURL(item)
		}
	}


	@nonobjc
	private func asyncWithHandler <ValueType> (handler: (Result<ValueType> -> Void)?, @autoclosure(escaping) errorMessage: Void -> String, action: Void throws -> ValueType) {
		onBackgroundQueueOfPriority(.Low) {
			do {
				let value = try action()
				handler?(.Success(value))
			}
			catch let error {
				return self.reportError(error, withMessage: errorMessage(), toHandler: handler)
			}
		}
	}


	@nonobjc
	private func reportError <ValueType> (error: ErrorType, @autoclosure withMessage message: Void -> String, function: StaticString = #function, file: StaticString = #file, line: UInt = #line, toHandler handler: (Result<ValueType> -> Void)?) {
		guard let handler = handler else {
			log("'\(message())': \(error)", function: function, file: file, line: line)
			return
		}

		handler(.Failure(error))
	}
}
