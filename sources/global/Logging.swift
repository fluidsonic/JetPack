import Foundation

#if DEBUG
	public var LOGenabled = true
#else
	public var LOGenabled = false
#endif


public func LOG(_ message: (@autoclosure () -> String)? = nil, function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UWord = __LINE__) {
	if !LOGenabled {
		return
	}

	let fileName = file.stringValue.lastPathComponent.stringByDeletingPathExtension

	let evaluatedMessage = message?()
	if let evaluatedMessage = evaluatedMessage {
		NSLog("%@", "\(fileName)/\(function.stringValue):\(line) | \(evaluatedMessage)")
	}
	else {
		NSLog("%@", "\(fileName)/\(function.stringValue):\(line)")
	}
}


// temporary workaround for lack of #warning instruction
public func WARN(_ message: (@autoclosure () -> String)? = nil, function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UWord = __LINE__) {
	if !LOGenabled {
		return
	}

	let evaluatedMessage = message?()
	if let evaluatedMessage = evaluatedMessage {
		LOG("Warning: \(evaluatedMessage)", function: function, file: file, line: line)
	}
	else {
		LOG("Warning!", function: function, file: file, line: line)
	}
}
