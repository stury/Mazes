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
//    let start = grid[Point(row:0,col:0)]
    let start = grid[[0,0]]
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

func distanceGrid() {
    let grid = DistanceGrid(rows: 20, columns: 20)
    // .binaryTree, .sidewinder
    Mazes.factory(.binaryTree, grid: grid)
    //maze(grid)
    //path(grid)
    let pathLength = longestPath(grid)
    print( "longest path length:  \(pathLength)" )
    
    image(for: grid, name: "maze" )
}

func generateMazes(_ maze: Mazes, max: Int, color:ColoredGridMode = .green) {
    for index in 1...max {
        let grid = ColoredGrid(rows: 20, columns: 20)
        grid.mode = color
        // .binaryTree, .sidewinder
        Mazes.factory(maze, grid: grid)
        print("\(grid.deadends().count) dead-ends in maze")
        coloredGrid(grid)
        image(for: grid, name: "\(maze.rawValue)_\(index)" )
    }
}

func killingCells() {
    let grid = Grid(rows: 5, columns: 5)

    /// This function removes the north, south, east, and west cells from accessing the cell.
    func orphanCell( _ cell : Cell ) {
        if let east = cell.east {
            east.west = nil
        }
        cell.east  = nil
        if let west = cell.west {
            west.east = nil
        }
        cell.west  = nil
        
        if let south = cell.south {
            south.north = nil
        }
        cell.south = nil
        if let north = cell.north {
            north.south = nil
        }
        cell.north = nil
    }
    
    if let nwCell = grid[Point( row:0, col:0 )] {
        orphanCell( nwCell )
    }
    if let seCell = grid[Point( row:4, col:4 )] {
        orphanCell( seCell )
    }
    RecursiveBacktracker.on(grid: grid, at: grid[Point(row:1, col:1)])
    
    print( grid )
    image(for: grid, name: "killingCells" )
}

//let grid = ColoredGrid(rows: 20, columns: 20)
//// .binaryTree, .sidewinder
//Mazes.factory(.wilsons, grid: grid)
//coloredGrid(grid)
//image(for: grid, name: "wilsons" )

//generateMazes(.recursiveBacktracker, max: 6, color: .red)
//Mazes.deadends()

killingCells()
