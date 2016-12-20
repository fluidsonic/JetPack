Pod::Spec.new do |s|

	s.name    = 'PluralRulesGenerator'
	s.version = '0.0.1'

	s.author   = { 'Marc Knaup' => 'marc@knaup.koeln' }
	s.homepage = 'https://github.com/fluidsonic/JetPack'
	s.license  = 'MIT'
	s.source   = { :git => 'https://github.com/fluidsonic/JetPack/Build/PluralRulesGenerator.git' }
	s.summary  = 'Generates plural rules based on Unicode CLDR plural rules.'

	s.frameworks   = 'Foundation'
	s.module_map   = 'Module/Module.modulemap'
	s.source_files = 'Sources/**/*.swift', 'Module/Module.h'

	s.ios.deployment_target = '8.0'
	s.osx.deployment_target = '10.10'

	s.dependency 'AEXML', '~> 4.0.1'
end
