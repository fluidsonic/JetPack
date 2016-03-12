import Darwin


@warn_unused_result
internal func arc4random<Element: IntegerLiteralConvertible>() -> Element {
	var random: Element = 0
	arc4random_buf(&random, sizeof(Element))
	return random
}
