@import Foundation;
@import PluralRulesGenerator;


int main(int argc, const char* argv[]) {
	@autoreleasepool {
		return [CommandLineInterface runWithArguments:NSProcessInfo.processInfo.arguments];
	}
}
