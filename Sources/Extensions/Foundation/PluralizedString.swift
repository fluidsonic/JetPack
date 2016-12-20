import Foundation


public protocol PluralizedString {

	func forPluralCategory(_ pluralCategory: Locale.PluralCategory) -> String
}


public extension PluralizedString {

	public func forNumber(_ number: NSNumber, formatter: NumberFormatter = Locale.defaultDecimalFormatterForResolvingPluralCategory, locale: Locale = Locale.current) -> String {
		return forPluralCategory(locale.pluralCategoryForNumber(number, formatter: formatter))
	}
}
