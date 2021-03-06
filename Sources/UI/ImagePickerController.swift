import UIKit


@objc(JetPack_ImagePickerController)
open class ImagePickerController: _ImagePickerController {

	public override init() {
		super.init()
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	open override func viewDidLoad() {
		super.viewDidLoad()

		// fixes a bug where the screen is transparent unless Photos permission was given
		view.backgroundColor = .white
	}
}



// fix to make init() the designated initializers of ImagePickerController
@objc(_JetPack_ImagePickerController)
open class _ImagePickerController: UIImagePickerController {

	fileprivate dynamic init() {
		// not supposed to be called
		super.init(nibName: nil, bundle: nil)
	}


	fileprivate dynamic override init(nibName: String?, bundle: Bundle?) {
		// not supposed to be called
		super.init(nibName: nibName, bundle: bundle)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}


@objc(_JetPack_UI_ImagePickerController_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		redirectMethod(in: ImagePickerController.self, from: #selector(UIViewController.init(nibName:bundle:)), to: #selector(UIViewController.init(nibName:bundle:)), in: UIImagePickerController.self)

		redirectMethod(in: _ImagePickerController.self, from: #selector(NSObject.init), to: #selector(NSObject.init),                                                   in: UIImagePickerController.self)
		redirectMethod(in: _ImagePickerController.self, from: #selector(UIViewController.init(nibName:bundle:)), to: #selector(UIViewController.init(nibName:bundle:)), in: UIImagePickerController.self)
	}
}
