//
//  PyramidGrid.swift
//  Mazes
//
//  Created by Scott Tury on 9/14/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class PyramidGrid : Grid {
    
    override public func image( cellSize: Int ) -> Image? {
        var result : Image? = nil
        
        let cgImage = Image.cgPyramidImage(for: self, cellSize: cellSize)
        if let cgImage = cgImage {
            result = Image.init(cgImage: cgImage)
        }
        
        return result
    }
    
    override public init( rows: Int, columns: Int) {
        let calculatedColumns = rows*2-1
        super.init( rows: rows, columns: calculatedColumns )
    }
    
    override internal func prepareGrid() -> [[Cell?]] {
        var result = [[Cell?]]()
        var numElements = 1
        for row in 0..<rows {
            var rowArray = [Cell?]()
            for column in 0..<numElements {
                rowArray.append(PyramidCell(row: row, column: column))
            }
            result.append(rowArray)
            numElements += 2
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
        eachCell { (cell) -> Bool in
            
            if let cell = cell as? TriangleCell {
                let row = cell.row
                let col = cell.column
                
                cell.west = self[(row,col-1)] as? TriangleCell
                cell.east = self[(row,col+1)] as? TriangleCell
                
                if cell.upright {
                    cell.south = self[(row+1,col+1)] as? TriangleCell
                }
                else {
                    cell.north = self[(row-1,col-1)] as? TriangleCell
                }
            }
            return false
        }
    }

    override public func randomCell() -> Cell? {
        var result : Cell? = nil
        
        let row = random(rows)
        let cellsInRow = grid[row]
        let col = random(cellsInRow.count)
        result = cellsInRow[col]
        return result
    }
    
//    public func randomLocation() -> [Int] {
//        while true {
//            let row = random(rows)
//            let col = random(columns)
//            if bits[row][col] {
//                return [row, col]
//            }
//        }
//    }

}
