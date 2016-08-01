import AEXML
import Foundation


// http://unicode.org/reports/tr35/tr35-numbers.html#Language_Plural_Rules
// http://cldr.unicode.org/index/downloads
internal struct PluralRulesParser {

	public func parse(xml data: NSData) throws -> [PluralRuleSet] {
		let xml = try AEXMLDocument(xmlData: data)
		return try xml["supplementalData"]["plurals"].all?
			.filter { $0.attributes["type"] == "cardinal" }
			.flatMap { $0["pluralRules"].all ?? [] }
			.map(parseRuleSet) ?? []
	}


	private func parseRule(xml xml: AEXMLElement) throws -> PluralRule {
		guard let category = xml.attributes["count"] else {
			throw Error(message: "Plural rule node is missing attribute 'count'.")
		}

		let tokens = try xml.stringValue
			.componentsSeparatedByString("@")[0]
			.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
			.componentsSeparatedByCharactersInSet(.whitespaceCharacterSet())
			.map(parseRuleToken)

		var expressionParser = ExpressionParser(tokens: tokens)
		let expression = try expressionParser.parse()

		return PluralRule(category: category, expression: expression)
	}


	private func parseRuleSet(xml xml: AEXMLElement) throws -> PluralRuleSet {
		guard let locales = xml.attributes["locales"]?.componentsSeparatedByCharactersInSet(.whitespaceCharacterSet()) where !locales.isEmpty else {
			throw Error(message: "Plural rule set node is missing attribute 'locales'.")
		}

		let rules = try xml["pluralRule"].all?
			.filter { $0.attributes["count"] != "other" }
			.map(parseRule) ?? []

		return PluralRuleSet(locales: Set(locales), rules: rules)
	}


	private func parseRuleToken(string: String) throws -> RuleToken {
		switch string {
		case "f", "i", "n", "t", "v": return .variable(string)
		case "%":                     return .modulus
		case "=":                     return .equal
		case "!=":                    return .notEqual
		case "and":                   return .and
		case "or":                    return .or

		default:
			if string.containsString(",") {
				let values = try string.componentsSeparatedByString(",").map { (component: String) -> PluralRule.Value in
					guard let value = try parseRuleValue(component) else {
						throw Error(message: "Invalid plural rule value '\(component)' in value list '\(string)' in expression.")
					}

					return value
				}

				return .multipleConstants(values)
			}
			else if let value = try parseRuleValue(string) {
				return .constant(value)
			}

			throw Error(message: "Unknown token '\(string)' in rule.")
		}
	}


	private func parseRuleValue(string: String) throws -> PluralRule.Value? {
		if !string.isEmpty && string.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) == nil {
			guard let number = Int(string) else {
				throw Error(message: "Invalid plural rule value '\(string)' in expression.")
			}

			return .number(number)
		}
		else if string.containsString("..") {
			let components = string.componentsSeparatedByString("..")
			guard components.count == 2 else {
				throw Error(message: "Invalid plural rule value range '\(string)' in expression.")
			}
			guard let start = Int(components[0]) else {
				throw Error(message: "Invalid plural rule start value '\(components[0])' in range '\(string)' in expression.")
			}
			guard let end = Int(components[1]) else {
				throw Error(message: "Invalid plural rule end value '\(components[1])' in range '\(string)' in expression.")
			}

			return .numberRange(start ... end)
		}

		return nil
	}



	internal struct Error: ErrorType {

		internal var message: String


		internal init(message: String) {
			self.message = message
		}
	}



	private struct ExpressionParser {

		private var index = 0
		private let tokens: [RuleToken]


		private init(tokens: [RuleToken]) {
			self.tokens = tokens
		}


		private mutating func consumeCurrentToken() -> RuleToken {
			let token = tokens[index]
			index += 1
			return token
		}


		private var currentToken: RuleToken? {
			guard index < tokens.count else {
				return nil
			}

			return tokens[index]
		}


		private func operatorForToken(token: RuleToken) -> PluralRule.BinaryOperator? {
			switch token {
			case .and:      return .and
			case .equal:    return .equal
			case .modulus:  return .modulus
			case .notEqual: return .notEqual
			case .or:       return .or
			default:        return nil
			}
		}


		private mutating func parse() throws -> PluralRule.Expression {
			return try parseExpression()
		}


		private mutating func parseExpression() throws -> PluralRule.Expression {
			return try parseOperation(left: try parseValueOrVariable())
		}


		private mutating func parseOperation(left left: PluralRule.Expression, precedenceOfPreviousOperator: Int = 0) throws -> PluralRule.Expression {
			var left = left

			while let currentToken = currentToken {
				guard let op = operatorForToken(currentToken) else {
					throw Error(message: "Unexpected token '\(currentToken)' in rule.")
				}

				let tokenPrecedence = precedenceForOperator(op)
				if tokenPrecedence < precedenceOfPreviousOperator {
					return left
				}

				consumeCurrentToken()

				var right = try parseValueOrVariable()
				if let nextToken = self.currentToken, nextOp = operatorForToken(nextToken) where tokenPrecedence < precedenceForOperator(nextOp) {
					right = try parseOperation(left: right, precedenceOfPreviousOperator: tokenPrecedence + 1)
				}

				left = .binaryOperation(left: left, op: op, right: right)
			}
			
			return left
		}


		private mutating func parseValueOrVariable() throws -> PluralRule.Expression {
			let token = consumeCurrentToken()
			switch token {
			case let .constant(value):           return .constant(value)
			case let .multipleConstants(values): return .multipleConstants(values)
			case let .variable(name):            return .variable(name)

			default:
				throw Error(message: "Unexpected token '\(token)' in expression. Expected a variable or a value.")
			}
		}


		private func precedenceForOperator(op: PluralRule.BinaryOperator) -> Int {
			switch op {
			case .and:      return 60
			case .or:       return 40
			case .equal:    return 80
			case .modulus:  return 100
			case .notEqual: return 80
			}
		}
	}



	private enum RuleToken {

		case and
		case constant(PluralRule.Value)
		case equal
		case modulus
		case multipleConstants([PluralRule.Value])
		case notEqual
		case or
		case variable(String)
	}
}
