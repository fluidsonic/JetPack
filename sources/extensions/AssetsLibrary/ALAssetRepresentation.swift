import AssetsLibrary
import Foundation


public extension ALAssetRepresentation {

	public func saveToFile(file: NSURL, inout error: NSError?) -> Bool {
		precondition(file.fileURL, "URL must be a local file reference.")

		NSFileManager.defaultManager().createFileAtPath(file.path!, contents: nil, attributes: nil)

		if let handle = NSFileHandle(forWritingToURL: file, error: &error) {
			let bufferSize = 4 * 1024 * 1024
			let buffer = NSMutableData(length: bufferSize)!
			var bytesWritten: Int64 = 0
			let size = self.size()

			while bytesWritten < size {
				buffer.length = bufferSize

				let bytesRead = getBytes(UnsafeMutablePointer<UInt8>(buffer.mutableBytes), fromOffset: bytesWritten, length: bufferSize, error: &error)
				if bytesRead == 0 {
					handle.closeFile()
					return false
				}

				buffer.length = bytesRead
				handle.writeData(buffer)

				bytesWritten += bytesRead
			}

			handle.closeFile()
			return true
		}
		else {
			return false
		}
	}
}
