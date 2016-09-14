JetPack
=======

[![Build Status](https://travis-ci.org/fluidsonic/JetPack.svg?branch=master)](https://travis-ci.org/fluidsonic/JetPack)
[![codecov.io](https://codecov.io/github/fluidsonic/JetPack/coverage.svg?branch=master)](https://codecov.io/github/fluidsonic/JetPack?branch=master)

JetPack offers various functionality to make iOS app development with Swift even more enjoyable!

Functionality is developed along with the apps using it so everything in this library solves real problems. It's still in an early stage and thus it's not published in CocoaPods's repository yet.


Installation
------------

JetPack requires **Swift 2.3** and a deployment target of **iOS 9.0 or newer**.

```ruby
pod 'JetPack', :git => 'https://github.com/fluidsonic/JetPack.git'
```

Since JetPack isn't versioned yet it is recommended to add it as a Git submodule and import it as a development pod. This way you can be sure that a subsequent `pod update` doesn't break your code until you check out latest changes manually.


### Modules

| Module | Description |
|:-------|:------------|
| [JetPack](https://github.com/fluidsonic/JetPack/tree/master/Sources) | Imports all modules listed below at once. Best value! |
| [JetPack/Core](https://github.com/fluidsonic/JetPack/tree/master/Sources/Core) | Commonly used components, global functions & types. |
| [JetPack/Deprecated](https://github.com/fluidsonic/JetPack/tree/master/Sources/Deprecated) | Stuff you can but should no longer use. |
| [JetPack/Experimental](https://github.com/fluidsonic/JetPack/tree/master/Sources/Experimental) | Functionality which is helpful but not fully developed. |
| [JetPack/Extensions](https://github.com/fluidsonic/JetPack/tree/master/Sources/Extensions) | Imports all extension modules listed below at once. |
| [JetPack/Extensions/CoreGraphics](https://github.com/fluidsonic/JetPack/tree/master/Sources/Extensions/CoreGraphics) | Useful extensions for the CoreGraphics framework. |
| [JetPack/Extensions/CoreLocation](https://github.com/fluidsonic/JetPack/tree/master/Sources/Extensions/CoreLocation) | Useful extensions for the CoreLocation framework. |
| [JetPack/Extensions/Darwin](https://github.com/fluidsonic/JetPack/tree/master/Sources/Extensions/Darwin) | Useful extensions for the Darwin module. |
| [JetPack/Extensions/Foundation](https://github.com/fluidsonic/JetPack/tree/master/Sources/Extensions/Foundation) | Useful extensions for the Foundation framework. |
| [JetPack/Extensions/MapKit](https://github.com/fluidsonic/JetPack/tree/master/Sources/Extensions/MapKit) | Useful extensions for the MapKit framework. |
| [JetPack/Extensions/Photos](https://github.com/fluidsonic/JetPack/tree/master/Sources/Extensions/Photos) | Useful extensions for the Photos framework. |
| [JetPack/Extensions/Swift](https://github.com/fluidsonic/JetPack/tree/master/Sources/Extensions/Swift) | Useful extensions for the Swift framework. |
| [JetPack/Extensions/UIKit](https://github.com/fluidsonic/JetPack/tree/master/Sources/Extensions/UIKit) | Useful extensions for the UIKit framework. |
| [JetPack/Measures](https://github.com/fluidsonic/JetPack/tree/master/Sources/Measures) | Working with and converting various measurement units made easy!<br>Angle, Length, Pressure, Speed, Temperature & Time so far. |
| [JetPack/UI](https://github.com/fluidsonic/JetPack/tree/master/Sources/UI) | New UI components, replacements for existing UI components (e.g. an [ImageView](https://github.com/fluidsonic/JetPack/blob/master/Sources/UI/ImageView.swift) with URL loading or a [Label](https://github.com/fluidsonic/JetPack/blob/master/Sources/UI/Label.swift) with padding & link support) and subclasses augmenting existing UI components. |



License
-------

MIT
