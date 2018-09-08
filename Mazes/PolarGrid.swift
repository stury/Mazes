//
//  PolarGrid.swift
//  Mazes
//
//  Created by J. Scott Tury on 8/20/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class PolarGrid : Grid {

    override public func image( cellSize: Int ) -> Image? {
        var result : Image? = nil
        
        let cgImage = Image.cgPolarImage(for: self, cellSize: cellSize)
        if let cgImage = cgImage {
            result = Image.init(cgImage: cgImage)
        }
        
        return result
    }
    
    public init( _ rows: Int ) {
        super.init(rows: rows, columns: 1)
    }
    
    override internal func prepareGrid() -> [[Cell?]] {
        var rows : [[PolarCell?]] = [[PolarCell?]].init(repeating: [PolarCell?].init(), count: self.rows)
        
        let rowHeight = Double(1 / Double(self.rows))
        rows[0] = [PolarCell.init(row: 0, column: 0)]
        for row in 1..<self.rows {
            let radius  = Double(row) / Double(self.rows)
            let circumference = 2 * Double.pi * radius
            
            let previousCount = rows[row-1].count
            let estimatedCellWidth = circumference/Double(previousCount)
            let ratio = round(estimatedCellWidth / rowHeight)
            
            //let cells = Int(round(Double(previousCount) * ratio))
            let cells = Int(Double(previousCount) * ratio)
            var newRow = [PolarCell?]()
            for col in 0..<cells {
                newRow.append(PolarCell(row: row, column: col))
            }
            rows[row] = newRow
        }
        
        return rows
    }
    
    // Scott:  Will this method get called, since it's private?
    override internal func configureCells() {
        eachCell { (cell) -> Bool in
            
            if let cell = cell as? PolarCell {
                let row = cell.row
                let col = cell.column
                if row > 0 {
                    cell.cw = self[[row, col+1]] as? PolarCell
                    cell.ccw = self[[row, col-1]] as? PolarCell
                    
                    let ratio = Double(grid[row].count) / Double(grid[row-1].count)
                    if let parent = grid[row-1][Int(Double(col)/ratio)] as? PolarCell {
                        parent.outward.append(cell)
                        cell.inward = parent
                    }
                }
            }
            return false
        }
    }
    
    override public subscript(_ location: [Int]) -> Cell? {
        get {
            var result : Cell? = nil
            if location.count == 2 {
                let row = location[0]
                var col = location[1] % grid[row].count
                if col == -1 {
                    col = grid[row].count-1
                }
                if row >= 0 && row < rows &&
                    col >= 0 && col < grid[row].count {
                    result = grid[row][col]
                }
            }
            return result
        }
        set (newValue) {
            if let newValue = newValue, location.count == 2 {
                let point = Point(row: location[0], col: location[1])
                if point.row >= 0 && point.row < rows &&
                    point.col >= 0 && point.col < columns {
                    grid[point.row][point.col] = newValue
                }
            }
        }
    }

    override public func randomCell() -> Cell? {
        let row = random(rows)
        let col = random(grid[row].count)
        return grid[row][col]
    }
}
