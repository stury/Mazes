//
//  WeightedGrid.swift
//  Mazes
//
//  Created by Scott Tury on 11/18/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation
import CoreGraphics

public class WeightedGrid : ColoredRectGrid {
    
    override internal func prepareGrid() -> [[Cell?]] {
        var result = [[Cell?]]()
        for row in 0..<rows {
            var rowArray = [Cell?]()
            for column in 0..<columns {
                rowArray.append(WeightedCell(row: row, column: column))
            }
            result.append(rowArray)
        }
        return result
    }
    
    override public func contentsOfCell(_ cell: Cell) -> String {
        var result : String
        if let distances = distances, let distance = distances[cell] {
            result = String(distance, radix: 36) 
        }
        else {
            result = super.contentsOfCell(cell)
        }
        return result
    }
    
}
