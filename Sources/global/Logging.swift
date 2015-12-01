import Foundation


#if DEBUG
	public var logEnabled = true
#else
	public var logEnabled = false
#endif


public func log(@autoclosure messageClosure: Void throws -> String, function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) rethrows {
	if !logEnabled {
		return
	}

	let message = try messageClosure()
	let fileName = (file.stringValue as NSString).lastPathComponent

	NSLog("%@", "\(message) \t\t\t// \(fileName):\(line) in \(function.stringValue)")
}
