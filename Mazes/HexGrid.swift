//
//  HexGrid.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

extension Int {
    
    func even() -> Bool {
        return (self % 2 == 0)
    }
    func odd() -> Bool {
        return !even()
    }
}

public class HexGrid : Grid {
    
    override public func image( cellSize: Int ) -> Image? {
        var result : Image? = nil
        
        let cgImage = Image.cgHexImage(for: self, cellSize: cellSize)
        if let cgImage = cgImage {
            result = Image.init(cgImage: cgImage)
        }
        
        return result
    }
    
//    public init( _ rows: Int ) {
//        super.init(rows: rows, columns: 1)
//    }
    
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
                if col.even() {
                    northDiagonal = row - 1
                    southDiagonal = row
                }
                else {
                    northDiagonal = row
                    southDiagonal = row + 1
                }
                
                cell.north = self[[row-1, col]] as? HexCell
                cell.northeast = self[[northDiagonal, col+1]] as? HexCell
                cell.northwest = self[[northDiagonal, col-1]] as? HexCell
                cell.south = self[[row+1, col]] as? HexCell
                cell.southeast = self[[southDiagonal, col+1]] as? HexCell
                cell.southwest = self[[southDiagonal, col-1]] as? HexCell

            }
            return false
        }
    }
}
