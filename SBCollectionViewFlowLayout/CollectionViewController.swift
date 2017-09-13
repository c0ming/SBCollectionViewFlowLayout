//
//  CollectionViewController.swift
//  SBCollectionViewFlowLayout
//
//  Created by L on 16/8/18.
//  Copyright © 2016年 c0ming. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, SBCollectionViewDelegateFlowLayout {
    
    var count = 0;
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        self.collectionView?.performBatchUpdates({

        self.count = Int(arc4random()%13);
        self.collectionView?.reloadSections(NSIndexSet(index: 1) as IndexSet)
        }, completion: nil)
    }
    
    @IBAction func insertAction(_ sender: UIBarButtonItem) {
        self.collectionView?.performBatchUpdates({
            let indexs = [IndexPath.init(item: self.count, section: 1), IndexPath.init(item: self.count + 1, section: 1), ];
            self.count += 2
            
            self.collectionView?.insertItems(at: indexs)
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "SectionBackground"
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.alwaysBounceVertical = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else if section == 1 {
            return self.count
        } else if section == 2 {
            return 11
        }
        return 19
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        cell.backgroundColor = UIColor.groupTableViewBackground
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        return numberOfItems > 0 ? UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) : UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        if section == 0 {
            return UIColor.red
        } else if section == 1 {
            return UIColor.green
        } else if section == 2 {
            return UIColor.brown
        }
        return UIColor.blue
    }
}
