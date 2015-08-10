import Foundation

#if DEBUG
	public var LOGenabled = true
#else
	public var LOGenabled = false
#endif


public func LOG(@autoclosure message: () -> String, function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) {
	if !LOGenabled {
		return
	}

	let fileName = ((file.stringValue as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
	NSLog("%@", "\(fileName)/\(function.stringValue):\(line) | \(message())")
}


// temporary workaround for lack of #warning instruction
public func WARN(@autoclosure message: () -> String, function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) {
	if !LOGenabled {
		return
	}

	LOG("Warning: \(message())", function: function, file: file, line: line)
}
