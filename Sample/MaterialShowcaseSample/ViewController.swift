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
    
    var sequence = MaterialShowcaseSequence()

    // Mock data for table view
    let animals = ["Dolphin", "Penguin", "Panda", "Neko", "Inu"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let showcase3 = MaterialShowcase()
        showcase3.setTargetView(tableView: self.tableView, section: 0, row: 2)
        showcase3.primaryText = "Action 3"
        showcase3.secondaryText = "Click here to go into details"
        showcase3.isTapRecognizerForTargetView = false

        
        let showcase1 = MaterialShowcase()
        showcase1.setTargetView(view: button)
        showcase1.primaryText = "Action 1"
        showcase1.secondaryText = "Click here to go into details"
        showcase1.shouldSetTintColor = false // It should be set to false when button uses image.
        showcase1.backgroundPromptColor = UIColor.blue
        showcase1.isTapRecognizerForTargetView = true
    
        
        let showcase2 = MaterialShowcase()
        showcase2.setTargetView(barButtonItem: searchItem)
        showcase2.primaryText = "Action 1.1"
        showcase2.secondaryText = "Click here to go into details"
        showcase2.isTapRecognizerForTargetView = true
        
        
        showcase3.delegate = self
        showcase2.delegate = self
        showcase1.delegate = self
        
     
        
         sequence.temp(showcase1).temp(showcase2).temp(showcase3).setKey(key: "eve").start()
      
        
        
        //        showcase3.show(completion: nil)
        
        
        
//        let arr  = [showcase1,showcase3,showcase2]
//        let showcase = MaterialShowcase()
//        showcase.setUserState(save: true,key: "veli")
//        showcase.sequence(array: arr)
        
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func showButton(_ sender: Any) {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: button)
        showcase.primaryText = "Action 1"
        showcase.secondaryText = "Click here to go into details"
        showcase.shouldSetTintColor = false // It should be set to false when button uses image.
        showcase.backgroundPromptColor = UIColor.blue
        showcase.isTapRecognizerForTargetView = true
//        showcase.delegate = self
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
        showcase.isTapRecognizerForTargetView = true
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
        showcase.isTapRecognizerForTargetView = true
        // Delegate to handle other action after showcase is dismissed.
//        showcase.delegate = self
        showcase.show(completion: {
            // You can save showcase state here
            print("==== completion Action 2 ====")
        })
    }
    
    @IBAction func showTabBar(_ sender: Any) {
        let showcase = MaterialShowcase()
        showcase.setTargetView(tabBar: tabBar, itemIndex: 0)
        showcase.backgroundViewType = .circle
        showcase.targetTintColor = UIColor.clear
        showcase.targetHolderColor = UIColor.clear
        showcase.primaryText = "Action 3"
        showcase.secondaryText = "Click here to go into details"
        showcase.isTapRecognizerForTargetView = true
//        showcase.delegate = self
        showcase.show(completion: nil)
    }
    
    @IBAction func showTableView(_ sender: Any) {
        let showcase = MaterialShowcase()
        showcase.setTargetView(tableView: tableView, section: 0, row: 2)
        showcase.primaryText = "Action 3"
        showcase.secondaryText = "Click here to go into details"
        showcase.isTapRecognizerForTargetView = false
//        showcase.delegate = self
        showcase.show(completion: nil)
    }
    @IBAction func showInSeries(_ sender: UIButton) {
        // step 1
        showButton(self)
        // to continue other showcases
        tutorialStep = 2
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
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}
