//
//  TriangleGrid.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation
import CoreGraphics

public class TriangleGrid : Grid {
    
    override public func imageSize(_ cellSize: Int) -> CGSize {
        let size = Double(cellSize)
//        let halfWidth = size / 2.0
        let height = size * Double(3.0).squareRoot() / 2.0
//        let halfHeight = height / 2.0
        
        let imgWidth = Int(size * Double(self.columns+1)/2.0)
        let imgHeight = Int(height * Double(self.rows))
        return CGSize(width: imgWidth+1, height: imgHeight+1)
    }

    override public func image( cellSize: Int, strokeSize: Int = 2 ) -> Image? {
        let result : Image? = renderer.raster(size: imageSize(cellSize)) { (context) in
            Image.triangleMaze(in: context, for: self, cellSize: cellSize, strokeSize: strokeSize)
        }
        return result
    }
 
    override public func pdfImage( cellSize: Int, strokeSize: Int = 2 ) -> Data? {
        let result : Data? = renderer.data(mode: .pdf, size: imageSize(cellSize)) { (context) in
            Image.triangleMaze(in:context, for: self, cellSize: cellSize, strokeSize: strokeSize)
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
                
                cell.west = self[(row,col-1)] as? TriangleCell
                cell.east = self[(row,col+1)] as? TriangleCell
                
                if cell.upright {
                    cell.south = self[(row+1,col)] as? TriangleCell
                }
                else {
                    cell.north = self[(row-1,col)] as? TriangleCell
                }
            }
            return false
        }
    }
}
