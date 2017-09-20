import Foundation


public struct Version {

	public static let zero = Version(major: 0, minor: 0, patch: 0)

	public var major: Int
	public var minor: Int
	public var patch: Int


	public init(major: Int, minor: Int, patch: Int) {
		precondition(major >= 0, "`major` must not be negative")
		precondition(minor >= 0, "`minor` must not be negative")
		precondition(patch >= 0, "`patch` must not be negative")

		self.major = major
		self.minor = minor
		self.patch = patch
	}


	public init(_ version: OperatingSystemVersion) {
		self.init(major: version.majorVersion, minor: version.minorVersion, patch: version.patchVersion)
	}


	public init?(_ version: String) {
		let components = version.components(separatedBy: ".")
		guard
			(1 ... 3).contains(components.count),
			let major = Int(components[0]),
			let minor = components.count >= 2 ? Int(components[1]) : 0,
			let patch = components.count >= 3 ? Int(components[2]) : 0
		else {
			return nil
		}

		self.init(major: major, minor: minor, patch: patch)
	}
}


extension Version: Comparable {

	public static func == (a: Version, b: Version) -> Bool {
		return (a.major == b.major && a.minor == b.minor && a.patch == b.patch)
	}


	public static func < (a: Version, b: Version) -> Bool {
		if a.major == b.major {
			if a.minor == b.minor {
				return a.patch < b.patch
			}

			return a.minor < b.minor
		}

		return a.major < b.major
	}
}


extension Version: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "Version(\(description))"
	}
}


extension Version: CustomStringConvertible {

	public var description: String {
		if patch > 0 {
			return "\(major).\(minor).\(patch)"
		}

		return "\(major).\(minor)"
	}
}
