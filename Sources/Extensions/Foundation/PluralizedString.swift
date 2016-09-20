import Foundation


public protocol PluralizedString {

	func forPluralCategory(pluralCategory: NSLocale.PluralCategory) -> String
}


public extension PluralizedString {

	public func forNumber(number: NSNumber, formatter: NSNumberFormatter = NSLocale.defaultDecimalFormatterForResolvingPluralCategory, locale: NSLocale = NSLocale.currentLocale()) -> String {
		return forPluralCategory(locale.pluralCategoryForNumber(number, formatter: formatter))
	}
}
