import JetPack
import UIKit


class LabelTestViewController: ViewController {

	private let label = Label()


	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .black

		let f = UIFont.systemFont(ofSize: 40)
		let style = NSMutableParagraphStyle()
		style.lineBreakMode = .byTruncatingTail
		style.lineHeightMultiple = 1 / f.lineHeight * f.pointSize
		style.paragraphSpacing = 40

		let font = UIFont.systemFont(ofSize: 20)
		let text = NSMutableAttributedString()
		text.append("Line number one one one one one one one one xxxxxxx\n")
		text.append("Line number ")
		text.appendString("two\u{2029}", font: f, paragraphStyle: style)
		text.append("Line number three three three three three three\n")
		text.append("Line number three\n")
		text.append("Line number three\n")
		text.append("Line number three\n")
		text.append("Line number three\n")
		text.append("Line number three\n")

		label.attributedText = text
		label.backgroundColor = .green
		label.font = font
		label.horizontalAlignment = .left
		label.lineBreakMode = .byTruncatingTail
		label.lineHeight = .relativeToFontSize(multipler: 1)
		label.maximumNumberOfLines = 5
		label.minimumScaleFactor = 0.1
		label.textColor = .white
		label.linkTapped = { url in
			print("link tapped!")
		}

		var frame = CGRect(left: 30, top: 120, width: 0, height: 0)
		frame.size = label.sizeThatFitsWidth(300, allowsTruncation: true)
		label.frame = frame

		let style2 = NSMutableParagraphStyle()
		style2.lineBreakMode = .byTruncatingTail
		style2.maximumLineHeight = 20
		style2.minimumLineHeight = 20
		style2.lineHeightMultiple = 0

		let style3 = NSMutableParagraphStyle()
		style2.lineBreakMode = .byTruncatingTail
		style2.maximumLineHeight = 20
		style2.minimumLineHeight = 20
		style2.lineHeightMultiple = 0
		style2.paragraphSpacing = 60

		let text2 = NSMutableAttributedString(attributedString: text)
		text2.addAttributes([ .paragraphStyle: style2 ], range: NSRange(forString: text2.string))
		text2.addAttributes([ .paragraphStyle: style3 ], range: NSRange(location: 64, length: 1))

		let label2 = UILabel()
		label2.adjustsFontSizeToFitWidth = false
		label2.backgroundColor = .red
		label2.font = font
		label2.lineBreakMode = .byTruncatingTail
		label2.minimumScaleFactor = 1
		label2.numberOfLines = 5
		label2.textAlignment = .left
		label2.textColor = .white
		label2.attributedText = text2

		var frame2 = CGRect(left: 30, top: 400, width: 0, height: 0)
		frame2.size = label2.sizeThatFitsWidth(300, allowsTruncation: true)
		label2.frame = frame2

		view.addSubview(label)
		view.addSubview(label2)

		let l3 = UILabel()
		l3.text = "JetPack.Label"
		l3.textColor = .white
		var f3 = CGRect()
		f3.left = 30
		f3.size = l3.sizeThatFits()
		f3.bottom = frame.top - 10
		l3.frame = f3

		let l4 = UILabel()
		l4.text = "UIKit.UILabel"
		l4.textColor = .white
		var f4 = CGRect()
		f4.left = 30
		f4.size = l4.sizeThatFits()
		f4.bottom = frame2.top - 10
		l4.frame = f4

		view.addSubview(l3)
		view.addSubview(l4)
	}
}
