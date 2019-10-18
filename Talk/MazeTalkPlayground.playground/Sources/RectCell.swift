//
//  RectCell.swift
//  Mazes
//
//  Created by Scott Tury on 9/8/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class RectCell : Cell {
    
    override public var description: String {
        return "RectCell(\(row), \(column))"
    }
    
    public var north, south, east, west: RectCell?
   
    public override init(row: Int, column: Int) {
        north = nil
        south = nil
        east = nil
        west = nil
        super.init( row: row, column: column)
    }
    
    override public func neighbors() -> [Cell] {
        var result = [Cell]()
        if let north = north {
            result.append(north)
        }
        if let south = south {
            result.append(south)
        }
        if let east = east {
            result.append(east)
        }
        if let west = west {
            result.append(west)
        }
        return result
    }

}
