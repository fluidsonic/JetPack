import Foundation
import UIKit

public let operatingSystem = OperatingSystem()


public struct OperatingSystem {

	public let version: Version


	private init() {
		if NSProcessInfo.instancesRespondToSelector("operatingSystemVersion") {
			version = Version(NSProcessInfo().operatingSystemVersion)
		}
		else {
			let versionComponents = UIDevice.currentDevice().systemVersion.componentsSeparatedByString(".")
			let majorVersion = Int(versionComponents[0])!
			let minorVersion = (versionComponents.count >= 2 ? Int(versionComponents[1])! : 0)
			let patchVersion = (versionComponents.count >= 3 ? Int(versionComponents[2])! : 0)

			version = Version(major: majorVersion, minor: minorVersion, patch: patchVersion)
		}
	}
}
