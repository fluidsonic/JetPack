import UIKit


@objc(JetPack_CollectionViewCell)
open class CollectionViewCell: UICollectionViewCell {

	public var removesAllAnimationsOnReuse = false


	public required override init(frame: CGRect) {
		super.init(frame: frame)
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	open override func prepareForReuse() {
		if removesAllAnimationsOnReuse {
			super.prepareForReuse()
		}
		else {
			CALayer.withRemoveAllAnimationsDisabled {
				super.prepareForReuse()
			}
		}
	}
}
