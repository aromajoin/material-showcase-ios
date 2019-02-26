Change Log
==========
Version 0.6.5 *(2019-02-26)*
--------------------------------
* Allow subtitle instruction text to have more than 3 lines

Version 0.6.4 *(2018-11-10)*
-------------------------------
* Fix issue #74 and #81 concerning primary and secondary label overlap when some libraries override UIView control methods.

Version 0.6.3 *(2018-09-30)*
-------------------------------
* Update to Swift 4.2
* Fix a spelling in API 

### Upgrade note
If it's possible to change the *Swift* **version** follow this:
* Update your project *Swift* version to **4.2**, to avoid getting `'KeyframeAnimationOptions' is not a member type of 'UIView'` error for supporting the `Swift 4.2`.

Otherwise: 
* If your project swift version is not 4.2, add below the Cocoapods script to your `Podfile` and run `pod install` after that:
```
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

Version 0.6.2 *(2018-07-18)*
-------------------------------
* Fix bugs

Version 0.6.1 *(2018-06-04)*
-------------------------------
* Add Carthage support
* Add user-tap check property

### Upgrade note

* Changed the [signature of delegate methods](https://github.com/aromajoin/material-showcase-ios#handle-showcase-status).

Please, update delegate methods :
```swift
func showCaseWillDismiss(showcase: MaterialShowcase)
func showCaseDidDismiss(showcase: MaterialShowcase)
```
to:
```swift
func showCaseWillDismiss(showcase: MaterialShowcase, didTapTarget:Bool)

func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget:Bool)
```

Version 0.6.0 *(2018-05-09)*
--------------------------------
* Add fullscreen mode in addition to circle background
* Refactor background view

Version 0.5.2 *(2018-04-03)*
--------------------------------
* Fix instruction view frame calculation issue

Version 0.5.1 *(2018-03-14)*
--------------------------------
* Fix the issue in which properties are missing in Objective-C project

Version 0.5.0 *(2018-03-12)*
--------------------------------
* Fix out-of-screen text error on iPad
* Add text alignment to support both LTR and RTL text

Version 0.4.0 *(2018-02-22)*
--------------------------------
* Add target tap recognizer
* Fix UIKit import issue for Reactive Native bridge
* Change `view.copyView` to use Apple official API `view.snapshotView`

Version 0.3.1 *(2017-11-21)*
--------------------------------
* Refactor codes
* Fix bug
* Improve animation

Version 0.3.0 *(2017-11-11)*
--------------------------------
* Fix bug of failing to deal with image button
* Refactor API: set animation as an option and choose whether tint color will be set or not
* Add API: find presented showcases

Version 0.2.0 *(2017-10-29)*
----------------------------
* Fix bug, crash on iOS 11 when targeting BarButtonItem and custom buttons were not displayed
* Allow to add custom fonts

Version 0.1.4 *(2017-07-28)*
----------------------------
* Fix bugs
* Add delegate to handle showcase dismiss

Version 0.1.3 *(2017-07-11)*
----------------------------
* Fix bugs

Version 0.1.2 *(2017-05-25)*
----------------------------
* Fix bugs

Version 0.1.1 *(2017-05-12)*
----------------------------
* Fix Build settings

Version 0.1.0 *(2017-05-11)*
----------------------------
* Initial release

