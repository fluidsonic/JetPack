import UIKit


@objc(JetPack_CollectionView)
open class CollectionView: UICollectionView {

	public init(collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: .zero, collectionViewLayout: layout)

		if #available(iOS 11.0, *) {
			contentInsetAdjustmentBehavior = .never
		}
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
