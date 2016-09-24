//
//  CoreSwift.swift
//
//  Created by Brian Wang on 6/26/16.
//  Copyright © 2016 Brian Wang. All rights reserved.
//

import Foundation
import UIKit

infix operator ^^ { associativity left precedence 160 }
func ^^ (radix: CGFloat, power: CGFloat) -> CGFloat {
    return pow(CGFloat(radix), CGFloat(power))
}
///returns trus if the current device is an iPad
func iPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
}

///returns trus if the current device is an iPhone 4S
func is4S() -> Bool {
    return UIScreen.main.bounds.height == 480.0
}

func randomInt(lower:Int, upper:Int) -> Int {
    return Int(arc4random_uniform(UInt32(upper - lower + 1))) + Int(lower)
}


