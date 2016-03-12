import UIKit


@objc(JetPack_ImagePickerController)
public /* non-final */ class ImagePickerController: _ImagePickerController {

	public override init() {
		super.init()
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	public override func viewDidLoad() {
		super.viewDidLoad()

		// fixes a bug where the screen is transparent unless Photos permission was given
		view.backgroundColor = .whiteColor()
	}


	public override class func initialize() {
		guard self == ImagePickerController.self else {
			return
		}

		redirectMethodInType(self, fromSelector: "initWithNibName:bundle:", toSelector: "initWithNibName:bundle:", inType: UIImagePickerController.self)
	}
}



// fix to make init() the designated initializers of ImagePickerController
@objc(_JetPack_ImagePickerController)
public /* non-final */ class _ImagePickerController: UIImagePickerController {

	private dynamic init() {
		// not supposed to be called
		super.init(nibName: nil, bundle: nil)
	}


	private dynamic override init(nibName: String?, bundle: NSBundle?) {
		// not supposed to be called
		super.init(nibName: nibName, bundle: bundle)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	public override class func initialize() {
		guard self == _ImagePickerController.self else {
			return
		}

		redirectMethodInType(self, fromSelector: "init",                    toSelector: "init",                    inType: UIImagePickerController.self)
		redirectMethodInType(self, fromSelector: "initWithNibName:bundle:", toSelector: "initWithNibName:bundle:", inType: UIImagePickerController.self)
	}
}
