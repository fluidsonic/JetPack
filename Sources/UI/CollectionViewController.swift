import UIKit


@objc(JetPack_CollectionViewController)
open class CollectionViewController: ViewController {

	fileprivate var lastLayoutedSize = CGSize()

	internal let collectionViewLayout: UICollectionViewLayout


	public init(collectionViewLayout: UICollectionViewLayout) {
		self.collectionViewLayout = collectionViewLayout

		super.init()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	open var automaticallyAdjustsCollectionViewInsets = true


	open var clearsSelectionOnViewWillAppear = true


	open fileprivate(set) lazy var collectionView: CollectionView = self.createCollectionView()


	fileprivate func createCollectionView() -> CollectionView {
		let child = CollectionView(collectionViewLayout: collectionViewLayout)
		child.dataSource = self
		child.delegate = self

		return child
	}


	open override func viewDidLayoutSubviewsWithAnimation(_ animation: Animation?) {
		super.viewDidLayoutSubviewsWithAnimation(animation)

		let bounds = view.bounds

		animation.runAlways {
			if automaticallyAdjustsCollectionViewInsets {
				collectionView.setContentInset(innerDecorationInsets, maintainingVisualContentOffset: true)
				collectionView.scrollIndicatorInsets = outerDecorationInsets
			}

			if bounds.size != lastLayoutedSize {
				lastLayoutedSize = bounds.size

				collectionView.frame = CGRect(size: bounds.size)
				collectionViewLayout.invalidateLayout()
			}
		}
	}


	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if clearsSelectionOnViewWillAppear, let indexPaths = collectionView.indexPathsForSelectedItems {
			for indexPath in indexPaths {
				collectionView.deselectItem(at: indexPath, animated: animated)
			}
		}
	}


	open override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(collectionView)
	}
}


extension CollectionViewController: UICollectionViewDataSource {

	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		fatalError("override collectionView(_:cellForItemAtIndexPath:) without calling super")
	}


	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 0
	}
}


extension CollectionViewController: UICollectionViewDelegate {}
