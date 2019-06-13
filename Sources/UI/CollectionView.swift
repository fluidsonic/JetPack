import UIKit


@objc(JetPack_CollectionView)
open class CollectionView: UICollectionView {

	open var isUserInteractionLimitedToSubviews = false


	public init(collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: .zero, collectionViewLayout: layout)

		contentInsetAdjustmentBehavior = .never
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// reference implementation
	open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		guard participatesInHitTesting else {
			return nil
		}
		guard isUserInteractionLimitedToSubviews || self.point(inside: point, with: event) else {
			return nil
		}

		var hitView: UIView?
		for subview in subviews.reversed() {
			hitView = subview.hitTest(convert(point, to: subview), with: event)
			if hitView != nil {
				break
			}
		}

		if hitView == nil && !isUserInteractionLimitedToSubviews {
			hitView = self
		}

		return hitView
	}
}
