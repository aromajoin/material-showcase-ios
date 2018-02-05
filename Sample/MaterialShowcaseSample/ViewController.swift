//
//  ViewController.swift
//  MaterialShowcaseSample
//
//  Created by Quang Nguyen on 5/10/17.
//  Copyright © 2017 Aromajoin. All rights reserved.
//

import UIKit
import MaterialShowcase

class ViewController: UIViewController {
  
  var tutorialStep = 1
    
  @IBOutlet weak var searchItem: UIBarButtonItem!
  @IBOutlet weak var tabBar: UITabBar!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  // Mock data for table view
  let animals = ["Dolphin", "Penguin", "Panda", "Neko", "Inu"]
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
  }
  
  @IBAction func showButton(_ sender: Any) {
    let showcase = MaterialShowcase()
    showcase.setTargetView(view: button)
    showcase.primaryText = "Action 1"
    showcase.secondaryText = "Click here to go into details"
    showcase.shouldSetTintColor = false // It should be set to false when button uses image.
    showcase.backgroundPromptColor = UIColor.blue
    showcase.isTapRecognizerForTagretView = true
    showcase.show(completion: {
        print("==== completion Action 1 ====")
      // You can save showcase state here
    })
  }
  
  @IBAction func placementButton(_ sender: UIButton) {
    let showcase = MaterialShowcase()
    showcase.setTargetView(view: sender)
    showcase.primaryText = "Action 1.1"
    showcase.secondaryText = "Click here to go into details"
    showcase.isTapRecognizerForTagretView = true
    showcase.delegate = self
    showcase.show(completion: {
        print("==== completion Action 1.1 ====")
      // You can save showcase state here
    })
  }
  
  @IBAction func showBarButtonItem(_ sender: Any) {
    let showcase = MaterialShowcase()
    showcase.setTargetView(barButtonItem: searchItem)
    showcase.targetTintColor = UIColor.red
    showcase.targetHolderRadius = 50
    showcase.targetHolderColor = UIColor.yellow
    showcase.aniComeInDuration = 0.3
    showcase.aniRippleColor = UIColor.black
    showcase.aniRippleAlpha = 0.2
    showcase.primaryText = "Action 2"
    showcase.secondaryText = "Click here to go into long long long long long long long long long long long long long long long details"
    showcase.secondaryTextSize = 14
    showcase.isTapRecognizerForTagretView = true
    // Delegate to handle other action after showcase is dismissed.
    showcase.delegate = self
    showcase.show(completion: {
      // You can save showcase state here
         print("==== completion Action 2 ====")
    })
  }
  
  @IBAction func showTabBar(_ sender: Any) {
    let showcase = MaterialShowcase()
    showcase.setTargetView(tabBar: tabBar, itemIndex: 0)
    showcase.primaryText = "Action 3"
    showcase.secondaryText = "Click here to go into details"
    showcase.isTapRecognizerForTagretView = true
    showcase.delegate = self
    showcase.show(completion: nil)
  }
  
  @IBAction func showTableView(_ sender: Any) {
    let showcase = MaterialShowcase()
    showcase.setTargetView(tableView: tableView, section: 0, row: 2)
    showcase.primaryText = "Action 3"
    showcase.secondaryText = "Click here to go into details"
    showcase.isTapRecognizerForTagretView = true
    showcase.delegate = self
    showcase.show(completion: nil)
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return animals.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "animalViewCell", for: indexPath)
    cell.textLabel?.text = animals[indexPath.row]
    return cell
  }
}

// If you need handle other actions (i.e: show other showcase), you can implement MaterialShowcaseDelegate
extension ViewController: MaterialShowcaseDelegate {
  func showCaseWillDismiss(showcase: MaterialShowcase) {
    print("Showcase \(showcase.primaryText) will dismiss.")
  }
  func showCaseDidDismiss(showcase: MaterialShowcase) {
    print("Showcase \(showcase.primaryText) dimissed.")
    print("tutorialStep = \(tutorialStep)")
    switch tutorialStep {
    case 1:
        self.placementButton(button)
    case 2:
        self.showBarButtonItem(self)
    case 3:
        self.showTabBar(self)
    case 4:
        self.showTableView(self)
    default:
        tutorialStep = 0
    }
    
    tutorialStep += 1
  }
}
