//
//  MazeImageExtensions.swift
//  Mazes
//
//  Created by Scott Tury on 10/4/19.
//  Copyright © 2019 self. All rights reserved.
//

import Foundation
import CoreGraphics
import ImageRenderer

extension Image {
    static var strokeColor = (0.0, 0.0, 0.0, 1.0)
    
    // MARK: - MAZE Specific methods?  Should these be in their own extension?
        
    /// Draws a rectangular maze based on the maze passed in inside the context provided.
    static func gridMaze(in context:CGContext, for maze: Grid, cellSize: Int, strokeSize: Int = 2, solution: Bool = false, showGrid: Bool = false) {
        
        // We just need to draw into the context to render the image...
        //let imageWidth = cellSize * maze.columns
        let imageHeight = cellSize * maze.rows

        // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
        context.saveGState()
        context.translateBy(x: 0, y: CGFloat(imageHeight))
        context.scaleBy(x: 1.0, y: -1.0)

        context.setStrokeColor(red: CGFloat(strokeColor.0), green: CGFloat(strokeColor.1), blue: CGFloat(strokeColor.2), alpha: CGFloat(strokeColor.3))
        
        // fill in each cell
        for mode in MazeRenderingMode.allCases {
            maze.eachCell({ (cell) in
                if let cell = cell as? RectCell {
                    let x1 = cell.column * cellSize
                    let y1 = cell.row * cellSize
                    let x2 = (cell.column+1)*cellSize
                    let y2 = (cell.row+1)*cellSize
                    
                    if mode == .backgrounds {
                        var red, green, blue: CGFloat
                        (red, green, blue) = (1.0, 1.0, 1.0)
                        if let coloredMaze = maze as? ColoredGrid {
                            (red, green, blue) = coloredMaze.backgroundColor(for: cell)
                        }
                        context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
                        if showGrid {
                            context.fill(CGRect(x: x1+1, y: y1+1, width: cellSize-1, height: cellSize-1))
                        }
                        else {
                            context.fill(CGRect(x: x1+1, y: y1+1, width: cellSize, height: cellSize))
                        }
                    }
                    else {
                        
                        context.setLineWidth(CGFloat(strokeSize))
                        context.setLineJoin(CGLineJoin.round)
                        context.setFillColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                        
                        if cell.north == nil {
                            context.move(to: CGPoint(x: x1, y: y1))
                            context.addLine(to: CGPoint(x: x2, y: y1))
                            context.drawPath(using: .fillStroke)
                        }
                        if cell.west == nil {
                            context.move(to: CGPoint(x: x1, y: y1))
                            context.addLine(to: CGPoint(x: x1, y: y2))
                            context.drawPath(using: .fillStroke)
                        }
                        if let east = cell.east, cell.linked(east) {
                        }
                        else {
                            context.move(to: CGPoint(x: x2, y: y1))
                            context.addLine(to: CGPoint(x: x2, y: y2))
                            context.drawPath(using: .fillStroke)
                        }
                        if let south = cell.south, cell.linked(south) {
                        }
                        else {
                            context.move(to: CGPoint(x: x1, y: y2))
                            context.addLine(to: CGPoint(x: x2, y: y2))
                            context.drawPath(using: .fillStroke)
                        }
                    }
                }
                return false
            })
        }
        context.restoreGState()
    }
    
