//
//  main.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/21/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

func image( for grid: Grid, name: String = "maze" ) {
    if let image = grid.image(cellSize: 20) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if let documentURL = URL(string: "\(name).png", relativeTo: URL(fileURLWithPath: documentsPath)) {
            output(image, url: documentURL)
        }
    }
}

func maze(_ grid: Grid ) {
    print( grid )
}

func path(_ grid: DistanceGrid) {
    let start = grid[Point(row:0,col:0)]
    if let distances = start?.distances() {
        grid.distances = distances
        print( grid )
        if let southwestCell = grid[Point(row:grid.rows-1, col:0)] {
            grid.distances = distances.path(to: southwestCell)
            print( "Path from northwest corner to southwest corner" )
            print( grid )
        }
    }
    
}

func longestPath(_ grid: DistanceGrid) -> Int {
    var result : Int = 0
    
    let start = grid[Point(row:0,col:0)]
    if let distances = start?.distances() {
        var newStart: Cell
        var distance : Int
        (cell:newStart, distance:distance) = distances.max()
        //print(distance)
        let newDistances = newStart.distances()
        let goal : Cell
        (cell:goal,distance:distance) = newDistances.max()
        //print(distance)
        result = distance
        
        grid.distances = newDistances.path(to: goal)
        print( grid )
    }
    return result
}

func coloredGrid(_ grid: ColoredGrid) {
    if let start = grid[Point(row:grid.rows/2,col:grid.columns/2)] {
        grid.distances = start.distances() 
    }
}

let grid = ColoredGrid(rows: 20, columns: 20)
// .binaryTree, .sidewinder
let generator = Mazes.factory(.sidewinder, grid: grid)

//maze(grid)
//path(grid)
//let pathLength = longestPath(grid)
//print( "longest path length:  \(pathLength)" )
coloredGrid(grid)

image(for: grid, name: "coloredMagenta" )


