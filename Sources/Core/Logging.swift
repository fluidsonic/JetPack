import Foundation


#if DEBUG
	public var logEnabled = true
#else
	public var logEnabled = false
#endif


public func log(_ messageClosure: @autoclosure (Void) throws -> String, function: StaticString = #function, file: StaticString = #file, line: UInt = #line) rethrows {
	if !logEnabled {
		return
	}

	let message = try messageClosure()
	let fileName = (String(describing: file) as NSString).lastPathComponent

	logWithoutContext("\(message) \t\t\t// \(fileName):\(line) in \(String(describing: function))")
}


public func logWithoutContext(_ messageClosure: @autoclosure (Void) throws -> String) rethrows {
	if !logEnabled {
		return
	}

	NSLog("%@", "\(try messageClosure())")
}
