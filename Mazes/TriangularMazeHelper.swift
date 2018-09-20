//
//  TriangularMazeHelper.swift
//  Mazes
//
//  Created by Scott Tury on 9/17/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class TriangularMazeHelper : MazeHelper {
    
    public override init() {
        super.init()
        imageNamePrefix = "triangle_"
    }
    
    public override func getGrid( _ size: (Int, Int)) -> Grid {
        return TriangleGrid(rows: size.0, columns: size.1)
    }
    
    public override func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredTriangleGrid(rows: size.0, columns: size.1)
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
