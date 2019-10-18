//: [Previous](@previous)

import Cocoa

let grid = DistanceGrid.init(rows: 10, columns: 10)
RecursiveBacktracker.on(grid: grid)

let start = grid[(0,0)]
if let distances = start?.distances() {
    grid.distances = distances
}
print( grid )

//: [Next](@next)
