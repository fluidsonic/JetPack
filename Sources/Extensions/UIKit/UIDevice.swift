import Darwin
import UIKit


public extension UIDevice {

	@nonobjc
	var isSimulator: Bool {
		return TARGET_OS_SIMULATOR != 0
	}
}
