// Swift Limitation & Bug Workarounds with Direct Inclusion

/*
 * This file must be added to the app project manually as the functionality it provides
 * is not available through Frameworks at the moment due to bugs & limitations of Swift.
 *
 * Last checked with Xcode 7 Beta 2.
 */

import JetPack


// CGRect.swift: compiler doesn't allow Framework extensions to add setters to existing computed vars or overwrite them completely

import CoreGraphics


extension CGRect {

	var height: CGFloat {
		get { return size.height }
		mutating set { size.height = newValue }
	}

	var width: CGFloat {
		get { return size.width }
		mutating set { size.width = newValue }
	}
}
