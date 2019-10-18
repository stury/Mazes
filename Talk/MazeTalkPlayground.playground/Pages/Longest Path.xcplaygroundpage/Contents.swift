//: [Previous](@previous)

import Cocoa

func longestPath(_ grid: DistanceGrid) -> Int {
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
        
        grid.distances = newDistances.path(to: goal)
        print( grid )
    }
    return result
}

let grid = ColoredRectGrid.init(rows: 10, columns: 10) //DistanceGrid.init(rows: 10, columns: 10)
Wilsons.on(grid: grid)
longestPath( grid)
let renderer = ImageRenderer.init((1.0, 1.0, 1.0, 0.0))
let image = renderer.mazeImage(grid, cellSize: 20)

//: [Next](@next)
