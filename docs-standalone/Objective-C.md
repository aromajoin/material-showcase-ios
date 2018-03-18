# Objective-C usage

After installing `MaterialShowcase` pod, please follow the below instructions to set it up in Objective-C project.

![Objective-C showcase](https://raw.githubusercontent.com/Husseinhj/material-showcase-ios/fix/objc_property/art/ObjectiveCSupportScreenshot.png)

**OR**

Add below Cocoapods script to your pod file :

``` ruby
# platform :ios, '9.0'

target 'YOUR_PROJECT_NAME' do
  use_frameworks!

  pod 'MaterialShowcase'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name.include?('MaterialShowcase')
        target.build_configurations.each do |config|
           config.build_settings['SWIFT_VERSION'] = '3.2'
        end
      end
    end
  end

end
```

Using `#import "MaterialShowcase-Swift.h"` to import library to your class.
