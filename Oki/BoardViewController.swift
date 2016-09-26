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
    @IBOutlet weak var sliderView: UIView!
    
    @IBOutlet weak var sliderButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    let sliderColorGenerator:TwoColorGenerator = TwoColorGenerator(stripSize: 15)
    
    //sizing
    var NUM_COLS:Int!
    var NUM_ROWS:Int!
    var CELL_WIDTH:CGFloat!
    var CELL_HEIGHT:CGFloat!
    
    //scale
    var lastCellTapped:BoardCollectionViewCell!
    var lastTimeStamp:TimeInterval = 0
    var dragMode:Bool = false {
        didSet {
            sliderView.isHidden = !dragMode
        }
    }
    var currentDragCell:BoardCollectionViewCell!
    var baseLocation:CGPoint!
    
    
    //status bar
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }  
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NUM_COLS = 3
        CELL_WIDTH = UIScreen.main.bounds.width / CGFloat(NUM_COLS)
        CELL_HEIGHT = CELL_WIDTH
        NUM_ROWS = Int(collectionView.bounds.height) / Int(CELL_HEIGHT)
        collectionView.delegate = self
        collectionView.dataSource = self
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: CELL_WIDTH, height: CELL_HEIGHT)
        
        UIApplication.shared.isStatusBarHidden = true
        sliderView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            //find location of touch
            let touch = touches.first!
            let location = touch.location(in: self.view)
            if let cell = lastCellTapped, sliderButton.frame.contains(location) {
                //drag mode for visible slider and touchesMoved
                dragMode = true
                
                //put cell in repeatmode
                cell.repeatMode = true
                
                //set the baseTimeInterval
                let date = NSDate()
                cell.baseRepeatInterval = date.timeIntervalSince1970 - lastTimeStamp
                
                let locationInSlider = touch.location(in: sliderView)
                baseLocation = locationInSlider
                // calculate scalefactor and change interval
                let scaleFactor:CGFloat = 1
                cell.changeRepeatInterval(scaleFactor: scaleFactor, fire: true)
                
                //cache the repeat cell if you hold and scale
                currentDragCell = cell
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dragMode {
            //slider and cell repeat color
            let color = sliderColorGenerator.generateNextColor()
            sliderView.backgroundColor = color
            currentDragCell.repeatColor = color
            
            //find locatin of touch
            let touch = touches.first!
            let location = touch.location(in: sliderView)
            
            //calculate scalefactor and change interval
            let scaleFactor = 1 + (location.x - baseLocation.x) / sliderView.frame.width
            currentDragCell.changeRepeatInterval(scaleFactor: scaleFactor, fire: false)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dragMode = false
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
        cell.parentViewController = self
        return cell
    }
}

