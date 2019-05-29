import UIKit


@objc(JetPack_CollectionView)
open class CollectionView: UICollectionView {

	public init(collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: .zero, collectionViewLayout: layout)

		contentInsetAdjustmentBehavior = .never
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