    /// Draws a hexagonal maze based on the maze passed in.
    static func hexMaze(in context:CGContext, for maze: Grid, cellSize: Int, strokeSize: Int = 2, solution: Bool = false, showGrid: Bool = false) {

        let size = Double(cellSize)
        let aSize = size/2.0
        let bSize = size * Double(3.0).squareRoot() / 2.0
        //let width = size*2.0
        let height = bSize * 2
        
//        let imgWidth = Int(3.0 * aSize * Double(maze.columns) + aSize + 0.5)
        let imgHeight = Int(height * Double(maze.rows) + bSize + 0.5)

        // Setup the basic fill and stroke colors...
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
        context.saveGState()
        context.translateBy(x: 0, y: CGFloat(imgHeight))
        context.scaleBy(x: 1.0, y: -1.0)
        context.setLineWidth(CGFloat(strokeSize))
        context.setLineJoin(CGLineJoin.round)
        
        for mode in MazeRenderingMode.allCases {
            maze.eachCell { (cell) -> Bool in

                if let cell = cell as? HexCell {
                    
                    let row = Double(cell.row)
                    let col = Double(cell.column)
                    let cx = size + Double(3)  * col * aSize
                    var cy = bSize + row * height
                    if cell.column.odd {
                        cy += bSize
                    }
                    
                    // f/n = far/near
                    // n/s/e/w = north/south/east/west
                    let x_fw = CGFloat(cx - size)
                    let x_nw = CGFloat(cx - aSize)
                    let x_ne = CGFloat(cx + aSize)
                    let x_fe = CGFloat(cx + size)
                    
                    // m = middle
                    let y_n = CGFloat(cy - bSize)
                    let y_m = CGFloat(cy)
                    let y_s = CGFloat(cy + bSize)
                    
                    switch( mode ) {
                        
                    case .backgrounds:
                        var red, green, blue: CGFloat
                        (red, green, blue) = (1.0, 1.0, 1.0)
                        if let coloredMaze = maze as? ColoredGrid {
                            (red, green, blue) = coloredMaze.backgroundColor(for: cell)
                        }
                        
                        context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
                        context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)

                        context.drawPolygon(points: [(x_fw,y_m), (x_nw, y_n), (x_ne, y_n),
                                                     (x_fe, y_m), (x_ne, y_s), (x_nw, y_s)])
                    case .walls:
                        
                        context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                        if cell.southwest == nil {
                            context.drawLineSegment(points: [(x_fw, y_m), (x_nw,y_s)])
                        }
                        if cell.northwest == nil {
                            context.drawLineSegment(points: [(x_fw, y_m), (x_nw,y_n)])
                        }
                        if cell.north == nil {
                            context.drawLineSegment(points: [(x_nw, y_n), (x_ne,y_n)])
                        }
                        
                        if cell.northeast == nil {
                            context.drawLineSegment(points: [(x_ne, y_n), (x_fe, y_m)])
                        }
                        else if let northeast = cell.northeast, !cell.linked(northeast) {
                            context.drawLineSegment(points: [(x_ne, y_n), (x_fe, y_m)])
                        }
                        if cell.southeast == nil {
                            context.drawLineSegment(points: [(x_fe, y_m), (x_ne, y_s)])
                        }
                        else if let southeast = cell.southeast, !cell.linked(southeast) {
                            context.drawLineSegment(points: [(x_fe, y_m), (x_ne, y_s)])
                        }
                        if cell.south == nil {
                            context.drawLineSegment(points: [(x_ne, y_s), (x_nw, y_s)])
                        }
                        else if let south = cell.south, !cell.linked(south) {
                            context.drawLineSegment(points: [(x_ne, y_s), (x_nw, y_s)])
                        }
                    }
                }
                
                return false
            }
        }
        
