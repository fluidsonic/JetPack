Pod::Spec.new do |s|

	s.name    = 'JetPack'
	s.version = '0.0.3'

	s.author   = { 'Marc Knaup' => 'marc@knaup.io' }
	s.homepage = 'https://github.com/fluidsonic/JetPack'
	s.license  = 'MIT'
	s.source   = { :git => 'https://github.com/fluidsonic/JetPack.git' }
	s.summary  = 'A Swiss Army knife for iOS development with Swift in a very early stage.'

	s.module_map     = 'Module/JetPack.modulemap'
	s.preserve_paths = 'Sources/JetPack.swift'

	s.ios.deployment_target = '9.0'
	s.osx.deployment_target = '10.10'

	s.subspec 'Core' do |s|
		s.ios.deployment_target = '9.0'
		s.osx.deployment_target = '10.10'

		s.frameworks   = 'Foundation'
		s.source_files = 'Sources/Core/**/*.swift', 'Module/JetPack.h'
	end

	s.subspec 'Deprecated' do |s|
		s.ios.deployment_target = '9.0'

		s.frameworks   = 'Foundation'
		s.source_files = 'Sources/Deprecated/**/*.swift', 'Module/JetPack.h'
	end

	s.subspec 'Experimental' do |s|
		s.ios.deployment_target = '9.0'

		s.frameworks   = 'Foundation', 'UIKit'
		s.source_files = 'Sources/Experimental/**/*.swift', 'Module/JetPack.h'

		s.dependency 'JetPack/Core'
		s.dependency 'JetPack/Extensions/Swift'
	end

	s.subspec 'Extensions' do |s|
		s.subspec 'CoreGraphics' do |s|
			s.ios.deployment_target = '9.0'
			s.osx.deployment_target = '10.10'

			s.frameworks   = 'CoreGraphics'
			s.source_files = 'Sources/Extensions/CoreGraphics/**/*.swift', 'Module/JetPack.h'

			s.dependency 'JetPack/Extensions/Swift'
		end

		s.subspec 'CoreLocation' do |s|
			s.ios.deployment_target = '9.0'
			s.osx.deployment_target = '10.10'

			s.frameworks   = 'CoreLocation'
			s.source_files = 'Sources/Extensions/CoreLocation/**/*.swift', 'Module/JetPack.h'
		end

		s.subspec 'Darwin' do |s|
			s.ios.deployment_target = '9.0'
			s.osx.deployment_target = '10.10'

			s.source_files = 'Sources/Extensions/Darwin/**/*.swift', 'Module/JetPack.h'
		end

		s.subspec 'Foundation' do |s|
			s.ios.deployment_target = '9.0'
			s.osx.deployment_target = '10.10'

			s.frameworks   = 'Foundation'
			s.source_files = 'Sources/Extensions/Foundation/**/*.swift', 'Module/JetPack.h'

			s.dependency 'JetPack/Core'
			s.dependency 'JetPack/Extensions/Swift'
		end

		s.subspec 'MapKit' do |s|
			s.ios.deployment_target = '9.0'
			s.osx.deployment_target = '10.10'

			s.frameworks   = 'CoreLocation', 'MapKit'
			s.source_files = 'Sources/Extensions/MapKit/**/*.swift', 'Module/JetPack.h'

			s.dependency 'JetPack/Extensions/CoreLocation'
			s.dependency 'JetPack/Extensions/Swift'
		end

		s.subspec 'QuartzCore' do |s|
			s.ios.deployment_target = '9.0'

			s.frameworks   = 'Foundation', 'QuartzCore'
			s.source_files = 'Sources/Extensions/QuartzCore/**/*.swift', 'Module/JetPack.h'

			s.dependency 'JetPack/Core'
			s.dependency 'JetPack/Extensions/CoreGraphics'
			s.dependency 'JetPack/Extensions/Foundation'
		end

		s.subspec 'Photos' do |s|
			s.ios.deployment_target = '9.0'

			s.frameworks   = 'Photos'
			s.source_files = 'Sources/Extensions/Photos/**/*.swift', 'Module/JetPack.h'
		end

		s.subspec 'Swift' do |s|
			s.ios.deployment_target = '9.0'
			s.osx.deployment_target = '10.10'

			s.frameworks   = 'Foundation'
			s.source_files = 'Sources/Extensions/Swift/**/*.swift', 'Module/JetPack.h'

			s.dependency 'JetPack/Core'
			s.dependency 'JetPack/Extensions/Darwin'
		end

		s.subspec 'UIKit' do |s|
			s.ios.deployment_target = '9.0'

			s.frameworks   = 'CoreImage', 'Foundation', 'UIKit'
			s.source_files = 'Sources/Extensions/UIKit/**/*.swift', 'Module/JetPack.h'

			s.dependency 'JetPack/Core'
			s.dependency 'JetPack/Experimental'
			s.dependency 'JetPack/Extensions/CoreGraphics'
			s.dependency 'JetPack/Extensions/Foundation'
			s.dependency 'JetPack/Extensions/QuartzCore'
			s.dependency 'JetPack/Extensions/Swift'
		end
	end

	s.subspec 'Measures' do |s|
		s.ios.deployment_target = '9.0'

		s.source_files = 'Sources/Measures/**/*.swift', 'Module/JetPack.h'
		s.resources    = 'Sources/Measures/Resources/**/*.strings'

		s.dependency 'JetPack/Extensions/Foundation'
		s.dependency 'JetPack/Extensions/Swift'
	end

	s.subspec 'UI' do |s|
		s.ios.deployment_target = '9.0'

		s.frameworks   = 'AVFoundation', 'ImageIO', 'MapKit', 'Photos', 'QuartzCore', 'UIKit', 'WebKit'
		s.source_files = 'Sources/UI/**/*.swift', 'Module/JetPack.h'

		s.dependency 'JetPack/Core'
		s.dependency 'JetPack/Extensions/CoreGraphics'
		s.dependency 'JetPack/Extensions/Foundation'
		s.dependency 'JetPack/Extensions/MapKit'
		s.dependency 'JetPack/Extensions/Swift'
		s.dependency 'JetPack/Extensions/UIKit'
	end
end
