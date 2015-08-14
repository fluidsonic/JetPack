Pod::Spec.new do |s|

	s.name    = "JetPack"
	s.version = "0.0.1"

	s.author   = { "Marc Knaup" => "marc@knaup.koeln" }
	s.homepage = "https://github.com/fluidsonic/JetPack"
	s.license  = "MIT"
	s.platform = :ios, "7.0"
	s.source   = { :git => "https://github.com/fluidsonic/JetPack.git" }
	s.summary  = "A Swiss Army knife for iOS development with Swift in a very early stage."

	s.source_files    = "sources/**/*.swift"
	s.exclude_files   = "sources/JetPack.swift"
	s.frameworks      = "CoreGraphics", "Foundation", "UIKit"
	s.weak_frameworks = "AssetsLibrary", "Photos"
end
