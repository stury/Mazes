//
//  HexagonalMazeHelper.swift
//  Mazes
//
//  Created by Scott Tury on 9/17/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class HexagonalMazeHelper : MazeHelper {
    
    public override init() {
        super.init()
        imageNamePrefix = "hex_"
    }
    
    public override func getGrid( _ size: (Int, Int)) -> Grid {
        return HexGrid(rows: size.0, columns: size.1)
    }
    
    public override func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredHexGrid(rows: size.0, columns: size.1)
    }
    
    public override var mazes:[Mazes] {
        get {
            return Mazes.agnosticMazes
        }
    }
    
}
