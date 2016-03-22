import Foundation
import UIKit

public let operatingSystem = OperatingSystem()


public struct OperatingSystem {

	public let version: Version


	private init() {
		version = Version(NSProcessInfo().operatingSystemVersion)
	}
}
