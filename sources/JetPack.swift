// Swift Limitation & Bug Workarounds with Direct Inclusion

/*
 * This file must be added to the app project manually as the functionality it provides
 * is not available through Frameworks at the moment due to bugs & limitations of Swift.
 *
 * Last checked with Xcode 6.1 GM 2.
 */

import JetPack


// Array.swift: compiler doesn't allow public extension on generic class

extension Array {

	func separate(isLeftElement: T -> Bool) -> ([T], [T]) {
		return JetPack.separate(self, isLeftElement)
	}
}


// CGRect.swift: compiler doesn't allow Framework extensions to add setters to existing computed vars or overwrite them completely

import CoreGraphics


extension CGRect {

	var height: CGFloat {
		get { return size.height }
		mutating set { size.height = newValue }
	}

	var width: CGFloat {
		get { return size.width }
		mutating set { size.width = newValue }
	}
}


// Dictionary.swift: compiler doesn't allow public extension on generic class

extension Dictionary {

	mutating func mapValues(transform: Value -> Value) {
		for (key, value) in self {
			self[key] = transform(value)
		}
	}


	func mapped<K : Hashable, V>(transform: (Key, Value) -> (K, V)) -> [K : V] {
		var mappedDictionary = [K : V](minimumCapacity: count)
		for (key, value) in self {
			let (mappedKey, mappedValue) = transform(key, value)
			mappedDictionary[mappedKey] = mappedValue
		}

		return mappedDictionary
	}
}
