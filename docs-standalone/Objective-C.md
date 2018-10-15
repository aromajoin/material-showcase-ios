# Objective-C usage

After installing `MaterialShowcase` pod, please follow the below instructions to set it up in Objective-C project.

![Objective-C showcase](https://raw.githubusercontent.com/Husseinhj/material-showcase-ios/patch-1/art/ObjectiveCSupportScreenshot-3.png)

**OR**

Add below Cocoapods script to your pod file and run `pod install` after that:

``` ruby
# platform :ios, '9.0'

target 'YOUR_PROJECT_NAME' do
  use_frameworks!

  pod 'MaterialShowcase'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name.include?('MaterialShowcase')
        target.build_configurations.each do |config|
           config.build_settings['SWIFT_VERSION'] = '4.2'
        end
      end
    end
  end

end
```

Using `#import "MaterialShowcase-Swift.h"` to import library to your class.
