Pod::Spec.new do |s|

	s.name    = 'JetPack'
	s.version = '0.0.1'

	s.author   = { 'Marc Knaup' => 'marc@knaup.koeln' }
	s.homepage = 'https://github.com/fluidsonic/JetPack'
	s.license  = 'MIT'
	s.platform = :ios, '8.0'
	s.source   = { :git => 'https://github.com/fluidsonic/JetPack.git' }
	s.summary  = 'A Swiss Army knife for iOS development with Swift in a very early stage.'

	s.module_map    = 'Module/JetPack.modulemap'
	s.source_files  = ['Sources/**/*.swift', 'Module/JetPack.h']
	s.exclude_files = 'Sources/JetPack.swift'
	s.frameworks    = 'CoreGraphics', 'CoreImage', 'Foundation', 'Photos', 'UIKit'
end
