//
//  HexGrid.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation
import CoreGraphics

public class HexGrid : Grid {
    
    override public func imageSize(_ cellSize: Int) -> CGSize {
        let size = Double(cellSize)
        let aSize = size/2.0
        let bSize = size * Double(3.0).squareRoot() / 2.0
        //let width = size*2.0
        let height = bSize * 2

        let imgWidth = Int(3.0 * aSize * Double(self.columns) + aSize + 0.5)
        let imgHeight = Int(height * Double(self.rows) + bSize + 0.5)
        return CGSize(width: imgWidth+1, height: imgHeight+1)
    }
    
    override public func image( cellSize: Int, strokeSize: Int = 2 ) -> Image? {
        let result : Image? = renderer.raster(size: imageSize(cellSize)) { (context) in
            Image.hexMaze(in: context, for: self, cellSize: cellSize, strokeSize: strokeSize)
        }
        return result
    }

    override public func pdfImage( cellSize: Int, strokeSize: Int = 2 ) -> Data? {
        let result : Data? = renderer.data(mode: .pdf, size: imageSize(cellSize)) { (context) in
            Image.hexMaze(in:context, for: self, cellSize: cellSize, strokeSize: strokeSize)
        }
        return result
    }

    override internal func prepareGrid() -> [[Cell?]] {
        var result = [[Cell?]]()
        for row in 0..<rows {
            var rowArray = [Cell?]()
            for column in 0..<columns {
                rowArray.append(HexCell(row: row, column: column))
            }
            result.append(rowArray)
        }
        return result
    }

    override internal func configureCells() {
        eachCell { (cell) -> Bool in
            
            if let cell = cell as? HexCell {
                let row = cell.row
                let col = cell.column
                
                var northDiagonal : Int
                var southDiagonal : Int
                if col.even {
                    northDiagonal = row - 1
                    southDiagonal = row
                }
                else {
                    northDiagonal = row
                    southDiagonal = row + 1
                }
                
                cell.north = self[(row-1, col)] as? HexCell
                cell.northeast = self[(northDiagonal, col+1)] as? HexCell
                cell.northwest = self[(northDiagonal, col-1)] as? HexCell
                cell.south = self[(row+1, col)] as? HexCell
                cell.southeast = self[(southDiagonal, col+1)] as? HexCell
                cell.southwest = self[(southDiagonal, col-1)] as? HexCell

            }
            return false
        }
    }
}
