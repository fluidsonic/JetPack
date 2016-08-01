import Foundation


public extension NSLocale {

	internal typealias PluralCategoryResolver = (f: NSNumber, fMod: Int, i: NSNumber, iMod: Int, n: NSNumber, nMod: Int, t: NSNumber, v: Int) -> PluralCategory


	@nonobjc
	public static let englishUnitedStatesComputer = NSLocale(localeIdentifier: "en_US_POSIX")


	@nonobjc
	public func pluralCategoryForNumber(number: NSNumber, formatter: NSNumberFormatter = simpleDecimalFormatter) -> PluralCategory {
		guard let formatter = formatter.copy() as? NSNumberFormatter else {
			return .other
		}

		formatter.locale = NSLocale.englishUnitedStatesComputer
		formatter.currencyDecimalSeparator = "."
		formatter.decimalSeparator = "."
		formatter.maximumIntegerDigits = max(formatter.maximumIntegerDigits, 1)
		formatter.minimumIntegerDigits = 1
		formatter.usesGroupingSeparator = false

		guard let formattedNumber = formatter.stringFromNumber(number) else {
			return .other
		}
		guard let match = formattedNumber.firstMatchForRegularExpression(NSLocale.pluralCategoryNumberPattern) else {
			return .other
		}

		guard let
			wholeNumber = match[0],
			integerPart = match[1],
			f = simpleDecimalFormatter.numberFromString(match[2] ?? "0"),
			i = simpleDecimalFormatter.numberFromString(integerPart),
			n = simpleDecimalFormatter.numberFromString(wholeNumber),
			t = simpleDecimalFormatter.numberFromString(match[3] ?? "0")
		else {
			return .other
		}

		let v = match[2]?.characters.count ?? 0

		return pluralCategoryForOperands(f: f, i: i, n: n, t: t, v: v)
	}


	@nonobjc
	private func pluralCategoryForOperands(f f: NSNumber, i: NSNumber, n: NSNumber, t: NSNumber, v: Int) -> PluralCategory {
		/*
		http://unicode.org/reports/tr35/tr35-numbers.html#Operands
		n	absolute value of the source number (integer and decimals).
		i	integer digits of n.
		v	number of visible fraction digits in n, with trailing zeros.
		w	number of visible fraction digits in n, without trailing zeros. (not yet used)
		f	visible fractional digits in n, with trailing zeros.
		t	visible fractional digits in n, without trailing zeros.
		*/

		let fMod = f.modulo(1_000_000_000)
		let iMod = i.modulo(1_000_000_000)
		let nMod = n.modulo(1_000_000_000)

		if let resolver = NSLocale.pluralCategoryResolversByLocaleIdentifier[localeIdentifier] {
			return resolver(f: f, fMod: fMod, i: i, iMod: iMod, n: n, nMod: nMod, t: t, v: v)
		}

		var components = NSLocale.canonicalLocaleIdentifierFromString(localeIdentifier).componentsSeparatedByString("_")
		components.removeLast()

		while !components.isEmpty {
			let localeIdentifier = components.joinWithSeparator("_")
			if let resolver = NSLocale.pluralCategoryResolversByLocaleIdentifier[localeIdentifier] {
				return resolver(f: f, fMod: fMod, i: i, iMod: iMod, n: n, nMod: nMod, t: t, v: v)
			}

			components.removeLast()
		}

		return .other
	}


	@nonobjc
	private static let pluralCategoryNumberPattern = try! NSRegularExpression(pattern: "(\\d+)(?:\\.((\\d+?)0*)(?![0-9]))?", options: [])


	@nonobjc
	public var uses24HourFormat: Bool {
		return !(NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: self)?.containsString("a") ?? false)
	}


	@nonobjc
	public var usesMetricSystem: Bool {
		return objectForKey(NSLocaleUsesMetricSystem) as? Bool ?? false
	}


	// Swift bug - cannot nest type at the moment
	public typealias PluralCategory = _NSLocale_PluralCategory
}


public enum _NSLocale_PluralCategory {

	case few
	case many
	case one
	case other
	case two
	case zero
}



private let simpleDecimalFormatter: NSNumberFormatter = {
	let formatter = NSNumberFormatter()
	formatter.locale = NSLocale.englishUnitedStatesComputer
	formatter.numberStyle = .DecimalStyle
	return formatter
}()
