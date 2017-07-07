import Foundation


public extension Locale {

	internal typealias PluralCategoryResolver = (_ f: NSNumber, _ fMod: Int, _ i: NSNumber, _ iMod: Int, _ n: NSNumber, _ nMod: Int, _ t: NSNumber, _ v: Int) -> PluralCategory


	@nonobjc
	public static let defaultDecimalFormatterForResolvingPluralCategory: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.locale = Locale.englishUnitedStatesComputer
		formatter.numberStyle = .decimal
		return formatter
	}()


	@nonobjc
	public static let display = Bundle.main.preferredLocalizations.first.map { Locale(identifier: Locale.canonicalLanguageIdentifier(from: $0)) } ?? .autoupdatingCurrent


	@nonobjc
	public static let englishUnitedStatesComputer = Locale(identifier: "en_US_POSIX")


	
	public func pluralCategoryForNumber(_ number: NSNumber, formatter: NumberFormatter = defaultDecimalFormatterForResolvingPluralCategory) -> PluralCategory {
		guard let formatter = formatter.copy() as? NumberFormatter else {
			return .other
		}

		formatter.locale = Locale.englishUnitedStatesComputer
		formatter.currencyDecimalSeparator = "."
		formatter.decimalSeparator = "."
		formatter.maximumIntegerDigits = max(formatter.maximumIntegerDigits, 1)
		formatter.minimumIntegerDigits = 1
		formatter.usesGroupingSeparator = false

		guard let formattedNumber = formatter.string(from: number) else {
			return .other
		}
		guard let match = formattedNumber.firstMatchForRegularExpression(Locale.pluralCategoryNumberPattern) else {
			return .other
		}

		let simpleDecimalFormatter = Locale.defaultDecimalFormatterForResolvingPluralCategory
		guard let
			wholeNumber = match[0],
			let integerPart = match[1],
			let f = simpleDecimalFormatter.number(from: match[2]?.toString() ?? "0"),
			let i = simpleDecimalFormatter.number(from: integerPart.toString()),
			let n = simpleDecimalFormatter.number(from: wholeNumber.toString()),
			let t = simpleDecimalFormatter.number(from: match[3]?.toString() ?? "0")
		else {
			return .other
		}

		let v = match[2]?.characters.count ?? 0

		return pluralCategoryForOperands(f: f, i: i, n: n, t: t, v: v)
	}


	
	fileprivate func pluralCategoryForOperands(f: NSNumber, i: NSNumber, n: NSNumber, t: NSNumber, v: Int) -> PluralCategory {
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

		if let resolver = Locale.pluralCategoryResolversByLocaleIdentifier[identifier] {
			return resolver(f, fMod, i, iMod, n, nMod, t, v)
		}

		var components = Locale.canonicalIdentifier(from: identifier).components(separatedBy: "_")
		components.removeLast()

		while !components.isEmpty {
			let localeIdentifier = components.joined(separator: "_")
			if let resolver = Locale.pluralCategoryResolversByLocaleIdentifier[localeIdentifier] {
				return resolver(f, fMod, i, iMod, n, nMod, t, v)
			}

			components.removeLast()
		}

		return .other
	}


	@nonobjc
	fileprivate static let pluralCategoryNumberPattern = try! NSRegularExpression(pattern: "(\\d+)(?:\\.((\\d+?)0*)(?![0-9]))?", options: [])


	@nonobjc
	public var uses24HourFormat: Bool {
		return !(DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: self)?.contains("a") ?? false)
	}


	@nonobjc
	public var usesMetricSystem9: Bool {
		return (self as NSLocale).object(forKey: NSLocale.Key.usesMetricSystem) as? Bool ?? false
	}


	// Swift bug - cannot nest type at the moment
	public typealias PluralCategory = _Locale_PluralCategory
}


public enum _Locale_PluralCategory {

	case few
	case many
	case one
	case other
	case two
	case zero
}
