import UIKit
import WebKit


@objc(JetPack_WebViewController)
public /* non-final */ class WebViewController: ViewController {

	private lazy var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

	private var initialLoadingCompleted = false

	public let configuration: WKWebViewConfiguration
	public var initialUrl: NSURL?
	public var opensLinksExternally = false


	public init(configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
		self.configuration = configuration

		super.init()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	deinit {
		if isViewLoaded() {
			webView.removeObserver(self, forKeyPath: "loading", context: nil)
			webView.removeObserver(self, forKeyPath: "title", context: nil)
		}
	}


	public var animatesInitialLoading = false {
		didSet {
			guard animatesInitialLoading != oldValue else {
				return
			}

			if !animatesInitialLoading && isViewLoaded() {
				webView.alpha = 1
				webView.userInteractionEnabled = true
			}
		}
	}


	public func handleEmailLink(link: NSURL) -> Bool {
		guard opensLinksExternally else {
			return false
		}

		UIApplication.sharedApplication().openURL(link)
		return true
	}


	public func handleLink(link: NSURL, newWindowRequested: Bool) -> Bool {
		switch link.scheme {
		case "http", "https":    return handleWebLink(link, newWindowRequested: newWindowRequested)
		case "mailto":           return handleEmailLink(link)
		case "tel", "telprompt": return handlePhoneLink(link)
		default:                 return handleUnknownLink(link)
		}
	}


	public func handlePhoneLink(link: NSURL) -> Bool {
		guard opensLinksExternally else {
			return false
		}

		UIApplication.sharedApplication().openURL(link)
		return true
	}


	public func handleUnknownLink(link: NSURL) -> Bool {
		guard opensLinksExternally else {
			return false
		}

		UIApplication.sharedApplication().openURL(link)
		return true
	}


	public func handleWebLink(link: NSURL, newWindowRequested: Bool) -> Bool {
		guard opensLinksExternally else {
			return false
		}

		UIApplication.sharedApplication().openURL(link)
		return true
	}


	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if object === webView, let keyPath = keyPath {
			switch keyPath {
			case "loading", "title":
				if updatesTitleFromDocument {
					updateTitleFromDocument()
				}

			default:
				break
			}
		}
	}


	private func setUp() {
		view.backgroundColor = .whiteColor()

		setUpWebView()
		setUpActivityIndicator()
	}


	private func setUpActivityIndicator() {
		let child = activityIndicator
		child.startAnimating()
	}


	private func setUpWebView() {
		webView.addObserver(self, forKeyPath: "loading", options: [], context: nil)
		webView.addObserver(self, forKeyPath: "title", options: [], context: nil)

		if updatesTitleFromDocument {
			updateTitleFromDocument()
		}

		view.addSubview(webView)
	}


	private func updateTitleFromDocument() {
		title = webView.title?.nonEmpty ?? (webView.loading ? "Loading…" : "")
	}


	public var updatesTitleFromDocument = false {
		didSet {
			guard updatesTitleFromDocument != oldValue else {
				return
			}

			if updatesTitleFromDocument && isViewLoaded() {
				updateTitleFromDocument()
			}
		}
	}


	public override func viewDidLayoutSubviewsWithAnimation(animation: Animation?) {
		super.viewDidLayoutSubviewsWithAnimation(animation)

		let bounds = view.bounds

		animation.runAlways {
			let innerDecorationInsets = self.innerDecorationInsets

			// WKWebView doesn't properly support non-zero scrollView.contentInset at the moment causing .contentSize to be too large.
			var webViewFrame = bounds.insetBy(innerDecorationInsets)

			// WKWebView rounds up it's scollView's contentSize no matter what the display scale is.
			// That means the user would be able to scroll for less than a point even if they shouldn't be able to scroll at all in that axis.
			webViewFrame.height = ceil(webViewFrame.height)
			webViewFrame.width = ceil(webViewFrame.width)
			webView.frame = webViewFrame

			webView.scrollView.scrollIndicatorInsets = outerDecorationInsets.increaseBy(innerDecorationInsets.inverse)

			if activityIndicator.superview != nil {
				var activityIndicatorFrame = CGRect()
				activityIndicatorFrame.size = activityIndicator.sizeThatFits()
				activityIndicatorFrame.center = bounds.insetBy(innerDecorationInsets).center
				activityIndicator.frame = view.alignToGrid(activityIndicatorFrame)
			}
		}
	}


	public override func viewDidLoad() {
		super.viewDidLoad()

		setUp()
	}


	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		if let initialUrl = initialUrl {
			self.initialUrl = nil

			if webView.URL == nil && !webView.loading {
				let navigation = webView.loadRequest(NSURLRequest(URL: initialUrl))
				if navigation != nil {
					initialLoadingCompleted = false

					if animatesInitialLoading {
						webView.alpha = 0
						webView.userInteractionEnabled = false

						view.addSubview(activityIndicator)
					}
				}
			}
		}
	}


	public private(set) lazy var webView: WKWebView = {
		let child = WKWebView(frame: .zero, configuration: self.configuration)
		child.navigationDelegate = self
		child.UIDelegate = self

		return child
	}()
}


extension WebViewController: WKNavigationDelegate {

	public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: WKNavigationActionPolicy -> Void) {
		if navigationAction.navigationType == .LinkActivated, let url = navigationAction.request.URL {
			decisionHandler(handleLink(url, newWindowRequested: navigationAction.targetFrame == nil) ? .Cancel : .Allow)
			return
		}

		decisionHandler(.Allow)
	}


	public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation) {
		if !initialLoadingCompleted {
			initialLoadingCompleted = true

			if animatesInitialLoading {
				Animation(duration: 0.5).runWithCompletion { complete in
					webView.alpha = 1
					webView.userInteractionEnabled = true

					activityIndicator.alpha = 0

					complete { _ in
						self.activityIndicator.removeFromSuperview()
					}
				}
			}
		}
	}
}


extension WebViewController: WKUIDelegate {}
