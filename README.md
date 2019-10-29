# Material Showcase for iOS

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Download](https://img.shields.io/cocoapods/v/MaterialShowcase.svg)](https://cocoapods.org/pods/MaterialShowcase)

**An elegant and beautiful tap showcase view for iOS apps based on Material Design Guidelines.**

| ![Screenshots](https://github.com/aromajoin/material-showcase-ios/blob/master/art/material-showcase.gif) | ![Screenshots](https://github.com/aromajoin/material-showcase-ios/blob/master/art/demo2.png) |
| ---------------------------------------- | ---------------------------------------- |


## Requirement
* iOS 8.0+
* Swift 4.2+

## Installation

### CocoaPods
You can install it by using CocoaPods. Please add the following line to your Podfile.
```
pod 'MaterialShowcase'
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:
```bash
$ brew update
$ brew install carthage
```

To integrate MaterialShowcase into your Xcode project using Carthage, specify it in your `Cartfile`:
```ogdl
github "aromajoin/material-showcase-ios" ~> 0.7.1
```

Run `carthage update` to build the framework and drag the built `MaterialShowcase.framework` into your Xcode project.

## Usage

### Objective-C
In order to integrate the library into Object-C project, please follow the instructions from [this doc](https://github.com/Husseinhj/material-showcase-ios/blob/master/docs-standalone/Objective-C.md).

### Basic
```swift
  let showcase = MaterialShowcase()
  showcase.setTargetView(view: button) // always required to set targetView
  showcase.primaryText = "Action 1"
  showcase.secondaryText = "Click here to go into details"
  showcase.show(completion: {
    // You can save showcase state here
    // Later you can check and do not show it again
  })
```
**Note**: `showcase.show()` should be called after your views are placed correctly, for example inside UIViewController's  `viewWillAppear()` or `viewDidAppear()` function. You **SHOULD NOT** call it inside `viewDidLoad()` because views have not laid down correctly yet, `showcase` can not calculate these views positions and it results in unexpected errors.

### Supported target views
There are several target view supported.

```swift
  // Any UIView
  showcase.setTargetView(view: view)
  // UIBarButtonItem
  showcase.setTargetView(barButtonItem: barItem)
  // UITabBar item
  showcase.setTargetView(tabBar: tabBar, itemIndex: 0)
  // UItableViewCell
  showcase.setTargetView(tableView: tableView, section: 0, row: 0)
```

### Enable TapThrough
By default, tapping a showcase's target does not perform it's predefined action. This can be overridden.

```swift
  // UIButton
  showcase.setTargetView(button: button, tapThrough: true)
  // UIBarButtonItem
  showcase.setTargetView(barButtonItem: barItem, tapThrough: true)
  // UITabBar item
  showcase.setTargetView(tabBar: tabBar, itemIndex: 0, tapThrough: true)
```

### Handle showcase status
```swift
  // Right after showing.
  showcase.show(completion: {
    // You can save showcase state here
  })

  // To handle other behaviors when showcase is dismissing, delegate should be declared.
  showcase.delegate = self

  extension ViewController: MaterialShowcaseDelegate {
    func showCaseWillDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
      print("Showcase \(showcase.primaryText) will dismiss.")
    }
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
      print("Showcase \(showcase.primaryText) dimissed.")
    }
  }
```
### Dismiss showcase programmatically
```swift
  showcase.completeShowcase(animated: true, didTapTarget: false)
```
### Support both LTR and RTL text alignment
In default, text aligment is set to be left-to-right. If you want to show text in right-to-left direction. Please define following.
```swift
showcase.primaryTextAlignment = .right
showcase.secondaryTextAlignment = .right
```

### Dismiss showcase only if users click to target view
In default, showcase will be dismissed when users click to any place in whole showcase view.
If you want to dismiss showcase only when users click to target view correctly, please set the following property.
```swift
showcase.isTapRecognizerForTargetView = true
```

### Customize UI properties
You can define your own styles based on your app.
```swift
  // Background
  showcase.backgroundAlpha = 0.9
  showcase.backgroundPromptColor = UIColor.blue
  showcase.backgroundPromptColorAlpha = 0.96
  showcase.backgroundViewType = .full // default is .circle
  showcase.backgroundRadius = 300
  // Target
  showcase.targetTintColor = UIColor.blue
  showcase.targetHolderRadius = 44
  showcase.targetHolderColor = UIColor.white
  // Text
  showcase.primaryTextColor = UIColor.white
  showcase.secondaryTextColor = UIColor.white
  showcase.primaryTextSize = 20
  showcase.secondaryTextSize = 15
  showcase.primaryTextFont = UIFont.boldSystemFont(ofSize: primaryTextSize)
  showcase.secondaryTextFont = UIFont.systemFont(ofSize: secondaryTextSize)
  //Alignment
  showcase.primaryTextAlignment = .left
  showcase.secondaryTextAlignment = .left
  // Animation
  showcase.aniComeInDuration = 0.5 // unit: second
  showcase.aniGoOutDuration = 0.5 // unit: second
  showcase.aniRippleScale = 1.5
  showcase.aniRippleColor = UIColor.white
  showcase.aniRippleAlpha = 0.2
  //...
```
### Sequence items

You can define showcase items and create sequence.

**If you set key param sequence visible just one time or key is empty will always show be repeated**

Always appear
```swift
        let sequence = MaterialShowcaseSequence()
        let showcase2 = MaterialShowcase()
        let showcase3 = MaterialShowcase()
        let showcase1 = MaterialShowcase()
        showcase1.delegate = self
        showcase2.delegate = self
        showcase3.delegate = self
        sequence.temp(showcase1).temp(showcase2).temp(showcase3).start()
```
Will appear once so we have key
```swift
        let sequence = MaterialShowcaseSequence()
        let showcase2 = MaterialShowcase()
        let showcase3 = MaterialShowcase()
        let showcase1 = MaterialShowcase()
        showcase1.delegate = self
        showcase2.delegate = self
        showcase3.delegate = self
        //Once the key value changes , it will appear once
        sequence.temp(showcase1).temp(showcase2).temp(showcase3).setKey(key: "temp").start()
```
**Must extends MaterialShowCaseDelegate and This code into showCaseDidDismiss function**
```swift
extension ViewController: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}
```


For more information, please take a look at [sample app](/Sample).

If you have any issues or feedback, please visit [issue section](https://github.com/aromajoin/material-showcase-ios/issues).
Please feel free to create a pull request.

## Third Party Bindings

### React Native
For [React Native](https://github.com/facebook/react-native) developers, you can use this library via [its binding bridge](https://github.com/prscX/react-native-material-showcase-ios) created by [@prscX](https://github.com/prscX).

### NativeScript
For [NativeScript](https://nativescript.org) developers, you can use this library via [3rd party plugin](https://github.com/hamdiwanis/nativescript-app-tour) created by [@hamdiwanis](https://github.com/hamdiwanis).

## FAQ
Please check the FAQ page [here](https://github.com/aromajoin/material-showcase-ios/wiki/FAQ).

## License

`Material Showcase` is available under the Apache license. See the LICENSE file for more info.
