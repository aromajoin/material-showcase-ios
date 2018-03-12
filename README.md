# Material Showcase for iOS

[![Download](https://img.shields.io/badge/pod-v0.5.0-blue.svg)](https://cocoapods.org/pods/MaterialShowcase)
[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg?style=flat-square)](https://www.apache.org/licenses/LICENSE-2.0.html)  

**An elegant and beautiful tap showcase view for iOS apps based on Material Design Guidelines.**  

| ![Screenshots](https://github.com/aromajoin/material-showcase-ios/blob/master/art/material-showcase.gif) | ![Screenshots](https://github.com/aromajoin/material-showcase-ios/blob/master/art/demo2.png) |
| ---------------------------------------- | ---------------------------------------- |
| ![Screenshots](https://github.com/aromajoin/material-showcase-ios/blob/master/art/demo3.png) | ![Screenshots](https://github.com/aromajoin/material-showcase-ios/blob/master/art/demo4.png) |
| ![Screenshots for Persian intro](https://raw.githubusercontent.com/Husseinhj/material-showcase-ios/feat/support_alignment/art/demo-persian.jpg) |                                          |


## Requirement
* iOS 8.0+
* Swift 3.0+

## Installation
You can install it by using CocoaPods. Please add the following line to your Podfile.   
```
pod 'MaterialShowcase'
```

## Usage

### Basic
```swift
  let showcase = MaterialShowcase()
  showcase.setTargetView(view: button) // always required to set targetView
  showcase.primaryText = "Action 1"
  showcase.secondaryText = "Click here to go into details"
  showcase.show(completion: {
    _ in
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
### Handle showcase status
```swift
  // Right after showing.
  showcase.show(completion: {
    _ in
    // You can save showcase state here
  })
  
  // To handle other behaviors when showcase is dismissing, delegate should be declared.
  showcase.delegate = self
  
  extension ViewController: MaterialShowcaseDelegate {
    func showCaseWillDismiss(showcase: MaterialShowcase) {
      print("Showcase \(showcase.primaryText) will dismiss.")
    }
    func showCaseDidDismiss(showcase: MaterialShowcase) {
      print("Showcase \(showcase.primaryText) dimissed.")
    }
  }
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
showcase.isTapRecognizerForTagretView = true
```

### Customize UI properties
You can define your own styles based on your app.
```swift
  // Background
  showcase.backgroundPromptColor = UIColor.blue
  showcase.backgroundPromptColorAlpha = 0.96
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
```

For more information, please take a look at [sample app](/Sample).

If you have any issues or feedback, please visit [issue section](https://github.com/aromajoin/material-showcase-ios/issues).  
Please feel free to create a pull request. 

## Third Party Bindings

### React Native
For [React Native](https://github.com/facebook/react-native) developers, you can use this library via [its binding bridge](https://github.com/prscX/react-native-material-showcase-ios) created by [@prscX](https://github.com/prscX).


## License  

`Material Showcase` is available under the Apache license. See the LICENSE file for more info.
