import Foundation
import UIKit

public let operatingSystem = OperatingSystem()


public struct OperatingSystem {

	public let version: Version


	fileprivate init() {
		version = Version(ProcessInfo().operatingSystemVersion)
	}
}
