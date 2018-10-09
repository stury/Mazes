//
//  DiamondMazeHelper.swift
//  Mazes
//
//  Created by Scott Tury on 10/8/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class DiamondMazeHelper : MazeHelper {
    
    public override init() {
        super.init()
        imageNamePrefix = "diamond_"
    }
    
    public override func getGrid( _ size: (Int, Int)) -> Grid {
        return DiamondGrid(rows: size.0, columns: size.1)
    }
    
    public override func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredDiamondGrid(rows: size.0, columns: size.1)
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
