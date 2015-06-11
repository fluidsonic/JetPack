import Foundation


public final class File {

	private init() {} // static class for now


	public static func createTemporary(namePrefix: String = "", nameSuffix: String = "") -> NSURL? {
		let pathTemplate = NSTemporaryDirectory().stringByAppendingPathComponent("\(namePrefix)XXXXXXXXXX\(nameSuffix)")
		var cPath = pathTemplate.fileSystemRepresentation()

		let fileDescriptor: Int32

		if nameSuffix.isEmpty {
			fileDescriptor = mkstemp(&cPath)
		}
		else {
			fileDescriptor = mkstemps(&cPath, Int32(nameSuffix.fileSystemRepresentation().count))
		}

		if fileDescriptor == -1 {
			return nil
		}

		close(fileDescriptor)

		return NSURL(fileURLWithFileSystemRepresentation: cPath, isDirectory: false, relativeToURL: nil)
	}
}
