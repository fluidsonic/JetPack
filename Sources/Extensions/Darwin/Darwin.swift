import Darwin



internal func arc4random<Element: ExpressibleByIntegerLiteral>() -> Element {
	var random: Element = 0
	arc4random_buf(&random, MemoryLayout<Element>.size)
	return random
}
