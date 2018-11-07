//
//  PyramidMazeHelper.swift
//  Mazes
//
//  Created by Scott Tury on 9/17/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class PyramidMazeHelper : MazeHelper {
    
    public override var supportsColumns : Bool {
        get {
            return false
        }
    }

    public override init() {
        super.init()
        imageNamePrefix = "pyramid_"
    }
    
    public override func getGrid( _ size: (Int, Int)) -> Grid {
        return PyramidGrid(rows: size.0, columns: size.1)
    }
    
    public override func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredPyramidGrid(rows: size.0, columns: size.1)
    }
    
    public override func startCell( _ grid: Grid ) -> Cell? {
        // For a pyramid, this should be the middle of the pyramid.  rows/2. col = rows
        let row = grid.rows/2
        let cells = grid.grid[row]
        let col = cells.count/2
        return grid[(row,col)]
    }
    
    public override var mazes:[Mazes] {
        get {
            var mazes = Mazes.agnosticMazes
            if let index = mazes.index(of: .binaryTree) {
                mazes.remove(at: index)
            }
            return mazes
        }
    }
}
