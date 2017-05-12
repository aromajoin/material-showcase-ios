# Material Showcase for iOS

![Download](https://img.shields.io/badge/pod-v0.1.1-blue.svg) 
[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg?style=flat-square)](https://www.apache.org/licenses/LICENSE-2.0.html)  

**An elegant and beautiful showcase for iOS apps based on Material Design Guidelines.**  



## Requirement
* iOS 8.0+
* Swift 3.0+

## Installation
You can install it by using CocoaPods. Please add the following line to your Podfile.   
```
pod 'MaterialShowcase'
```

## Usage

#### Basic
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

#### Supported Target Views
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
#### Customize UI properties
You can define your own styles based on your app.
```swift
  // Background
  showcase.backgroundPromptColor = UIColor.blue
  showcase.backgroundPromptColorAlpha = 0.96
  showcase.targetTintColor = UIColor.blue
  // Target
  showcase.radius = 44
  // Text
  showcase.primaryTextColor = UIColor.white
  showcase.secondaryTextColor = UIColor.white
  showcase.primaryTextSize = 20
  showcase.secondaryTextSize = 16
```
  
If you have any issues or feedback, please visit [issue section](https://github.com/aromajoin/material-showcase-ios/issues).  
It is just the starting point, please feel free to create a pull request. 

## License  

`Material Showcase` is available under the Apache license. See the LICENSE file for more info.
