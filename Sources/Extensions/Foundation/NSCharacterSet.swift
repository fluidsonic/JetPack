import Foundation


public extension CharacterSet {

	@nonobjc
	fileprivate static let _URLPathComponentAllowedCharacterSet: CharacterSet = {
		let characterSet = NSMutableCharacterSet()
		characterSet.formUnion(with: CharacterSet.urlPathAllowed)
		characterSet.removeCharacters(in: "/")

		return characterSet.copy() as! CharacterSet
	}()


	@nonobjc
	fileprivate static let _URLQueryParameterAllowedCharacterSet: CharacterSet = {
		let characterSet = NSMutableCharacterSet()
		characterSet.formUnion(with: CharacterSet.urlQueryAllowed)
		characterSet.removeCharacters(in: "+&=")

		return characterSet.copy() as! CharacterSet
	}()


	
	
	static func URLPathComponentAllowedCharacterSet() -> CharacterSet {
		return _URLPathComponentAllowedCharacterSet
	}


	
	
	static func URLQueryParameterAllowedCharacterSet() -> CharacterSet {
		return _URLQueryParameterAllowedCharacterSet
	}
}
