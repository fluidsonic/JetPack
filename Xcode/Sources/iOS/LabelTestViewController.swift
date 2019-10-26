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
		text.append("Line number three three ")
		text.append("three", attributes: [
			.foregroundColor: UIColor.blue,
			.link:            URL(string: "https://apple.com")!
		])
		text.append(" three three three\n")
		text.append("Line number 4\n")
		text.append("Line number 5\n")
		text.append("Line number 6\n")
		text.append("Line number 7\n")
		text.append("Line number 8\n")

		label.attributedText = text
		label.backgroundColor = .green
		label.font = font
		label.horizontalAlignment = .left
		label.lineBreakMode = .byTruncatingTail
		label.lineHeight = .relativeToFontSize(multipler: 1)
		label.maximumNumberOfLines = 5
		label.minimumScaleFactor = 0.1
		label.padding = .zero
		label.textColor = .white
		label.linkTapped = { url in
			print("link tapped: \(url)")
		}

		var frame = CGRect(left: 30, top: 120, width: 0, height: 0)
		frame.size = label.sizeThatFitsWidth(300, allowsTruncation: true)
		frame.size.height += 100
		label.frame = frame

		let labelOverlay = View()
		labelOverlay.backgroundColor = UIColor(white: 0, alpha: 0.2)
		labelOverlay.frame = label.rect(forLine: 2, in: label)
		label.addSubview(labelOverlay)

		let label2 = UILabel()
		label2.adjustsFontSizeToFitWidth = false
		label2.backgroundColor = .red
		label2.font = font
		label2.lineBreakMode = .byTruncatingTail
		label2.minimumScaleFactor = 1
		label2.numberOfLines = 5
		label2.textAlignment = .left
		label2.textColor = .white
		label2.attributedText = text

		var frame2 = CGRect(left: 30, top: 400, width: 0, height: 0)
		frame2.size = label2.sizeThatFitsWidth(300, allowsTruncation: true)
		frame2.size.height += 100
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
