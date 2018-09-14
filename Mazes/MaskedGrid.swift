//
//  MaskedGrid.swift
//  Mazes
//
//  Created by J. Scott Tury on 8/8/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class MaskedGrid : Grid {
    let mask : Mask
    
    public override init(rows: Int, columns: Int) {
        self.mask = Mask(rows: rows, columns: columns)
        super.init(rows: rows, columns: columns)
    }
    
    init(_ mask: Mask) {
        self.mask = mask
        super.init(rows: mask.rows, columns: mask.columns)
    }
    
    override internal func prepareGrid() -> [[Cell?]] {
        var result = [[Cell?]]()
        for row in 0..<rows {
            var rowArray = [Cell?]()
            for column in 0..<columns {
                var cell : Cell? = nil
                if mask[[row,column]] {
                    cell = RectCell(row: row, column: column)
                }
                rowArray.append(cell)
            }
            result.append(rowArray)
        }
        return result
    }
    
    override public func randomCell() -> Cell? {
        let location = mask.randomLocation()
        let row = location[0]
        let col = location[1]
        return self[[row, col]]
    }
    
    override public func size() -> Int {
        return mask.count
    }
}
