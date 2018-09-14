//
//  HexCell.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class HexCell : Cell {
    public var north, northeast, northwest, south, southeast, southwest: HexCell?
    
    override public func neighbors() -> [Cell] {
        var result = [Cell]()
        if let north = north {
            result.append(north)
        }
        if let south = south {
            result.append(south)
        }
        if let northeast = northeast {
            result.append(northeast)
        }
        if let northwest = northwest {
            result.append(northwest)
        }
        if let southeast = southeast {
            result.append(southeast)
        }
        if let southwest = southwest {
            result.append(southwest)
        }
        return result
    }

    
}
