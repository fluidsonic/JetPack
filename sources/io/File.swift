import Foundation


public final class File {

	private init() {} // static class for now


	public static func createTemporary(namePrefix: String = "") -> NSURL? {
		let pathTemplate = NSTemporaryDirectory().stringByAppendingPathComponent("\(namePrefix)XXXXXXXXXX")
		var cPath = pathTemplate.fileSystemRepresentation()

		let fileDescriptor = mkstemp(&cPath)
		if fileDescriptor == -1 {
			return nil
		}

		close(fileDescriptor)

		return NSURL(fileURLWithFileSystemRepresentation: cPath, isDirectory: false, relativeToURL: nil)
	}
}