        context.restoreGState()
    }

    /// Draws a circular maze based on the maze passed in.
    static func polarMaze(in context:CGContext, for maze: Grid, cellSize: Int, strokeSize: Int = 2, solution: Bool = false, showGrid: Bool = false ) {
        
        let imageSize = 2*maze.rows*cellSize
        
        // Draw ...
        // the background color...
        context.setLineWidth(CGFloat(strokeSize))
        context.setLineJoin(CGLineJoin.round)
        
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context.addEllipse(in: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        context.drawPath(using: .fillStroke)
        
        // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
        context.saveGState()
        context.translateBy(x: 0, y: CGFloat(imageSize))
        context.scaleBy(x: 1.0, y: -1.0)
        
        let center = Int(Double(imageSize) / 2.0)
        let centerPoint = CGPoint(x: center, y: center)
        
        for mode in MazeRenderingMode.allCases {
            maze.eachCell { (cell) in
                if let cell = cell as? PolarCell {
                    if cell.row > 0 {
                        let theta = 2 * Double.pi / Double(maze.grid[cell.row].count)
                        let innerRadius = Double(cell.row*cellSize)
                        let outerRadius = Double((cell.row+1)*cellSize)
                        let thetaCCW = Double(cell.column) * theta
                        let thetaCW = Double((cell.column+1)) * theta
                        
                        let a = CGPoint(x: Int(Double(center)  + (innerRadius * cos(thetaCCW))),
                                        y: Int(Double(center) + (innerRadius * sin(thetaCCW))))
                        //                            let b = CGPoint(x: Int(Double(center)  + (outerRadius * cos(thetaCCW))),
                        //                                            y: Int(Double(center) + (outerRadius * sin(thetaCCW))))
                        let c = CGPoint(x: Int(Double(center)  + (innerRadius * cos(thetaCW))),
                                        y: Int(Double(center) + (innerRadius * sin(thetaCW))))
                        let d = CGPoint(x: Int(Double(center)  + (outerRadius * cos(thetaCW))),
                                        y: Int(Double(center) + (outerRadius * sin(thetaCW))))
                        
                        switch mode {
                        case .backgrounds:
                            // fill in each cell
                            var red, green, blue: CGFloat
                            (red, green, blue) = (1.0, 1.0, 1.0)
                            if let coloredMaze = maze as? ColoredGrid {
                                (red, green, blue) = coloredMaze.backgroundColor(for: cell)
                            }
                            context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
                            context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                            //context.setLineWidth(1.0)
                            
                            // Add in code here to fill in the area for this cell.
                            context.beginPath()
                            context.move(to: a)
                            context.addArc(center: centerPoint, radius: CGFloat(innerRadius), startAngle: CGFloat(thetaCCW), endAngle: CGFloat(thetaCW), clockwise: false)
                            context.addLine(to: d)
                            context.addArc(center: centerPoint, radius: CGFloat(outerRadius), startAngle: CGFloat(thetaCW), endAngle: CGFloat(thetaCCW), clockwise: true)
                            context.addLine(to: a)
                            context.closePath()
                            //context.fillPath()
                            
                            //                            context.beginPath()
                            //                            context.move(to: CGPoint(x: ax, y: ay))
                            //                            context.addLine(to: CGPoint(x: bx, y: by))
                            //                            context.addLine(to: CGPoint(x: dx, y: dy))
                            //                            context.addLine(to: CGPoint(x: cx, y: cy))
                            //                            context.addLine(to: CGPoint(x: ax, y: ay))
                            //                            context.closePath()
                            context.drawPath(using: .fillStroke)
                            
                        case .walls:
                            context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                            //context.setLineWidth(CGFloat(strokeSize))
                            
                            if let inward = cell.inward {
                                if !cell.linked(inward) {
                                    //                                context.move(to: CGPoint(x: ax, y: ay))
                                    //                                context.addLine(to: CGPoint(x: cx, y: cy))
                                    //                                context.drawPath(using: .stroke)
                                    
                                    context.addArc(center: centerPoint, radius: CGFloat(innerRadius), startAngle: CGFloat(thetaCW), endAngle: CGFloat(thetaCCW), clockwise: true)
                                    context.drawPath(using: .stroke)
                                }
                            }
                            
                            if let cw = cell.cw {
                                if !cell.linked(cw) {
                                    context.move(to: c)
                                    context.addLine(to: d)
                                    context.drawPath(using: .stroke)
                                }
                            }
                        }
                    }
                    else {  // row == 0
                        let outerRadius = Double((cell.row+1)*cellSize)
                        if mode == .backgrounds {
                            var red, green, blue: CGFloat
                            (red, green, blue) = (1.0, 1.0, 1.0)
                            if let coloredMaze = maze as? ColoredGrid {
                                (red, green, blue) = coloredMaze.backgroundColor(for: cell)
                            }
                            context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
                            context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                            //context.setLineWidth(1.0)
                            
                            context.beginPath()
                            let origin = CGPoint(x: centerPoint.x-CGFloat(outerRadius), y: centerPoint.x-CGFloat(outerRadius))
                            let rect = CGRect(origin: origin, size: CGSize(width: CGFloat(2*outerRadius), height: CGFloat(2*outerRadius)))
                            context.addEllipse(in: rect)
                            context.closePath()
                            
                            context.fillPath()
                        }
                    }
                }
                return false
            }
            
            // redraw the outside wall
            context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            //context.setLineWidth(CGFloat(strokeSize))
            
            context.addEllipse(in: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
            context.drawPath(using: .stroke)
        }
        
        context.restoreGState()
    }
    
    /// Draws a maze based on triangular cells.
    static func triangleMaze(in context: CGContext, for maze: Grid, cellSize: Int, strokeSize: Int = 2, solution: Bool = false, showGrid: Bool = false ) {
                
        let size = Double(cellSize)
        let halfWidth = size / 2.0
        let height = size * Double(3.0).squareRoot() / 2.0
        let halfHeight = height / 2.0
        
        //let imgWidth = Int(size * Double(maze.columns+1)/2.0)
        let imgHeight = Int(height * Double(maze.rows))
        
        // Draw the background transparent...
        context.setLineWidth(CGFloat(strokeSize))
        context.setLineJoin(CGLineJoin.round)
        
        // Setup the basic fill and stroke colors...
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
        context.saveGState()
        context.translateBy(x: 0, y: CGFloat(imgHeight))
        context.scaleBy(x: 1.0, y: -1.0)
        
        for mode in MazeRenderingMode.allCases {
            maze.eachCell { (cell) -> Bool in
                
                if let cell = cell as? TriangleCell {
                    
                    let row = Double(cell.row)
                    let col = Double(cell.column)
                    
                    let cx = halfWidth + col * halfWidth
                    let cy = halfHeight + row * height
                    
                    let west_x = CGFloat(cx - halfWidth)
                    let mid_x = CGFloat(cx)
                    let east_x = CGFloat(cx + halfWidth)
                    
                    var apex_y : CGFloat
                    var base_y : CGFloat
                    if cell.upright {
                        apex_y = CGFloat(cy - halfHeight)
                        base_y = CGFloat(cy + halfHeight)
                    }
                    else {
                        apex_y = CGFloat(cy + halfHeight)
                        base_y = CGFloat(cy - halfHeight)
                    }
                    
                    switch( mode ) {
                        
                    case .backgrounds:
                        var red, green, blue : CGFloat
                        (red, green, blue) = (1.0, 1.0, 1.0)
                        if let coloredMaze = maze as? ColoredGrid {
                            (red, green, blue) = coloredMaze.backgroundColor(for: cell)
                        }
                        context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
                        context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                            
                        context.drawPolygon(points: [(west_x,base_y), (mid_x, apex_y), (east_x, base_y)])

                    case .walls:
                        context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                        if cell.west == nil {
                            context.drawLineSegment(points: [(west_x, base_y), (mid_x, apex_y)])
                        }
                        
                        if cell.east == nil {
                            context.drawLineSegment(points: [(east_x, base_y), (mid_x,apex_y)])
                        }
                        else if let east = cell.east, !cell.linked(east) {
                            context.drawLineSegment(points: [(east_x, base_y), (mid_x,apex_y)])
                        }
                        
                        let no_south = cell.upright && cell.south == nil
                        let not_linked = !cell.upright && !cell.linked(cell.north)
                        
                        if no_south || not_linked {
                            context.drawLineSegment(points: [(east_x,base_y), (west_x,base_y)])
                        }
                    }
                }
                
                return false
            }
        }
        
        context.restoreGState()
    }
    
    /// Draws a triangle maze built out of triangle cells.
    static func pyramidMaze(in context:CGContext, for maze: Grid, cellSize: Int, strokeSize: Int = 2, solution: Bool = false, showGrid: Bool = false ) {
        
        let size = Double(cellSize)
        let halfWidth = size / 2.0
        let height = size * Double(3.0).squareRoot() / 2.0
        let halfHeight = height / 2.0
        
        //let imgWidth = Int(size * Double(maze.columns+1)/2.0)
        let imgHeight = Int(height * Double(maze.rows))
        
        // Draw the background transparent...
        context.setLineWidth(CGFloat(strokeSize))
        context.setLineJoin(CGLineJoin.round)
        
        // Setup the basic fill and stroke colors...
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
        context.saveGState()
        context.translateBy(x: 0, y: CGFloat(imgHeight))
        context.scaleBy(x: 1.0, y: -1.0)
        
        for mode in MazeRenderingMode.allCases {
            maze.eachCell { (cell) -> Bool in
                
                if let cell = cell as? TriangleCell {
                    
                    let row = Double(cell.row)
                    let col = Double(cell.column)
                    
                    let currentCellsInRow = maze.grid[cell.row].count
                    let baseCellsInRow = maze.grid[maze.rows-1].count
                    let padding = Double(baseCellsInRow - currentCellsInRow)/2.0
                    
                    let cx = halfWidth + ((col+padding)*halfWidth)
                    let cy = halfHeight + row * height
                    
                    let west_x = Int(cx - halfWidth)
                    let mid_x = Int(cx)
                    let east_x = Int(cx + halfWidth)
                    
                    var apex_y : Int
                    var base_y : Int
                    
                    if cell.upright {
                        apex_y = Int(cy - halfHeight)
                        base_y = Int(cy + halfHeight)
                    }
                    else {
                        apex_y = Int(cy + halfHeight)
                        base_y = Int(cy - halfHeight)
                    }
                    
                    switch( mode ) {
                        
                    case .backgrounds:
                        var red, green, blue : CGFloat
                        (red, green, blue) = (1.0, 1.0, 1.0)
                        if let coloredMaze = maze as? ColoredGrid {
                            (red, green, blue) = coloredMaze.backgroundColor(for: cell)
                        }
                        context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
                        context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                        
                        context.drawPolygon(points: [(west_x,base_y), (mid_x, apex_y), (east_x, base_y)])
                        
                    case .walls:
                        context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                        if cell.west == nil {
                            context.drawLineSegment(points: [(west_x, base_y), (mid_x, apex_y)])
                        }
                        
                        if cell.east == nil {
                            context.drawLineSegment(points: [(east_x, base_y), (mid_x,apex_y)])
                        }
                        else if let east = cell.east, !cell.linked(east) {
                            context.drawLineSegment(points: [(east_x, base_y), (mid_x,apex_y)])
                        }
                        
                        let no_south = cell.upright && cell.south == nil
                        let not_linked = !cell.upright && !cell.linked(cell.north)
                        
                        if no_south || not_linked {
                            context.drawLineSegment(points: [(east_x,base_y), (west_x,base_y)])
                        }
                    }
                }
                
                return false
            }
        }
        
        context.restoreGState()
    }

    /// Draws a triangle maze built out of triangle cells.
    static func diamondMaze(in context:CGContext, for maze: Grid, cellSize: Int, strokeSize: Int = 2, solution: Bool = false, showGrid: Bool = false ) {
        
        let size = Double(cellSize)
        let halfWidth = size / 2.0
        let height = size * Double(3.0).squareRoot() / 2.0
        let halfHeight = height / 2.0
        
        //let imgWidth = Int(size * Double(maze.columns+1)/2.0)
        let imgHeight = Int(height * Double(maze.rows))
        
        // Draw the background transparent...
        context.setLineWidth(CGFloat(strokeSize))
        context.setLineJoin(CGLineJoin.round)
        
        // Setup the basic fill and stroke colors...
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
        context.saveGState()
        context.translateBy(x: 0, y: CGFloat(imgHeight))
        context.scaleBy(x: 1.0, y: -1.0)
        
        for mode in MazeRenderingMode.allCases {
            maze.eachCell { (cell) -> Bool in
                
                if let cell = cell as? DiamondCell {
                    
                    let row = Double(cell.row)
                    let col = Double(cell.column)
                    
                    let currentCellsInRow = maze.grid[cell.row].count
                    let baseCellsInRow = maze.columns // Unlike the Pyramid maze, the maze.columns should specify the base cells // maze.grid[maze.rows-1].count
                    let padding = Double(baseCellsInRow - currentCellsInRow)/2.0
                    
                    let cx = halfWidth + ((col+padding)*halfWidth)
                    let cy = halfHeight + row * height
                    
                    let west_x = Int(cx - halfWidth)
                    let mid_x = Int(cx)
                    let east_x = Int(cx + halfWidth)
                    
                    var apex_y : Int
                    var base_y : Int
                    
                    if cell.upright {
                        apex_y = Int(cy - halfHeight)
                        base_y = Int(cy + halfHeight)
                    }
                    else {
                        apex_y = Int(cy + halfHeight)
                        base_y = Int(cy - halfHeight)
                    }
                    
                    switch( mode ) {
                        
                    case .backgrounds:
                        var red, green, blue : CGFloat
                        (red, green, blue) = (1.0, 1.0, 1.0)
                        if let coloredMaze = maze as? ColoredGrid {
                            (red, green, blue) = coloredMaze.backgroundColor(for: cell)
                        }
                        context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
                        context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                        
                        context.drawPolygon(points: [(west_x,base_y), (mid_x, apex_y), (east_x, base_y)])
                        
                    case .walls:
                        context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                        if cell.west == nil {
                            context.drawLineSegment(points: [(west_x, base_y), (mid_x, apex_y)])
                        }
                        
                        if cell.east == nil {
                            context.drawLineSegment(points: [(east_x, base_y), (mid_x,apex_y)])
                        }
                        else if let east = cell.east, !cell.linked(east) {
                            context.drawLineSegment(points: [(east_x, base_y), (mid_x,apex_y)])
                        }
                        
                        let no_south = cell.upright && cell.south == nil
                        let not_linked = !cell.upright && !cell.linked(cell.north)
                        
                        if no_south || not_linked {
                            context.drawLineSegment(points: [(east_x,base_y), (west_x,base_y)])
                        }
                    }
                }
                
                return false
            }
        }
        
        context.restoreGState()
    }

}
