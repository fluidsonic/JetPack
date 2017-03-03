import JetPack
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
		logEnabled = true

		let window = Window()
		window.rootViewController = LabelTestViewController()
		self.window = window

		window.makeKeyAndVisible()

		return true
	}
}
