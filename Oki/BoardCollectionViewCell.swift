//
//  BoardCollectionViewCell.swift
//  Oki
//
//  Created by Brian Wang on 9/24/16.
//  Copyright © 2016 Oki. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

let BACKGROUND_COLOR = UIColor.white

class BoardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    var colorAnimator:UIViewPropertyAnimator!
    
    let NUM_PLAYERS = 10
    
    static var twoColorGenerator:TwoColorGenerator = TwoColorGenerator(stripSize: 8)
    
    var playerQueue:[AVAudioPlayer] = []
    var soundString:String? {
        didSet {
            if let s = soundString {
                do {
                    let path = Bundle.main.path(forResource: s, ofType:"wav")
                    if let p = path {
                        let url = URL(fileURLWithPath: p)
                        for _ in 1...NUM_PLAYERS {
                            let soundPlayer:AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
                            soundPlayer.prepareToPlay()
                            playerQueue.append(soundPlayer)
                        }
                    } else {
                        print("path doesn't exist")
                    }
                } catch {
                    print("init of sound failed")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        self.button.backgroundColor = BACKGROUND_COLOR
        colorAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear , animations: {
            self.button.backgroundColor = BACKGROUND_COLOR
        })
    }
    
    func playSound() {
        self.button.layer.removeAllAnimations()
        for sp in playerQueue {
            if !sp.isPlaying {
                sp.play()
                if colorAnimator.state == .active {
                    colorAnimator.stopAnimation(false)
                    colorAnimator.finishAnimation(at: .current)
                }
                self.button.backgroundColor = BoardCollectionViewCell.twoColorGenerator.generateNextColor()
                
                colorAnimator.addAnimations {
                    self.button.backgroundColor = BACKGROUND_COLOR
                }
                colorAnimator.startAnimation()
                break
            }
            sp.prepareToPlay()
        }
    }
    
    
    @IBAction func onButtonPressed(_ sender: AnyObject) {
        playSound()
    }
    
}
