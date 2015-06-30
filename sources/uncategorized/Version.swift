#if !FALLBACK
	import Foundation
#endif


public struct Version {

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
}


public extension Version {

	public init(_ version: NSOperatingSystemVersion) {
		self.init(major: version.majorVersion, minor: version.minorVersion, patch: version.patchVersion)
	}
}


extension Version: Comparable {}


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


public func == (a: Version, b: Version) -> Bool {
	return (a.major == b.major && a.minor == b.minor && a.patch == b.patch)
}


public func < (a: Version, b: Version) -> Bool {
	if a.major == b.major {
		if a.minor == b.minor {
			return a.patch < b.patch
		}

		return a.minor < b.minor
	}

	return a.major < b.major
}
