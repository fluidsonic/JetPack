public func LOG(_ message: (@autoclosure () -> String)? = nil, function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UWord = __LINE__) {
	#if LOG
		let fileName = file.stringValue.lastPathComponent.stringByDeletingPathExtension

		let evaluatedMessage = message?()
		if let evaluatedMessage = evaluatedMessage {
			NSLog("%@", "\(fileName)/\(function.stringValue):\(line) | \(evaluatedMessage)")
		}
		else {
			NSLog("%@", "\(fileName)/\(function.stringValue):\(line)")
		}
	#endif
}


public func WARN(_ message: (@autoclosure () -> String)? = nil, function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UWord = __LINE__) {
	#if LOG
		let evaluatedMessage = message?()
		if let evaluatedMessage = evaluatedMessage {
			LOG("Warning: \(evaluatedMessage)", function: function, file: file, line: line)
		}
		else {
			LOG("Warning!", function: function, file: file, line: line)
		}
	#endif
}
