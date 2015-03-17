public struct CastedSequenceOf<T: AnyObject>: SequenceType {

	private let sequence: SequenceOf<T>


	public init(_ array: NSArray!) {
		let makeUnderlyingGenerator: () -> GeneratorOf<T> = {
			if let array = array {
				var arrayGenerator = array.generate()

				return GeneratorOf<T>() {
					return arrayGenerator.next() as! T?
				}
			}
			else {
				return GeneratorOf<T>(EmptyGenerator())
			}
		}

		self.sequence = SequenceOf<T>(makeUnderlyingGenerator);
	}


	public func generate() -> GeneratorOf<T> {
		return sequence.generate()
	}
}
