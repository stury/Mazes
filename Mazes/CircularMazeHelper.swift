//
//  CircularHelper.swift
//  Mazes
//
//  Created by Scott Tury on 9/17/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class CircularMazeHelper : MazeHelper {
    
    public override var supportsColumns : Bool {
        get {
            return false
        }
    }

    public override init() {
        super.init()
        imageNamePrefix = "circular_"
    }
    
    public override func getGrid( _ size: (Int, Int)) -> Grid {
        return PolarGrid(size.0)
    }
    
    public override func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredPolarGrid(size.0)
    }
    
    public override func startCell( _ grid: Grid ) -> Cell? {
        return grid[(0,0)]
    }
    
    public override var mazes:[Mazes] {
        get {
            var mazes = Mazes.agnosticMazes
            // .aldousBroder mazes don't seem to work for circular mazes...
            if let index = mazes.index(of: .aldousBroder) {
                mazes.remove(at: index)
            }
            return mazes
        }
    }
    
}
