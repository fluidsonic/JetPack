import Foundation


public enum File {
	
	public static func createTemporary(namePrefix: String = "", nameSuffix: String = "") -> URL? {
		let pathTemplate = (NSTemporaryDirectory() as NSString).appendingPathComponent("\(namePrefix)XXXXXXXXXX\(nameSuffix)") as NSString
		
		let path = UnsafeMutablePointer<Int8>.allocate(capacity: Int(PATH_MAX))
		defer {
			path.deallocate(capacity: Int(PATH_MAX))
			path.deinitialize()
		}

		pathTemplate.getFileSystemRepresentation(path, maxLength: Int(PATH_MAX))

		let fileDescriptor = nameSuffix.isEmpty ? mkstemp(path) : mkstemps(path, Int32(strlen(nameSuffix)))
		if fileDescriptor == -1 {
			return nil
		}

		close(fileDescriptor)

		return URL(fileURLWithFileSystemRepresentation: path, isDirectory: false, relativeTo: nil)
	}
}
