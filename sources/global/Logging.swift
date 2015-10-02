import Foundation


#if DEBUG
	public var logEnabled = true
#else
	public var logEnabled = false
#endif


public func log(@autoclosure message: Void throws -> String, function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) rethrows {
	if !logEnabled {
		return
	}

	let fileName = ((file.stringValue as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
	NSLog("%@", "\(fileName): \(try message())  (/\(function.stringValue):\(line))")
}
