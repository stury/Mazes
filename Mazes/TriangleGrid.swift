//
//  TriangleGrid.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class TriangleGrid : Grid {
    
    override public func image( cellSize: Int ) -> Image? {
        var result : Image? = nil
        
        let cgImage = Image.cgTriangleImage(for: self, cellSize: cellSize)
        if let cgImage = cgImage {
            result = Image.init(cgImage: cgImage)
        }
        
        return result
    }
    
    override internal func prepareGrid() -> [[Cell?]] {
        var result = [[Cell?]]()
        for row in 0..<rows {
            var rowArray = [Cell?]()
            for column in 0..<columns {
                rowArray.append(TriangleCell(row: row, column: column))
            }
            result.append(rowArray)
        }
        return result
    }
    
    override internal func configureCells() {
        eachCell { (cell) -> Bool in
            
            if let cell = cell as? TriangleCell {
                let row = cell.row
                let col = cell.column
                
                cell.west = self[[row,col-1]] as? TriangleCell
                cell.east = self[[row,col+1]] as? TriangleCell
                
                if cell.upright {
                    cell.south = self[[row+1,col]] as? TriangleCell
                }
                else {
                    cell.north = self[[row-1,col]] as? TriangleCell
                }
            }
            return false
        }
    }
}
