import Foundation


internal enum MeasuresStrings {

	internal enum CompassDirection {

		internal enum Long {

			internal static var east: String
				{ return __string("compassDirection.long.east") }

			internal static var north: String
				{ return __string("compassDirection.long.north") }

			internal static var south: String
				{ return __string("compassDirection.long.south") }

			internal static var west: String
				{ return __string("compassDirection.long.west") }
		}


		internal enum Short {

			internal static var east: String
				{ return __string("compassDirection.short.east") }

			internal static var eastNorthEast: String
				{ return __string("compassDirection.short.eastNorthEast") }

			internal static var eastSouthEast: String
				{ return __string("compassDirection.short.eastSouthEast") }

			internal static var north: String
				{ return __string("compassDirection.short.north") }

			internal static var northEast: String
				{ return __string("compassDirection.short.northEast") }

			internal static var northNorthEast: String
				{ return __string("compassDirection.short.northNorthEast") }

			internal static var northNorthWest: String
				{ return __string("compassDirection.short.northNorthWest") }

			internal static var northWest: String
				{ return __string("compassDirection.short.northWest") }

			internal static var south: String
				{ return __string("compassDirection.short.south") }

			internal static var southEast: String
				{ return __string("compassDirection.short.southEast") }

			internal static var southSouthEast: String
				{ return __string("compassDirection.short.southSouthEast") }

			internal static var southSouthWest: String
				{ return __string("compassDirection.short.southSouthWest") }

			internal static var southWest: String
				{ return __string("compassDirection.short.southWest") }

			internal static var west: String
				{ return __string("compassDirection.short.west") }

			internal static var westNorthWest: String
				{ return __string("compassDirection.short.westNorthWest") }

			internal static var westSouthWest: String
				{ return __string("compassDirection.short.westSouthWest") }
		}

	}


	internal enum Measure {

		internal static var angle: String
			{ return __string("measure.angle") }

		internal static var length: String
			{ return __string("measure.length") }

		internal static var pressure: String
			{ return __string("measure.pressure") }

		internal static var speed: String
			{ return __string("measure.speed") }

		internal static var temperature: String
			{ return __string("measure.temperature") }

		internal static var time: String
			{ return __string("measure.time") }
	}


	internal enum Unit {

		internal enum Centimeter {

			internal static var abbreviation: String
				{ return __string("unit.centimeter.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.centimeter.name") }
		}


		internal enum Degree {

			internal static var abbreviation: String
				{ return __string("unit.degree.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.degree.name") }
		}


		internal enum DegreeCelsius {

			internal static var abbreviation: String
				{ return __string("unit.degreeCelsius.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.degreeCelsius.name") }
		}


		internal enum DegreeFahrenheit {

			internal static var abbreviation: String
				{ return __string("unit.degreeFahrenheit.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.degreeFahrenheit.name") }
		}


		internal enum Foot {

			internal static var abbreviation: String
				{ return __string("unit.foot.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.foot.name") }
		}


		internal enum Hour {

			internal static var abbreviation: String
				{ return __string("unit.hour.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.hour.name") }
		}


		internal enum Inch {

			internal static var abbreviation: String
				{ return __string("unit.inch.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.inch.name") }
		}


		internal enum InchOfMercury {

			internal static var abbreviation: String
				{ return __string("unit.inchOfMercury.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.inchOfMercury.name") }
		}


		internal enum Kilometer {

			internal static var abbreviation: String
				{ return __string("unit.kilometer.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.kilometer.name") }
		}


		internal enum KilometerPerHour {

			internal static var abbreviation: String
				{ return __string("unit.kilometerPerHour.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.kilometerPerHour.name") }
		}


		internal enum Knot {

			internal static var abbreviation: String
				{ return __string("unit.knot.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.knot.name") }
		}


		internal enum Meter {

			internal static var abbreviation: String
				{ return __string("unit.meter.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.meter.name") }
		}


		internal enum Mile {

			internal static var abbreviation: String
				{ return __string("unit.mile.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.mile.name") }
		}


		internal enum MilePerHour {

			internal static var abbreviation: String
				{ return __string("unit.milePerHour.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.milePerHour.name") }
		}


		internal enum Millibar {

			internal static var abbreviation: String
				{ return __string("unit.millibar.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.millibar.name") }
		}


