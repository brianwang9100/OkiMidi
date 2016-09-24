//
//  ViewController.swift
//  Oki
//
//  Created by Brian Wang on 9/24/16.
//  Copyright © 2016 Oki. All rights reserved.
//


import UIKit
import AVFoundation

class BoardViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var NUM_COLS = 3
    var NUM_ROWS = 5
    var CELL_WIDTH:CGFloat = 125.0
    var CELL_HEIGHT:CGFloat = 125.0
    
//    var lastCellTapped:BoardCollectionViewCell!
//    var lastTimeStamp:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NUM_ROWS = Int(collectionView.bounds.height) / Int(CELL_HEIGHT)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: CELL_WIDTH, height: CELL_HEIGHT)
        
        UIApplication.shared.isStatusBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }  
    }
}

extension BoardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let size = NUM_COLS * NUM_ROWS
        print("num of elements \(size)")
        return size < soundStrings.count ? size : soundStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCell", for: indexPath) as! BoardCollectionViewCell
        let i = indexPath.row
        let sString = soundStrings[i]
        if let s = sString {
            cell.soundString = s
        }
        return cell
    }
}

