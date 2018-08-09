//
//  AldousBroder.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/26/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

class AldousBroder : MazeGenerator {
    
    public static func on( grid: Grid ) {
        AldousBroder.on( grid:grid, at: grid.randomCell() )
    }
    
    static func on( grid: Grid, at: Cell? ) {
        var cell : Cell?
        if let at = at {
            cell = at
        }
        else {
            cell = grid.randomCell()
        }
        var unvisited = grid.size()-1
        
        while unvisited > 0 {
            var neighbor : Cell?
            if let cell = cell {
                neighbor = cell.neighbors().sample()
                if let neighbor = neighbor {
                    if neighbor.links.count == 0 {
                        cell.link(cell: neighbor)
                        unvisited -= 1
                    }
                }
            }
            cell = neighbor
        }
    }
}
