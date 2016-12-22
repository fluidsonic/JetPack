import Foundation


public struct OperatingSystem {

	public static let instance = OperatingSystem()

	public let version: Version


	private init() {
		version = Version(ProcessInfo().operatingSystemVersion)
	}
}
