//: [Previous](@previous)

import Foundation

let grid = ColoredRectGrid(rows: 10, columns: 10)
RecursiveBacktracker.on(grid: grid)
let start = grid[(5,5)]
if let distances = start?.distances() {
    grid.distances = distances
}

let renderer = ImageRenderer.init((1.0, 1.0, 1.0, 0.0))
let image = renderer.mazeImage(grid, cellSize: 20)
grid.mode = .none
let basicImage = renderer.mazeImage(grid, cellSize: 20)


//: [Next](@next)
