import UIKit


private var temporaryFirstResponder: UIResponder?


public extension UIResponder {

	@nonobjc
	public var firstResponder: UIResponder? {
		defer {
			temporaryFirstResponder = nil
		}

		let application = UIApplication.sharedApplication()

		temporaryFirstResponder = nil
		application.sendAction(#selector(determineFirstResponder), to: nil, from: nil, forEvent: nil)

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


	@objc(JetPack_determineFirstResponder)
	private func determineFirstResponder() {
		temporaryFirstResponder = self
	}
}
