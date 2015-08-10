import Foundation


public final class File {

	private init() {} // static class for now


	public static func createTemporary(namePrefix: String = "", nameSuffix: String = "") -> NSURL? {
		let pathTemplate: NSString = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("\(namePrefix)XXXXXXXXXX\(nameSuffix)")
		
		let path = UnsafeMutablePointer<Int8>.alloc(Int(PATH_MAX))
		pathTemplate.getFileSystemRepresentation(path, maxLength: Int(PATH_MAX))
		
		let fileDescriptor: Int32

		if nameSuffix.isEmpty {
			fileDescriptor = mkstemp(path)
		}
		else {
			fileDescriptor = mkstemps(path, Int32(strlen(nameSuffix)))
		}

		if fileDescriptor == -1 {
			return nil
		}

		close(fileDescriptor)

		let fileUrl = NSURL(fileURLWithFileSystemRepresentation: path, isDirectory: false, relativeToURL: nil)
		
		path.dealloc(Int(PATH_MAX))
		path.destroy()
		
		return fileUrl
	}
}
