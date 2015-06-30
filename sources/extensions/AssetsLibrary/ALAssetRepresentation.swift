import AssetsLibrary
import Foundation


public extension ALAssetRepresentation {

	public func saveToFile(file: NSURL) throws {
		precondition(file.fileURL, "URL must be a local file reference.")

		NSFileManager.defaultManager().createFileAtPath(file.path!, contents: nil, attributes: nil)

		let handle = try NSFileHandle(forWritingToURL: file)
		let bufferSize = 4 * 1024 * 1024
		let buffer = NSMutableData(length: bufferSize)!
		let size = self.size()
		var bytesWritten = Int64(0)
		var error: NSError?

		while bytesWritten < size {
			buffer.length = bufferSize

			let bytesRead = getBytes(UnsafeMutablePointer<UInt8>(buffer.mutableBytes), fromOffset: bytesWritten, length: bufferSize, error: &error)
			if bytesRead == 0 {
				handle.closeFile()
				throw error!
			}

			buffer.length = bytesRead
			handle.writeData(buffer)

			bytesWritten += bytesRead
		}

		handle.closeFile()
	}
}
