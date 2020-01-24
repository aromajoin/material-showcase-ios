//
//  CollectionViewController.swift
//  MaterialShowcaseSample
//
//  Created by Reza Khonsari on 1/24/20.
//  Copyright © 2020 Aromajoin. All rights reserved.
//

import UIKit
import MaterialShowcase

class CollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var sequence = MaterialShowcaseSequence()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let showcase3 = MaterialShowcase()
        showcase3.setTargetView(collectionView: collectionView, section: 0, item: 1)
        showcase3.primaryText = "Action 3"
        showcase3.secondaryText = "Click here to go into details"
        showcase3.isTapRecognizerForTargetView = false
        showcase3.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showcase3.show(completion: nil)
        }
        
//        sequence.temp(showcase3).setKey(key: "eye").start()
    }
    


}


extension CollectionViewController : UICollectionViewDelegate {}

extension CollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        return cell
    }
}


extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio = 24 *  (collectionView.bounds.height / 100)
        return CGSize(width: ratio , height: ratio)
    }
}


extension CollectionViewController: MaterialShowcaseDelegate {
  func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
    sequence.showCaseWillDismis()
  }
}
