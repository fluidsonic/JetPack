import Foundation


@objc
internal protocol StaticInitializable {

	@objc
	static func staticInitialize()
}
