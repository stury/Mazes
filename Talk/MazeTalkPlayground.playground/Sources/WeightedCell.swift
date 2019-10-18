//
//  WeightedCell.swift
//  Mazes
//
//  Created by Scott Tury on 11/18/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class WeightedCell : RectCell, Comparable {

    public var weight : Int
    
    override public init( row: Int, column: Int) {
        weight = 1
        super.init(row: row, column: column)
    }

    
    override public var hashValue: Int {
        return row.hashValue ^ column.hashValue
    }
    
    override public var description: String {
        return "Cell(\(row), \(column))"
    }
    
    public static func < (lhs: WeightedCell, rhs: WeightedCell) -> Bool {
        return lhs.weight < rhs.weight
    }
    
    override public func distances() -> Distances {
        let weights = Distances(root: self)
        var pending : [WeightedCell] = [self]
        
        while pending.count > 0 {
            let pendingSorted = pending.sorted(by: { (lhcell, rhcell) -> Bool in
                return (lhcell < rhcell)
            })
            
            if let cell = pendingSorted.first {
                // removing the item we just pulled from the pending queue...
                if let index = pending.firstIndex(of: cell) {
                    _ = pending.remove(at: index)
                }
                //pending = pending.filter { $0.column != cell.column && $0.row != cell.row }
                
                // cycle through all of the links for this cell
                cell.links.forEach { (neighbor) in
                //for neighbor in cell.links {
                    if let neighbor = neighbor as? WeightedCell,
                        let weightsCell = weights[cell] {
                        let total_weight =  weightsCell + neighbor.weight
                        let weightsNeighbor = weights[neighbor]
                        var process = false
                        
                        if weightsNeighbor == nil {
                            process = true
                        }
                        else if let weightsNeighbor = weightsNeighbor {
                            if total_weight < weightsNeighbor {
                                process = true
                            }
                        }
                        
                        if process {
                            pending.append(neighbor)
                            weights[neighbor] = total_weight
                        }
                    }
                    else {
                        print( "Seems like there's an issue with the cells for this item!" )
                    }
                }
            }
        }
        return weights
    }
    
}
