public struct PhoneNumber {

	public var digits: Digits
	public var localCountry: Country?


	public init(digits: Digits, localCountry: Country? = nil) {
		self.digits = digits
		self.localCountry = localCountry
	}


	public init(digits: String, localCountry: Country? = nil) {
		self.init(digits: Digits(digits), localCountry: localCountry)
	}


	public var country: Country? {
		return Country(phoneNumber: digits) ?? localCountry
	}


	public var isEmpty: Bool {
		return digits.isEmpty
	}



	public enum Digit: Character {
		case _0         = "0"
		case _1         = "1"
		case _2         = "2"
		case _3         = "3"
		case _4         = "4"
		case _5         = "5"
		case _6         = "6"
		case _7         = "7"
		case _8         = "8"
		case _9         = "9"
		case NumberSign = "#"
		case Plus       = "+"
		case Star       = "*"


		public init?(character: Character) {
			self.init(rawValue: character)
		}


		public var character: Character {
			return rawValue
		}
	}



	public struct Digits {

		public typealias Digit = PhoneNumber.Digit

		private var values: [Digit]


		public init() {
			values = []
		}


		public init(_ array: [Digit]) {
			values = array
		}


		public init <Sequence: SequenceType where Sequence.Generator.Element == Digit>(_ sequence: Sequence) {
			values = Array(sequence)
		}


		public init(_ string: String) {
			values = string.characters.map({ Digit(character: $0) }).filterNonNil()
		}


		public var string: String {
			return String(values.map({ $0.character }))
		}
	}
}


extension PhoneNumber: CustomStringConvertible {

	public var description: String {
		return digits.description
	}
}


extension PhoneNumber: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "PhoneNumber(digits: \"\(digits)\", localCountry: \(localCountry)"
	}
}


extension PhoneNumber: Hashable {

	public var hashValue: Int {
		return (localCountry?.hashValue ?? -1) ^ digits.hashValue
	}
}


extension PhoneNumber.Digits: ArrayLiteralConvertible {

	public init(arrayLiteral elements: Digit...) {
		self.init(elements)
	}
}


extension PhoneNumber.Digits: CustomStringConvertible {

	public var description: String {
		return string
	}
}


extension PhoneNumber.Digits: Hashable {

	public var hashValue: Int {
		var hashValue = 0
		for index in 0 ..< values.count {
			hashValue ^= index ^ values[index].hashValue
		}
		return hashValue
	}
}


extension PhoneNumber.Digits: MutableCollectionType {

	public typealias Generator = Array<Digit>.Generator
	public typealias Index = Array<Digit>.Index
	public typealias SubSequence = Array<Digit>.SubSequence


	public var count: Int {
		return values.count
	}


	public var endIndex: Index {
		return values.endIndex
	}


	public func generate() -> Generator {
		return values.generate()
	}


	public var isEmpty: Bool {
		return values.isEmpty
	}


	public subscript(bounds: Range<Index>) -> SubSequence {
		get { return values[bounds] }
		mutating set { values[bounds] = newValue }
	}


	public subscript(position: Index) -> Generator.Element {
		get { return values[position] }
		mutating set { values[position] = newValue }
	}


	public var startIndex: Index {
		return values.startIndex
	}
}


extension PhoneNumber.Digits: RangeReplaceableCollectionType {

	public mutating func replaceRange<C: CollectionType where C.Generator.Element == Generator.Element>(subRange: Range<Index>, with newElements: C) {
		values.replaceRange(subRange, with: newElements)
	}
}


extension PhoneNumber.Digits: StringLiteralConvertible {

	public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
		self.init(value)
	}


	public init(stringLiteral value: StringLiteralType) {
		self.init(value)
	}


	public init(unicodeScalarLiteral value: StringLiteralType) {
		self.init(value)
	}
}


public func == (a: PhoneNumber, b: PhoneNumber) -> Bool {
	return a.localCountry == b.localCountry && a.digits == b.digits
}


public func == (a: PhoneNumber.Digits, b: PhoneNumber.Digits) -> Bool {
	return a.values == b.values
}
