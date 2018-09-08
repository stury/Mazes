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

func polarImage( for grid: Grid, name: String = "polarmaze" ) {
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
        if let southwestCell = grid[[grid.rows-1, 0]] {
            grid.distances = distances.path(to: southwestCell)
            print( "Path from northwest corner to southwest corner" )
            print( grid )
        }
    }
    
}

func longestPath(_ grid: DistanceGrid) -> Int {
    var result : Int = 0
    
    let start = grid[[0,0]]
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
    if let start = grid[[grid.rows/2,grid.columns/2]] {
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

func generateMazes(_ mazes: [Mazes], maxes: [Int], color:[ColoredGridMode] = [.green]) {
    for (mazeIndex, maze) in mazes.enumerated() {
        let max = maxes[mazeIndex%maxes.count]
        for index in 1...max {
            let grid = ColoredGrid(rows: 20, columns: 20)
            grid.mode = color[index%color.count]
            // .binaryTree, .sidewinder
            Mazes.factory(maze, grid: grid)
            print("\(grid.deadends().count) dead-ends in maze")
            coloredGrid(grid)
            image(for: grid, name: "\(maze.rawValue)_\(index)" )
        }
    }
}


func killingCells_v1() {
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
    
    if let nwCell = grid[[0, 0]] {
        orphanCell( nwCell )
    }
    if let seCell = grid[[4, 4]] {
        orphanCell( seCell )
    }
    RecursiveBacktracker.on(grid: grid, at: grid[[1, 1]])
    
    print( grid )
    image(for: grid, name: "killingCells" )
}

func killingCells_v2() {
    let mask = Mask(rows: 5, columns: 5)
    mask[[0,0]] = false
    mask[[2,2]] = false
    mask[[4,4]] = false
    
    let grid = MaskedGrid(mask)
    RecursiveBacktracker.on(grid: grid)
    
    print( grid )
    image(for: grid, name: "killingCells" )
}

/// This method works for Text and Image file data for the mask.
func killingCells(_ path: String) {
    let url = URL(fileURLWithPath: path)
    if let mask = Mask.from(url) {
        let grid = MaskedGrid.init(mask)
        RecursiveBacktracker.on(grid: grid)
        print( grid )
        image(for: grid, name: "killingCells" )
    }
    else {
        print( "File \(url) did not exist!" )
    }
}

//generateMazes(.recursiveBacktracker, max: 6, color: .red)
//Mazes.deadends()
//generateMazes(Mazes.allCases, maxes: [6], color: ColoredGridMode.allCases )
//killingCells("../../../../../Examples/MazeMask.txt")
//killingCells("../../../../../Examples/MazeMask.png")
//killingCells("../../../../../Examples/Scott Maze.png")

func circlularGrid(_ rows: Int, name: String = "polar_grid"  ) {
    let grid = PolarGrid(rows)
    polarImage( for: grid, name: name)
}

func circlularMaze(_ rows: Int, name: String = "polar" ) {
    let grid = PolarGrid(rows)
    RecursiveBacktracker.on(grid: grid)
    polarImage( for: grid, name: name)
}

func generatePolarMazes(_ maze: Mazes, max: Int, color:ColoredGridMode = .green) {
    for index in 1...max {
        let grid = ColoredPolarGrid(20)
        grid.mode = color
        // .binaryTree, .sidewinder
        Mazes.factory(maze, grid: grid)
        print("\(grid.deadends().count) dead-ends in maze")
        if let origin = grid[[0,0]] {
            grid.distances = origin.distances()
        }
        image(for: grid, name: "polar_\(maze.rawValue)_\(index)" )
    }
}

//circlularGrid(20)
//circlularMaze(20)
generatePolarMazes(.recursiveBacktracker, max: 1)

