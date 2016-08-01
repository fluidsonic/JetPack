internal class SwiftCodeGenerator {

	private func generate(for binaryOperator: PluralRule.BinaryOperator) -> String {
		switch binaryOperator {
		case .and:      return "&&"
		case .equal:    return "=="
		case .modulus:  return "%"
		case .notEqual: return "!="
		case .or:       return "||"
		}
	}


	private func generate(for expression: PluralRule.Expression) -> String {
		switch expression {
		case let .binaryOperation(left, op, right):
			if case var .multipleConstants(values) = right {
				let firstValue = values.removeFirst()
				let newExpression: PluralRule.Expression = values.reduce(.binaryOperation(left: left, op: op, right: .constant(firstValue))) {
					.binaryOperation(left: $0, op: .or, right: .binaryOperation(left: left, op: op, right: .constant($1)))
				}

				return "(\(generate(for: newExpression)))"
			}

			if case let .constant(.numberRange(range)) = right {
				switch op {
				case .equal:    return "(\(range)).contains(\(generate(for: left)))"
				case .notEqual: return "!(\(range)).contains(\(generate(for: left)))"
				default:        break
				}
			}

			var leftCode = generate(for: left)
			let opCode = generate(for: op)
			var rightCode = generate(for: right)

			switch op {
			case .modulus:
				if case let .variable = left {
					leftCode += "Mod"
				}

			case .or:
				if isLogicalExpression(left) {
					leftCode = "(\(leftCode))"
				}
				if isLogicalExpression(right) {
					rightCode = "(\(rightCode))"
				}

			default:
				break
			}

			return "\(leftCode) \(opCode) \(rightCode)"

		case let .constant(value):
			return generate(for: value)

		case .multipleConstants:
			fatalError("Cannot generate Swift code for multiple constants.")

		case let .variable(name):
			return name
		}
	}


	private func generate(for rule: PluralRule) -> String {
		return "\tif \(generate(for: rule.expression)) { return .\(rule.category) }"
	}


	private func generate(for ruleSet: PluralRuleSet) -> Function {
		let functionName = "resolve_" + ruleSet.locales.joinWithSeparator("$")
		var functionCode = "private func \(functionName)(f f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> NSLocale.PluralCategory {\n"
		if !ruleSet.rules.isEmpty {
			for rule in ruleSet.rules {
				functionCode += generate(for: rule)
				functionCode += "\n"
			}
		}
		functionCode += "\treturn .other\n"
		functionCode += "}\n"

		return Function(code: functionCode, name: functionName)
	}


	internal func generate(for ruleSets: [PluralRuleSet]) -> String {
		var functionNameByLocale = [String : String]()

		var functionCodes = [String]()
		for ruleSet in ruleSets {
			let function = generate(for: ruleSet)
			functionCodes.append(function.code)

			for locale in ruleSet.locales {
				functionNameByLocale[locale] = function.name
			}
		}

		var code = "import Foundation\n\n\n"
		code += "internal extension NSLocale {\n\n"
		code += "\tinternal static let pluralCategoryResolversByLocaleIdentifier: [String : PluralCategoryResolver] = [\n"
		for (locale, functionName) in functionNameByLocale.sort({ $0.0 < $0.1 }) {
			code += "\t\t\""
			code += locale
			code += "\": "
			code += functionName
			code += ",\n"
		}
		code += "\t]\n}\n\n\n"
		code += functionCodes.joinWithSeparator("\n\n")

		return code
	}


	private func generate(for value: PluralRule.Value) -> String {
		switch value {
		case let .number(value):      return String(value)
		case let .numberRange(value): return String(value)
		}
	}


	private func isLogicalExpression(expression: PluralRule.Expression) -> Bool {
		guard case let .binaryOperation(_, op, _) = expression else {
			return false
		}

		return op == .and || op == .or
	}



	private struct Function {

		private var code: String
		private var name: String
	}
}
