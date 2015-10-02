import Photos


extension PHFetchResult: SequenceType {

	@nonobjc
	@warn_unused_result
	public func generate() -> NSFastGenerator {
		return NSFastGenerator(self)
	}
}
