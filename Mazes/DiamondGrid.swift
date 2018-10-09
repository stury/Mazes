//
//  DiamondGrid.swift
//  Mazes
//
//  Created by Scott Tury on 10/8/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class DiamondGrid : Grid {
    
    override public func image( cellSize: Int, strokeSize: Int = 2 ) -> Image? {
        var result : Image? = nil
        
        let cgImage = Image.cgDiamondImage(for: self, cellSize: cellSize, strokeSize: strokeSize)
        if let cgImage = cgImage {
            result = Image.init(cgImage: cgImage)
        }
        
        return result
    }
    
    override public init( rows: Int, columns: Int) {
        // maxCalculatedColumns in this case is actually the maximum possible columns in a row...
        
        var correctedRows : Int = rows
        
        let maxCalculatedColumns : Int
        if correctedRows <= 1 {
            maxCalculatedColumns = 1
            correctedRows = 2
        }
        else {
            if correctedRows.odd {
                correctedRows += 1
            }
            maxCalculatedColumns = correctedRows-1
        }
        
        // For a diamond maze you MUST have an even number of rows!
        super.init( rows: correctedRows, columns: maxCalculatedColumns )
    }
    
    override internal func prepareGrid() -> [[Cell?]] {
        var result = [[Cell?]]()
        var numElements = 1
        let midRow = rows/2
        for row in 0..<rows {
            var rowArray = [Cell?]()
            for column in 0..<numElements {
                rowArray.append(DiamondCell(row: row, column: column, totalRows: rows))
            }
            result.append(rowArray)
            
            // Need to be careful wen incrementing the rows.  The middle two rows have the same number of elements, but the triangles are mirrored....
            if row+1 == midRow {
            }
            else if row < midRow {
                numElements += 2
            }
            else {
                numElements -= 2
            }
        }
        
        // self.columns == numElements-2, or result[result.count-1].count
        
        return result
    }
    
    override public func size() -> Int {
        var result = 0
        for column in grid {
            result += column.count
        }
        return result
    }
    
    override internal func configureCells() {
        let midRow = self.rows / 2
        eachCell { (cell) -> Bool in
            
            if let cell = cell as? DiamondCell {
                let row = cell.row
                let col = cell.column
                
                cell.west = self[(row,col-1)] as? DiamondCell
                cell.east = self[(row,col+1)] as? DiamondCell
                
                if row < midRow {
                    if cell.upright {
                        if row+1 == midRow {
                            cell.south = self[(row+1,col)] as? DiamondCell
                        }
                        else {
                            cell.south = self[(row+1,col+1)] as? DiamondCell
                        }
                    }
                    else {
                        cell.north = self[(row-1,col-1)] as? DiamondCell
                    }
                }
                else {
                    if cell.upright {
                        cell.south = self[(row+1,col-1)] as? DiamondCell
                    }
                    else {
                        if row == midRow {
                            cell.north = self[(row-1,col)] as? DiamondCell
                        }
                        else {
                            cell.north = self[(row-1,col+1)] as? DiamondCell
                        }
                    }
                }
            }
            return false
        }
    }    
}
