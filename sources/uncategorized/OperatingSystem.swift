#if !FALLBACK
	import Foundation
	import UIKit
#endif

public let operatingSystem = OperatingSystem()


public struct OperatingSystem {

	public let version: Version


	private init() {
		if NSProcessInfo.instancesRespondToSelector("operatingSystemVersion") {
			version = Version(NSProcessInfo().operatingSystemVersion)
		}
		else {
			let versionComponents = UIDevice.currentDevice().systemVersion.componentsSeparatedByString(".")
			let majorVersion = versionComponents[0].toInt()!
			let minorVersion = (versionComponents.count >= 2 ? versionComponents[1].toInt()! : 0)
			let patchVersion = (versionComponents.count >= 3 ? versionComponents[2].toInt()! : 0)

			version = Version(major: majorVersion, minor: minorVersion, patch: patchVersion)
		}
	}
}
