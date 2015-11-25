import UIKit


public extension UICollectionView {

	@nonobjc
	public var firstResponderCell: UICollectionViewCell? {
		guard let firstResponder = firstResponder as? UIView else {
			return nil
		}

		var optionalView: UIView? = firstResponder
		while let view = optionalView {
			guard view.superview === self else {
				optionalView = view.superview
				continue
			}

			return view as? UICollectionViewCell
		}

		return nil
	}


	@nonobjc
	public func performBatchUpdates(updates: Closure) {
		self.performBatchUpdates(updates, completion: nil)
	}
}
