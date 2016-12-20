import Photos


extension NSFastEnumeration {

	public func makeIterator() -> NSFastEnumerationIterator {
		return NSFastEnumerationIterator(self)
	}
}


extension PHFetchResult: Sequence {}
