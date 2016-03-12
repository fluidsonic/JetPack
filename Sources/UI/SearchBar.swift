import UIKit


public /* non-final */ class SearchBar: UISearchBar {

	public init() {
		super.init(frame: .zero)
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	public var automaticallyDisablesCancelButton = true {
		didSet {
			guard automaticallyDisablesCancelButton != oldValue else{
				return
			}

			private_setAutomaticallyDisablesCancelButton(automaticallyDisablesCancelButton)
		}
	}
}