		internal enum Minute {

			internal static var abbreviation: String
				{ return __string("unit.minute.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.minute.name") }
		}


		internal enum Radian {

			internal static var abbreviation: String
				{ return __string("unit.radian.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.radian.name") }
		}


		internal enum Second {

			internal static var abbreviation: String
				{ return __string("unit.second.abbreviation") }

			internal static var name: PluralizedString
				{ return __PluralizedString("unit.second.name") }
		}

	}

}



private let __bundle: Bundle = {
	class Dummy {}

	return Bundle(for: Dummy.self)
}()


private let __defaultFormatter: NumberFormatter = {
	let formatter = NumberFormatter()
	formatter.locale = Locale.autoupdatingCurrent
	formatter.numberStyle = .decimal

	return formatter
}()


private func __keySuffix(`for` category: Locale.PluralCategory) -> String {
	switch category {
	case .few:   return "$few"
	case .many:  return "$many"
	case .one:   return "$one"
	case .other: return "$other"
	case .two:   return "$two"
	case .zero:  return "$zero"
	}
}


private func __string(_ key: String, parameters: [String : String]? = nil) -> String {
	return __tryString(key).map { __substituteTemplateParameters(template: $0, parameters: parameters) } ?? key
}


private func __string(_ key: String, pluralCategory: Locale.PluralCategory, parameters: [String : String]?) -> String {
	guard let template = __tryString(key, pluralCategory: pluralCategory) else {
		return key
	}

	return __substituteTemplateParameters(template: template, parameters: parameters)
}


private func __string(_ key: String, number: NSNumber, formatter: NumberFormatter, parameters: [String : String]?) -> String {
	return __string(key, pluralCategory: Locale.current.pluralCategoryForNumber(number, formatter: formatter), parameters: parameters)
}


private func __substituteTemplateParameters(template: String, parameters: [String : String]?) -> String {
	guard let parameters = parameters else {
		return template
	}

	var result = ""
	return __substituteTemplateParameters(
		template:    template,
		onCharacter: { result.append($0) },
		onParameter: { result += parameters[$0] ?? "{\($0)}" }
	) ? result : template
}


private func __substituteTemplateParameters(template: String, onCharacter: (Character) -> Void, onParameter: (String) -> Void) -> Bool {
	var currentParameter = ""
	var isParsingParameter = false
	var isAwaitingClosingCurlyBracket = false

	for character in template.characters {
		if isAwaitingClosingCurlyBracket && character != "}" {
			return false
		}

		switch character {
		case "{":
			if isParsingParameter {
				if !currentParameter.isEmpty {
					return false
				}

				isParsingParameter = false
				onCharacter("{")
			}
			else {
				isParsingParameter = true
			}

		case "}":
			if isParsingParameter {
				if currentParameter.isEmpty {
					return false
				}

				onParameter(currentParameter)
				currentParameter = ""
				isParsingParameter = false
			}
			else if isAwaitingClosingCurlyBracket {
				isAwaitingClosingCurlyBracket = false
			}
			else {
				onCharacter("}")
				isAwaitingClosingCurlyBracket = true
			}

		default:
			if isParsingParameter {
				currentParameter.append(character)
			}
			else {
				onCharacter(character)
			}
		}
	}

	guard !isParsingParameter && !isAwaitingClosingCurlyBracket else {
		return false
	}

	return true
}


private func __tryString(_ key: String) -> String? {
	let value = __bundle.localizedString(forKey: key, value: "\u{0}", table: "MeasuresLocalizable")
	guard value != "\u{0}" else {
		return nil
	}

	return value
}


private func __tryString(_ key: String, pluralCategory: Locale.PluralCategory) -> String? {
	let keySuffix = __keySuffix(for: pluralCategory)
	return __tryString("\(key)\(keySuffix)") ?? __tryString("\(key)$other")
}



fileprivate struct __PluralizedString: PluralizedString {

	private var key: String
	private var parameters: [String : String]?


	fileprivate init(_ key: String, parameters: [String : String]? = nil) {
		self.key = key
		self.parameters = parameters
	}


	fileprivate func forPluralCategory(_ pluralCategory: Locale.PluralCategory) -> String {
		return __string(key, pluralCategory: pluralCategory, parameters: parameters)
	}
}
