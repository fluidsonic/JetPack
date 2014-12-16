import UIKit


public class View: UIView {

	public override init() {
		super.init(frame: .zeroRect)
	}


	public required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
