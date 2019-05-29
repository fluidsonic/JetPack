import XCTest

@testable
import JetPack

import UIKit


class TextLayoutTests: XCTestCase {

	func testMinimumScaleFactor() {
		let font = UIFont.systemFont(ofSize: 20)

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = .byTruncatingTail
		paragraphStyle.set(lineHeight: .relativeToFontSize(multipler: 2), with: font)

		let string = NSMutableAttributedString()
		string.appendString("long line long line long line long line long line long line", font: font, paragraphStyle: paragraphStyle)

		let layout = TextLayout.build(
			text:                 string,
			lineBreakMode:        .byTruncatingTail,
			maximumNumberOfLines: 1,
			maximumSize:          CGSize(width: 320, height: 640),
			minimumScaleFactor:   0.5,
			renderingScale:       2
		)

		XCTAssertEqual(layout.dependsOnTintColor, false)
		XCTAssertEqual(layout.isTruncated, false)
		XCTAssertEqual(layout.numberOfLines, 1)
		XCTAssertEqual(layout.rect(forLine: 0), CGRect(left: 0, top: 0, width: 457.43, height: 40), accuracy: 0.01)
		XCTAssertEqual(layout.scaleFactor, 0.7, accuracy: 0.01)
	}


	func testMinimumScaleFactorWithTruncation() {
		let font = UIFont.systemFont(ofSize: 20)

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = .byTruncatingTail
		paragraphStyle.set(lineHeight: .relativeToFontSize(multipler: 2), with: font)

		let string = NSMutableAttributedString()
		string.appendString("long line long line long line long line long line long line long line long line long line long line long line long line", font: font, paragraphStyle: paragraphStyle)

		let layout = TextLayout.build(
			text:                 string,
			lineBreakMode:        .byTruncatingTail,
			maximumNumberOfLines: 1,
			maximumSize:          CGSize(width: 320, height: 640),
			minimumScaleFactor:   0.5,
			renderingScale:       2
		)

		XCTAssertEqual(layout.dependsOnTintColor, false)
		XCTAssertEqual(layout.isTruncated, true)
		XCTAssertEqual(layout.numberOfLines, 1)
		XCTAssertEqual(layout.rect(forLine: 0), CGRect(left: 0, top: 0, width: 634.14, height: 40), accuracy: 0.01)
		XCTAssertEqual(layout.scaleFactor, 0.5, accuracy: 0.01)
	}


	func testMultiline() {
		let font = UIFont.systemFont(ofSize: 20)

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = .byTruncatingTail
		paragraphStyle.set(lineHeight: .relativeToFontSize(multipler: 2), with: font)

		let string = NSMutableAttributedString()
		string.appendString("Line number one\n")
		string.appendString("Line number two\n")
		string.appendString("Line number three")
		string.addAttributes(
			[
				.font:           font,
				.paragraphStyle: paragraphStyle
			],
			range: NSRange(location: 0, length: string.length)
		)

		let layout = TextLayout.build(
			text:                 string,
			lineBreakMode:        .byTruncatingTail,
			maximumNumberOfLines: nil,
			maximumSize:          CGSize(width: 320, height: 640),
			minimumScaleFactor:   1,
			renderingScale:       2
		)

		XCTAssertEqual(layout.dependsOnTintColor, false)
		XCTAssertEqual(layout.isTruncated, false)
		XCTAssertEqual(layout.numberOfLines, 3)
		XCTAssertEqual(layout.rect(forLine: 0), CGRect(left: 0, top:  0, width: 145.00, height: 40), accuracy: 0.01)
		XCTAssertEqual(layout.rect(forLine: 1), CGRect(left: 0, top: 40, width: 144.55, height: 40), accuracy: 0.01)
		XCTAssertEqual(layout.rect(forLine: 2), CGRect(left: 0, top: 80, width: 157.29, height: 40), accuracy: 0.01)
		XCTAssertEqual(layout.scaleFactor, 1)
	}


