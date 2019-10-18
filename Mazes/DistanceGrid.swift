//
//  DistanceGrid.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/24/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class DistanceGrid : Grid {
    
    public var distances : Distances? = nil
    
    override public func contentsOfCell(_ cell: Cell) -> String {
        var result : String
        if let distances = distances, let distance = distances[cell] {
            result = String(distance, radix: 36) //"\(distance)"
        }
        else {
            result = super.contentsOfCell(cell)
        }
        return result
    }
    
}
