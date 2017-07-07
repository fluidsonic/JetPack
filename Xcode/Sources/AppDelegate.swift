import JetPack
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	override init() {
		super.init()

		logEnabled = true

		JetPack.initialize()
	}


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
		let window = Window()
		window.rootViewController = LabelTestViewController()
		self.window = window

		window.makeKeyAndVisible()

		return true
	}
}
