//
//  MazeHelper.swift
//  Mazes
//
//  Created by Scott Tury on 9/17/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

class MazeHelper {
    
    /// The size of the maze
    public var mazeSize: Int = 40
    // the number of pixels to use for drawing the cell in the maze
    public var cellSize: Int = 40
    
    public var braided: Bool = false
    
    /// MARK: Overrideable methods
    func getGrid( _ size: (Int, Int)) -> Grid {
        return Grid(rows: size.0, columns: size.1)
    }
    
    func getGrid( _ size: Int) -> Grid {
        return getGrid((size, size))
    }
    
    func getColoredGrid( _ size: Int) -> Grid {
        return getColoredGrid((size, size))
    }
    
    func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredRectGrid(rows: size.0, columns: size.1)
    }
    
    public var imageNamePrefix : String   = ""
    public var braidedImagePrefix : String = "braided_"
    
    func startCell( _ grid: Grid ) -> Cell? {
        return grid[(grid.rows/2,grid.columns/2)]
    }
    
    var mazes:[Mazes] {
        get {
            return Mazes.allCases
        }
    }
    
    func automaticNameGeneration(_ maze: Mazes ) -> String {
        var result = "\(imageNamePrefix)"
        if braided {
            result += "\(braidedImagePrefix)"
        }
        result += "\(maze.rawValue)"
        
        return result
    }
    
    /// MARK:
    
    func image( for grid: Grid, name: String = "maze" ) {
        if let image = grid.image(cellSize: cellSize) {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            if let documentURL = URL(string: "\(name).png", relativeTo: URL(fileURLWithPath: documentsPath)) {
                image.output(documentURL)
            }
        }
    }
    
    /// Generated a quick grid, without any maze generation.
    func generateGrid(_ size: Int, name: String  ) {
        let grid = getGrid(size)
        image( for: grid, name: name)
    }
    
    /// generates a quick maze using hte RecursizeBacktracker algorithm.
    func generateMaze(_ size: Int, name: String ) {
        let grid = getGrid(size)
        RecursiveBacktracker.on(grid: grid)
        image( for: grid, name: name)
    }
    
    /// generate a series of mazes at once, using a particular maze algorithm.
    func generateMazes(_ maze: Mazes, max: Int, color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for index in 1...max {
            let grid = getColoredGrid(mazeSize)
            var coloredGrid = grid as? ColoredGrid
            if coloredGrid != nil {
                coloredGrid?.mode = color[index%color.count]
            }
            // .binaryTree, .sidewinder
            Mazes.factory(maze, grid: grid)
            print("\(grid.deadends().count) dead-ends in maze")
            
            if braided {
                grid.braid()
            }
            
            if let startCell = startCell( grid ) {
                if coloredGrid != nil {
                    coloredGrid?.distances = startCell.distances()
                }
            }
            let imageName = "\(automaticNameGeneration( maze ))_\(index)"
            image(for: grid, name: imageName )
        }
    }
    
    /// generate a series of mazes at once, using a multiple maze algorithms.
    func generateMazes(_ mazes: [Mazes], maxes: [Int], color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for (mazeIndex, maze) in mazes.enumerated() {
            let max = maxes[mazeIndex%maxes.count]
            generateMazes(maze, max: max, color:color)
        }
    }
    
    func longestPath(_ grid: Grid) -> Int {
        var result : Int = 0
        
        let start = grid[(0,0)]
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
            
            var coloredGrid = grid as? ColoredGrid
            coloredGrid?.distances = newDistances.path(to: goal)
            
            //            print( grid )
        }
        return result
    }
    
    func generateMazesSolution(_ maze: Mazes, max: Int, color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for index in 1...max {
            let grid = getColoredGrid((mazeSize, mazeSize))
            var coloredGrid = grid as? ColoredGrid
            coloredGrid?.mode = color[index%color.count]
            Mazes.factory(maze, grid: grid)
            
            if braided {
                grid.braid()
            }
            
            //print("\(grid.deadends().count) dead-ends in maze")
            coloredGrid?.maximum = longestPath(grid)
            let imageName = "solution_\(automaticNameGeneration( maze ))_\(index)"
            image(for: grid, name: imageName )
        }
    }
    
    /// generate a series of mazes at once, using a multiple maze algorithms.
    func generateMazesSolutions(_ mazes: [Mazes], maxes: [Int], color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for (mazeIndex, maze) in mazes.enumerated() {
            let max = maxes[mazeIndex%maxes.count]
            generateMazesSolution(maze, max: max, color:color)
        }
    }
}

extension MazeHelper {
    /// Static variable where you can get all of the different MazeHelper classes as an array that you can iterate through.
    static var allHelpers : [MazeHelper] {
        get {
            return [MazeHelper(), CircularMazeHelper(), HexagonalMazeHelper(), TriangularMazeHelper(), PyramidMazeHelper()]
        }
    }
    
    /// This accessor allows you to fetch all of the helpers, and configure them all in the same manner with a block initializer.
    /// You can use this for things like getting helpers to set the braiding of th ehelpers, so you can generate braided mazes, without
    /// having to manually walk though th elist yourself to set the values.
    static func allHelpers(with blockInitializer:(MazeHelper)->Void ) -> [MazeHelper] {
        let  result = MazeHelper.allHelpers
        for helper in result {
            blockInitializer(helper)
        }
        return result
    }
}