//
//  Random.swift
//  Mazes
//
//  Created by Scott Tury on 9/17/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

import Foundation

/// returns a value of 0 to maxInt.  So random(4) would return one of the following: 0, 1, 2, 3
public func random(_ maxInt: Int ) -> Int {
    var result : Int = 0
    
    // arc4random_stir() // ?  Doesn't seem to help any for huntAndKill Maze
    result = Int(arc4random_uniform(UInt32(maxInt)))
    
    return result
}

/// return a random value between 0.0 and 1.0
func rand() -> Double {
    var result : Double
    
    #if swift(>=4.2)
    result = Double.random(in: ClosedRange<Double>(uncheckedBounds: (lower: 0.0, upper: 1.0)))
    #else
    result = Double(arc4random())/Double(UInt32.max)
    #endif
    
    return result
}

/// A method to try and mimic the Ruby next statement, which is followed by a condition.  If the condition is true, we skip the block.
public func next( _ condition: Bool, block:()->Void ) {
    if !condition {
        block()
    }
}

