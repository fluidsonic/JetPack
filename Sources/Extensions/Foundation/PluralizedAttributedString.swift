import Foundation


public protocol PluralizedAttributedString {

	func forPluralCategory(pluralCategory: NSLocale.PluralCategory) -> NSAttributedString
}


public extension PluralizedAttributedString {

	public func forNumber(number: NSNumber, formatter: NSNumberFormatter = NSLocale.defaultDecimalFormatterForResolvingPluralCategory, locale: NSLocale = NSLocale.currentLocale()) -> NSAttributedString {
		return forPluralCategory(locale.pluralCategoryForNumber(number, formatter: formatter))
	}
}
