internal struct PluralRuleSet {

	internal var locales: Set<String>
	internal var rules: [PluralRule]


	internal init(locales: Set<String>, rules: [PluralRule]) {
		self.locales = locales
		self.rules = rules
	}
}
