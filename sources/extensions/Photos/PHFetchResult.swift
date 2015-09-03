import Photos


extension PHFetchResult: SequenceType {

	public func generate() -> NSFastGenerator {
		return NSFastGenerator(self)
	}
}
