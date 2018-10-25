import Foundation


#if DEBUG
	public var logEnabled = true
#else
	public var logEnabled = false
#endif


public func log(_ messageClosure: @autoclosure () throws -> String, function: StaticString = #function, file: StaticString = #file, line: UInt = #line) rethrows {
	if !logEnabled {
		return
	}

	let message = try messageClosure()
	let fileName = (String(describing: file) as NSString).lastPathComponent

	logWithoutContext("\(message) \t\t\t// \(fileName):\(line) in \(String(describing: function))")
}


public func logWithoutContext(_ messageClosure: @autoclosure () throws -> String) rethrows {
	if !logEnabled {
		return
	}

	let maximumLineLength = 800

	let lines = try messageClosure()
		.split(separator: "\n")
		.flatMap { (line: Substring) -> [String] in
			let line = Array(line)
			let lineLength = line.count

			let sublines = stride(from: 0, to: lineLength, by: maximumLineLength)
				.map { lineOffset in
					return line[lineOffset ..< min(lineOffset + maximumLineLength, lineLength)]
				}

			return sublines
				.enumerated()
				.map { index, line in
					if index < sublines.count - 1 {
						return String(line + "⏎")
					}
					else {
						return String(line)
					}
				}
	}

	for line in lines {
		NSLog("%@", line)
	}
}
