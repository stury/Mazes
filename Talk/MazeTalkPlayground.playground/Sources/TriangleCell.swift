//
//  TriangleCell.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class TriangleCell : Cell {
    
    public var upright : Bool {
        get {
            return (row+column).even
        }
    }
    
    public var north, east, west, south: TriangleCell?
    
    override public func neighbors() -> [Cell] {
        var result = [Cell]()
        if let west = west {
            result.append(west)
        }
        if let east = east {
            result.append(east)
        }
        if upright {
            if let south = south {
                result.append(south)
            }
        }
        else { // ! upright
            if let north = north {
                result.append(north)
            }
        }
        return result
    }

}