	func testMultilineWithMixedHeights() {
		let font1 = UIFont.systemFont(ofSize: 20)
		let font2 = UIFont.systemFont(ofSize: 40)

		let paragraphStyle1 = NSMutableParagraphStyle()
		paragraphStyle1.lineBreakMode = .byTruncatingTail
		paragraphStyle1.set(lineHeight: .relativeToFontSize(multipler: 2), with: font1)

		let paragraphStyle2 = NSMutableParagraphStyle()
		paragraphStyle2.lineBreakMode = .byTruncatingTail
		paragraphStyle2.set(lineHeight: .relativeToFontSize(multipler: 2), with: font2)

		let string = NSMutableAttributedString()
		string.appendString("Line number one\n", font: font1, paragraphStyle: paragraphStyle1)
		string.appendString("Line number two\n", font: font2, paragraphStyle: paragraphStyle2)
		string.appendString("Line number three", font: font1, paragraphStyle: paragraphStyle1)

		let layout = TextLayout.build(
			text:                 string,
			lineBreakMode:        .byTruncatingTail,
			maximumNumberOfLines: nil,
			maximumSize:          CGSize(width: 320, height: 640),
			minimumScaleFactor:   1,
			renderingScale:       2
		)

		XCTAssertEqual(layout.dependsOnTintColor, false)
		XCTAssertEqual(layout.isTruncated, false)
		XCTAssertEqual(layout.numberOfLines, 3)
		XCTAssertEqual(layout.rect(forLine: 0), CGRect(left: 0, top:   0, width: 145.00, height: 40), accuracy: 0.01)
		XCTAssertEqual(layout.rect(forLine: 1), CGRect(left: 0, top:  40, width: 283.83, height: 80), accuracy: 0.01)
		XCTAssertEqual(layout.rect(forLine: 2), CGRect(left: 0, top: 120, width: 157.29, height: 40), accuracy: 0.01)
		XCTAssertEqual(layout.scaleFactor, 1)
	}


	func testRectForLine() {
		let font = UIFont.systemFont(ofSize: 20)

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode    = .byTruncatingTail
		paragraphStyle.paragraphSpacing = 40
		paragraphStyle.set(lineHeight: .relativeToFontSize(multipler: 2), with: font)

		let string = NSMutableAttributedString()
		string.appendString("long line long line long line long line long line long line long line long line long line long line long line long line", font: font, paragraphStyle: paragraphStyle)

		let layout = TextLayout.build(
			text:                 string,
			lineBreakMode:        .byTruncatingTail,
			maximumNumberOfLines: 1,
			maximumSize:          CGSize(width: 320, height: 640),
			minimumScaleFactor:   1,
			renderingScale:       2
		)

		XCTAssertEqual(layout.rect(forLine: 0), CGRect(left: 0, top: 0, width: 317.30, height: 40), accuracy: 0.01)
	}


	func testRectForLineWithScaling() {
		let font = UIFont.systemFont(ofSize: 20)

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode    = .byTruncatingTail
		paragraphStyle.paragraphSpacing = 40
		paragraphStyle.set(lineHeight: .relativeToFontSize(multipler: 2), with: font)

		let string = NSMutableAttributedString()
		string.appendString("long line long line long line long line long line long line long line long line long line long line long line long line", font: font, paragraphStyle: paragraphStyle)

		let layout = TextLayout.build(
			text:                 string,
			lineBreakMode:        .byTruncatingTail,
			maximumNumberOfLines: 1,
			maximumSize:          CGSize(width: 320, height: 640),
			minimumScaleFactor:   0.5,
			renderingScale:       2
		)

		XCTAssertEqual(layout.scaleFactor, 0.5, accuracy: 0.01)
		XCTAssertEqual(layout.rect(forLine: 0), CGRect(left: 0, top: 0, width: 320, height: 20.18), accuracy: 0.01)
	}
}
