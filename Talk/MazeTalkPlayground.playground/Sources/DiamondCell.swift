//
//  DiamondCell.swift
//  Mazes
//
//  Created by Scott Tury on 10/8/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

class DiamondCell : TriangleCell {
    
    var totalRows : Int

    public init(row: Int, column: Int, totalRows: Int) {
        self.totalRows = totalRows / 2
        super.init(row: row, column: column)
    }
    
    override public var upright : Bool {
        get {
            // On a diamond, the cells flip in the middle of the structure...
            if self.row < totalRows {
                return column.even
            }
            else {
                return column.odd
            }
        }
    }
}
