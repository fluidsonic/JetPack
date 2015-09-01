// TODO: Declaring protocol conformance for PHFetchResult which is not available on iOS 7 will cause runtime crashes on iOS 7,
//       no matter if the class is used or not. Add this again once iOS 7 support was dropped.

/*
import Photos


extension PHFetchResult: SequenceType {

	public func generate() -> NSFastGenerator {
		return NSFastGenerator(self)
	}
}
*/
