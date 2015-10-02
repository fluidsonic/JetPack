import UIKit


private var temporaryFirstResponder: UIResponder?


public extension UIResponder {

	@nonobjc // may conflict with private selector name
	public var firstResponder: UIResponder? {
		defer {
			temporaryFirstResponder = nil
		}

		let application = UIApplication.sharedApplication()

		temporaryFirstResponder = nil
		application.sendAction("JetPack_determineFirstResponder", to: nil, from: nil, forEvent: nil)

		guard let firstResponder = temporaryFirstResponder else {
			// there is no first responder at all
			return nil
		}

		if application === self {
			// application.sendAction() already verified that the first responder in this responder's subchain
			return firstResponder
		}

		var nextResponder: UIResponder? = firstResponder
		while let responder = nextResponder {
			if responder === self {
				// first responder is in this responder's subchain
				return firstResponder
			}

			nextResponder = responder.nextResponder()
		}

		// first responder is not in this responder's subchain
		return nil
	}


	@objc
	private func JetPack_determineFirstResponder() {
		temporaryFirstResponder = self
	}
}
