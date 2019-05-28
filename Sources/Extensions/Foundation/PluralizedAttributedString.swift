import Foundation


public protocol PluralizedAttributedString {

	func forPluralCategory(_ pluralCategory: Locale.PluralCategory) -> NSAttributedString
}


public extension PluralizedAttributedString {

	func forNumber(_ number: NSNumber, formatter: NumberFormatter = Locale.defaultDecimalFormatterForResolvingPluralCategory, locale: Locale = Locale.current) -> NSAttributedString {
		return forPluralCategory(locale.pluralCategoryForNumber(number, formatter: formatter))
	}
}
