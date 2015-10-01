import Photos


extension PHFetchResult: SequenceType {

	@nonobjc
	public func generate() -> NSFastGenerator {
		return NSFastGenerator(self)
	}
}
