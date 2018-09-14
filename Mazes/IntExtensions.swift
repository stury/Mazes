//
//  IntExtensions.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

extension Int {
    
    /// Return true is the Int is an even number.
    public var even : Bool {
        get {
            return (self % 2 == 0)
        }
    }
    
    /// Return true is the Int is an odd number.
    public var odd : Bool {
        get {
            return !even
        }
    }
}
