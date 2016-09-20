import Foundation


internal enum `MeasuresStrings` {

	internal enum `Unit` {

		internal enum `Hour` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.hour.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.hour.name") }
		}


		internal enum `MilePerHour` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.milePerHour.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.milePerHour.name") }
		}


		internal enum `Millibar` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.millibar.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.millibar.name") }
		}


		internal enum `DegreeCelsius` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.degreeCelsius.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.degreeCelsius.name") }
		}


		internal enum `Meter` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.meter.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.meter.name") }
		}


		internal enum `Inch` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.inch.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.inch.name") }
		}


		internal enum `Kilometer` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.kilometer.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.kilometer.name") }
		}


		internal enum `InchOfMercury` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.inchOfMercury.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.inchOfMercury.name") }
		}


		internal enum `Second` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.second.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.second.name") }
		}


		internal enum `Mile` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.mile.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.mile.name") }
		}


		internal enum `Radian` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.radian.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.radian.name") }
		}


		internal enum `Foot` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.foot.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.foot.name") }
		}


		internal enum `Degree` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.degree.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.degree.name") }
		}


		internal enum `KilometerPerHour` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.kilometerPerHour.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.kilometerPerHour.name") }
		}


		internal enum `Minute` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.minute.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.minute.name") }
		}


		internal enum `Centimeter` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.centimeter.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.centimeter.name") }
		}


		internal enum `DegreeFahrenheit` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.degreeFahrenheit.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.degreeFahrenheit.name") }
		}


		internal enum `Knot` {

			internal static var `abbreviation`: String { return `MeasuresStrings`.__getWithFallback("unit.knot.abbreviation") }
			internal static var `name`: PluralizedString { return __PluralizedString(key: "unit.knot.name") }
		}

	}


	internal enum `CompassDirection` {

		internal enum `Long` {

			internal static var `east`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.long.east") }
			internal static var `south`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.long.south") }
			internal static var `west`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.long.west") }
			internal static var `north`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.long.north") }
		}


		internal enum `Short` {

			internal static var `east`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.east") }
			internal static var `southWest`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.southWest") }
			internal static var `west`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.west") }
			internal static var `north`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.north") }
			internal static var `southEast`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.southEast") }
			internal static var `northWest`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.northWest") }
			internal static var `eastSouthEast`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.eastSouthEast") }
			internal static var `southSouthEast`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.southSouthEast") }
			internal static var `southSouthWest`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.southSouthWest") }
			internal static var `eastNorthEast`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.eastNorthEast") }
			internal static var `northEast`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.northEast") }
			internal static var `westSouthWest`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.westSouthWest") }
			internal static var `northNorthWest`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.northNorthWest") }
			internal static var `south`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.south") }
			internal static var `northNorthEast`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.northNorthEast") }
			internal static var `westNorthWest`: String { return `MeasuresStrings`.__getWithFallback("compassDirection.short.westNorthWest") }
		}

	}


	internal enum `Measure` {

		internal static var `speed`: String { return `MeasuresStrings`.__getWithFallback("measure.speed") }
		internal static var `length`: String { return `MeasuresStrings`.__getWithFallback("measure.length") }
		internal static var `angle`: String { return `MeasuresStrings`.__getWithFallback("measure.angle") }
		internal static var `pressure`: String { return `MeasuresStrings`.__getWithFallback("measure.pressure") }
		internal static var `temperature`: String { return `MeasuresStrings`.__getWithFallback("measure.temperature") }
		internal static var `time`: String { return `MeasuresStrings`.__getWithFallback("measure.time") }
	}



	private static let __bundle: NSBundle = {
		class Dummy {}

		return NSBundle(forClass: Dummy.self)
	}()


	private static func __get(key: String) -> String? {
		let value = __bundle.localizedStringForKey(key, value: "\u{0}", table: "MeasuresLocalizable")
		guard value != "\u{0}" else {
			return nil
		}

		return value
	}


	private static func __getTemplate(key: String, parameters: [String : String]) -> String {
		guard let value = __get(key) else {
			return key
		}

		return __substituteTemplateParameters(value, parameters: parameters)
	}


	private static func __getWithFallback(key: String) -> String {
		return __bundle.localizedStringForKey(key, value: key, table: "MeasuresLocalizable")
	}


	private static func __substituteTemplateParameters(template: String, parameters: [String : String]) -> String {
		var result = ""

		var currentParameter = ""
		var isParsingParameter = false
		var isAwaitingClosingCurlyBracket = false

		for character in template.characters {
			if isAwaitingClosingCurlyBracket && character != "}" {
				return template
			}

			switch character {
			case "{":
				if isParsingParameter {
					if !currentParameter.isEmpty {
						return template
					}

					isParsingParameter = false
					result += "{"
				}
				else {
					isParsingParameter = true
				}

			case "}":
				if isParsingParameter {
					if currentParameter.isEmpty {
						return template
					}

					result += parameters[currentParameter] ?? "{\(currentParameter)}"
					currentParameter = ""
					isParsingParameter = false
				}
				else if isAwaitingClosingCurlyBracket {
					isAwaitingClosingCurlyBracket = false
				}
				else {
					result += "}"
					isAwaitingClosingCurlyBracket = true
				}

			default:
				if isParsingParameter {
					currentParameter.append(character)
				}
				else {
					result.append(character)
				}
			}
		}

		guard !isParsingParameter && !isAwaitingClosingCurlyBracket else {
			return template
		}

		return result
	}



	private struct __PluralizedString: PluralizedString {

		private var converter: ((String) -> String)?
		private var key: String


		private init(key: String, converter: ((String) -> String)? = nil) {
			self.converter = converter
			self.key = key
		}


		private func forPluralCategory(category: NSLocale.PluralCategory) -> String {
			let keySuffix = keySuffixForPluralCategory(category)

			guard var value = `MeasuresStrings`.__get("\(key)\(keySuffix)") ?? `MeasuresStrings`.__get("\(key)$other") else {
				return "\(key)$other"
			}

			if let converter = converter {
				value = converter(value)
			}

			return value
		}


		private func keySuffixForPluralCategory(category: NSLocale.PluralCategory) -> String {
			switch category {
			case .few:   return "$few"
			case .many:  return "$many"
			case .one:   return "$one"
			case .other: return "$other"
			case .two:   return "$two"
			case .zero:  return "$zero"
			}
		}
	}
}
