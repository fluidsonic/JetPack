import Foundation


public final class CommandLineInterface: NSObject {

	private override init() {}


	public static func run(arguments: [String]) -> Int32 {
		guard arguments.count == 3 else {
			print("Usage: \(arguments.first ?? "cli") <input file> <output file>")
			return 1
		}

		let inputFile = arguments[1]
		let outputFile = arguments[2]

		guard let inputData = try? Data(contentsOf: URL(fileURLWithPath: inputFile)) else {
			print("Cannot open input file '\(inputFile)'.")
			return 1
		}

		let parser = PluralRulesParser()
		do {
			let ruleSets = try parser.parse(xml: inputData)
			let swiftCode = SwiftCodeGenerator().generate(for: ruleSets)

			guard let outputData = swiftCode.data(using: .utf8) else {
				print("Cannot encode output as UTF8.")
				return 1
			}

			try outputData.write(to: URL(fileURLWithPath: outputFile), options: .atomicWrite)
			return 0
		}
		catch let error {
			print(String(describing: error))
			return 1
		}
	}
}
