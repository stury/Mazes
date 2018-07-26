//
//  Distances.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/24/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class Distances {
    
    public let root:Cell
    public var cells : [Cell:Int]
    
    public init(root: Cell) {
        self.root = root
        cells = [Cell:Int]()
        cells[root] = 0
    }
    
    public subscript(_ cell: Cell) -> Int? {
        get {
            var result : Int? = nil
            if let value = cells[cell] {
                result = value
            }
            return result
        }
        set (newValue) {
            if let newValue = newValue {
                cells[cell] = newValue
            }
        }
    }

    public func knownCells() -> [Cell] {
        var result = [Cell]()
        
        for (cell, _) in cells {
            result.append(cell)
        }

        return result
    }
    
    public func path(to goal: Cell) -> Distances {
        
        let result = Distances(root:root)
        var current = goal
        
        result[current] = cells[current]
        while current != root {
            if let currentDistance = cells[current] {
                for neighbor in current.links {
                    if let neighborDistance = cells[neighbor] {
                        if neighborDistance < currentDistance {
                            result[neighbor] = neighborDistance
                            current = neighbor
                            break
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    public func max() -> (cell:Cell, distance:Int) {
        var maxDistance = 0
        var maxCell = root
        
        for (cell, distance) in cells {
            if distance > maxDistance {
                maxCell = cell
                maxDistance = distance
            }
        }
        return (cell:maxCell, distance:maxDistance)
    }
}
