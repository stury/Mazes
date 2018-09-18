//
//  HexagonalMazeHelper.swift
//  Mazes
//
//  Created by Scott Tury on 9/17/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

class HexagonalMazeHelper : MazeHelper {
    
    override init() {
        super.init()
        imageNamePrefix = "hex_"
    }
    
    override func getGrid( _ size: (Int, Int)) -> Grid {
        return HexGrid(rows: size.0, columns: size.1)
    }
    
    override func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredHexGrid(rows: size.0, columns: size.1)
    }
    
    override var mazes:[Mazes] {
        get {
            return Mazes.agnosticMazes
        }
    }
    
}
