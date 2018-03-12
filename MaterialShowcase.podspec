Pod::Spec.new do |s|
s.name             = 'MaterialShowcase'
s.version          = '0.5.0'
s.summary          = 'An elegant and beautiful showcase for iOS apps.'

s.description      = <<-DESC
A showcase library for your iOS application which follows Google Material Design guidelines.
DESC

s.homepage         = 'https://github.com/aromajoin/material-showcase-ios'
s.license          = { :type => 'APACHE', :file => 'LICENSE' }
s.author           = { 'Quang Nguyen' => 'quangnguyen@aromajoin.com' }
s.source           = { :git => 'https://github.com/aromajoin/material-showcase-ios.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'
s.source_files = 'MaterialShowcase/*.swift'

end
## Execute push: $pod trunk push MaterialShowcase.podspec
