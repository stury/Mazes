//
//  TriangularMazeHelper.swift
//  Mazes
//
//  Created by Scott Tury on 9/17/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

class TriangularMazeHelper : MazeHelper {
    
    override init() {
        super.init()
        imageNamePrefix = "triangle_"
    }
    
    override func getGrid( _ size: (Int, Int)) -> Grid {
        return TriangleGrid(rows: size.0, columns: size.1)
    }
    
    override func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredTriangleGrid(rows: size.0, columns: size.1)
    }
    
    override var mazes:[Mazes] {
        get {
            var mazes = Mazes.agnosticMazes
            if let index = mazes.index(of: .binaryTree) {
                mazes.remove(at: index)
            }
            return mazes
        }
    }
}
