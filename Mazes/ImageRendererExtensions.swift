//
//  ImageRendererExtensions.swift
//  Mazes
//
//  Created by Scott Tury on 10/9/19.
//  Copyright © 2019 self. All rights reserved.
//

import Foundation

extension ImageRenderer {
    
    public func mazeImage(_ grid: Grid, cellSize: Int, strokeSize: Int = 2 ) -> Image? {
        let result : Image? = raster(size: grid.imageSize(cellSize)) { (context) in
            if let grid = grid as? DiamondGrid {
                Image.diamondMaze(in:context, for: grid, cellSize: cellSize, strokeSize: strokeSize)
            }
            else if let grid = grid as? TriangleGrid {
                Image.triangleMaze(in:context, for: grid, cellSize: cellSize, strokeSize: strokeSize)
            }
            else if let grid = grid as? HexGrid {
                Image.hexMaze(in:context, for: grid, cellSize: cellSize, strokeSize: strokeSize)
            }
            else if let grid = grid as? PolarGrid {
                Image.polarMaze(in:context, for: grid, cellSize: cellSize, strokeSize: strokeSize)
            }
            else {
                Image.gridMaze(in:context, for: grid, cellSize: cellSize, strokeSize: strokeSize)
            }
        }
        return result
    }
    
    public func mazePdfImage(_ grid: Grid, cellSize: Int, strokeSize: Int = 2 ) -> Data? {
        let result : Data? = data(mode: .pdf, size: grid.imageSize(cellSize)) { (context) in
            if let grid = grid as? DiamondGrid {
                Image.diamondMaze(in:context, for: grid, cellSize: cellSize, strokeSize: strokeSize)
            }
            else if let grid = grid as? TriangleGrid {
                Image.triangleMaze(in:context, for: grid, cellSize: cellSize, strokeSize: strokeSize)
            }
            else if let grid = grid as? HexGrid {
                Image.hexMaze(in:context, for: grid, cellSize: cellSize, strokeSize: strokeSize)
            }
            else if let grid = grid as? PolarGrid {
                Image.polarMaze(in:context, for: grid, cellSize: cellSize, strokeSize: strokeSize)
            }
            else {
                Image.gridMaze(in:context, for: grid, cellSize: cellSize, strokeSize: strokeSize)
            }
        }
        return result
    }
}
