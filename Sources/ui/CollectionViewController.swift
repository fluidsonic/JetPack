import UIKit


public /* non-final */ class CollectionViewController: ViewController {

	internal let collectionViewLayout: UICollectionViewLayout


	public init(collectionViewLayout: UICollectionViewLayout) {
		self.collectionViewLayout = collectionViewLayout

		super.init()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	public var automaticallyAdjustsCollectionViewInsets = true


	public var clearsSelectionOnViewWillAppear = true


	public private(set) lazy var collectionView: UICollectionView = {
		let child = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
		child.dataSource = self
		child.delegate = self

		return child
	}()


	public override func viewDidLayoutSubviewsWithAnimation(animation: Animation?) {
		super.viewDidLayoutSubviewsWithAnimation(animation)

		animation.runAlways {
			if automaticallyAdjustsCollectionViewInsets {
				collectionView.setContentInset(innerDecorationInsets, maintainingVisualContentOffset: true)
				collectionView.scrollIndicatorInsets = outerDecorationInsets
			}

			collectionView.frame = CGRect(size: view.bounds.size)
		}
	}


	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		if clearsSelectionOnViewWillAppear, let indexPaths = collectionView.indexPathsForSelectedItems() {
			for indexPath in indexPaths {
				collectionView.deselectItemAtIndexPath(indexPath, animated: animated)
			}
		}
	}


	public override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(collectionView)
	}
}


extension CollectionViewController: UICollectionViewDataSource {

	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		fatalError("override collectionView(_:cellForItemAtIndexPath:) without calling super")
	}


	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 0
	}
}


extension CollectionViewController: UICollectionViewDelegate {}
