//
//  Wilsons.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/26/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class Wilsons : MazeGenerator {
    
    public static func on( grid: Grid ) {
        var unvisited : [Cell] = [Cell]()
        grid.eachCell { (cell) in
            if let cell = cell {
                unvisited.append(cell)
            }
            return false
        }
        let first = unvisited.sample()
        Wilsons.on(grid: grid, at: first)
    }

    static func on( grid: Grid, at: Cell? ) {
        var unvisited : [Cell] = [Cell]()
        grid.eachCell { (cell) in
            if let cell = cell {
                unvisited.append(cell)
            }
            return false
        }
        if let first = at {
            unvisited = unvisited.filter { $0 != first }
            //        if let index = unvisited.index(of: first) {
            //            unvisited.remove(at: index)
            //        }
            
            while unvisited.count > 0 {
                var cell = unvisited.sample()
                var path = [Cell]()
                path.append(cell)
                
                while let _ = unvisited.firstIndex(of: cell) {
                    cell = cell.neighbors().sample()
                    let position = path.firstIndex(of: cell)
                    if position != nil {
                        path.removeAll()
                    }
                    path.append(cell)
                }
                
                for index in 0...path.count-2 {
                    path[index].link(cell: path[index+1])
                    unvisited = unvisited.filter { $0 != path[index] }
                }
            }
        }
    }
}
