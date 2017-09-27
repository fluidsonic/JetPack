import Cocoa
import JetPack


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	override init() {
		super.init()

		logEnabled = true

		JetPackKit.initialize()
	}
}
