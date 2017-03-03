import JetPack
import UIKit


class LabelTestViewController: ViewController {

	private let label = Label()


	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .black

		let font1 = UIFont(name: "Zapfino", size: 30)!
		let font2 = UIFont(name: "Zapfino", size: 15)!

		let at = NSMutableAttributedString(string: "ABCDEÄji0ABCDEÄji0")
		at.addAttributes([ NSFontAttributeName: font1 ], range: NSRange(location: 0, length: 9))
		at.addAttributes([ NSFontAttributeName: font2 ], range: NSRange(location: 9, length: 9))

		label.backgroundColor = .red
		label.maximumNumberOfLines = nil
		label.attributedText = at
		label.font = font1
		label.text = "fABCÄÖÜj" // °͌͌͌͌͌͌͌͌͌͌͌͌͌͌͌͌͌͌͌͌͌͌͌͌͌
		label.textColor = .white
		label.lineHeightMultiple = 1
		label.verticalAlignment = .top

		var frame = CGRect(left: 10, top: 200, width: 300, height: 50)
		//frame.size.height = label.heightThatFitsWidth(300)
		frame.size = label.sizeThatFits()
		label.frame = frame

		let lineHeight1 = font1.lineHeight * 1

		// target asc: 7.3 - 7.6
		print("1 asc: \(font1.ascender)")
		print("1 des: \(font1.descender)")
		print("1 cap: \(font1.capHeight)")
		print("1 lin: \(font1.lineHeight)") // = asc - desc
		print("1 li4: \(lineHeight1)") // = asc - desc * n
		print("1 poi: \(font1.pointSize)")
		print("1 bottom: \(font1.descender)") // bottom space?
		print("1 top: \(lineHeight1 - font1.capHeight + font1.descender)") // top space?

		let lineHeight2 = font2.lineHeight * 1

		// target asc: 7.3 - 7.6
		print("2 asc: \(font2.ascender)")
		print("2 des: \(font2.descender)")
		print("2 cap: \(font2.capHeight)")
		print("2 lin: \(font2.lineHeight)") // = asc - desc
		print("2 li4: \(lineHeight2)") // = asc - desc * n
		print("2 poi: \(font2.pointSize)")
		print("2 bottom: \(font2.descender)") // bottom space?
		print("2 top: \(lineHeight2 - font2.capHeight + font2.descender)") // top space?

		view.addSubview(label)
	}
}
