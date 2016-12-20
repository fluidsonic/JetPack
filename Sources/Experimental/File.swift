import Foundation


public struct File {

	fileprivate init() {} // static for now


	
	public static func createTemporary(_ namePrefix: String = "", nameSuffix: String = "") -> URL? {
		let pathTemplate: NSString = (NSTemporaryDirectory() as NSString).appendingPathComponent("\(namePrefix)XXXXXXXXXX\(nameSuffix)") as NSString
		
		let path = UnsafeMutablePointer<Int8>.allocate(capacity: Int(PATH_MAX))
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

		let fileUrl = URL(fileURLWithFileSystemRepresentation: path, isDirectory: false, relativeTo: nil)
		
		path.deallocate(capacity: Int(PATH_MAX))
		path.deinitialize()
		
		return fileUrl
	}
}
