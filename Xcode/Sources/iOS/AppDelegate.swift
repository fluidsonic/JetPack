import JetPack
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	override init() {
		super.init()

		#if CORE
			logEnabled = true

			JetPackKit.initialize()
		#endif
	}


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
		#if UI
			let window = Window()
			window.rootViewController = LabelTestViewController()
			self.window = window

			window.makeKeyAndVisible()
		#endif

		return true
	}
}
