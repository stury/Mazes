//
//  Image.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/22/18.
//  Copyright © 2018 self. All rights reserved.
//

#if os(macOS)
    import Cocoa
    public typealias Image = NSImage
    
    extension NSImage {
        
        convenience init(cgImage: CGImage) {
            self.init(cgImage: cgImage, size: CGSize(width: cgImage.width, height: cgImage.height))
        }
        
    }
    
#endif

#if os(iOS)
    import UIKit
    public typealias Image = UIImage
#endif

let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

public extension Image {
    
    public static func cgImage(for maze: Grid, cellSize: Int, solution: Bool = false, showGrid: Bool = false ) -> CGImage? {
        
        var result : CGImage? = nil
        
        let imageWidth = cellSize * maze.columns
        let imageHeight = cellSize * maze.rows
        
        // Create a bitmap graphics context of the given size
        //
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let context = CGContext(data: nil, width: Int(imageWidth /** imageScale*/)+1, height: Int(imageHeight /** imageScale*/)+1, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue ) {
            
            // Draw ...
            // the background color...
            context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
            //context.addRect( CGRect(x: 0, y: 0, width: width, height: height) )
            context.fill(CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
            
            // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
            context.saveGState()
            context.translateBy(x: 0, y: CGFloat(imageHeight))
            context.scaleBy(x: 1.0, y: -1.0)
            
            // fill in each cell
            for mode in RenderingMode.allCases {
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
                        
                            context.setLineWidth(2.0)
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
            
            // Get your image
            //
            result = context.makeImage()
        }
        
        return result;
    }

    public static func cgHexImage(for maze: Grid, cellSize: Int, solution: Bool = false, showGrid: Bool = false ) -> CGImage? {
        
        var result : CGImage? = nil
        
        let size = Double(cellSize)
        let aSize = size/2.0
        let bSize = size * Double(3.0).squareRoot() / 2.0
        //let width = size*2.0
        let height = bSize * 2
        
        let imgWidth = Int(3.0 * aSize * Double(maze.columns) + aSize + 0.5)
        let imgHeight = Int(height * Double(maze.rows) + bSize + 0.5)

        // Create a bitmap graphics context of the given size
        //
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let context = CGContext(data: nil, width: imgWidth+1, height: imgHeight+1, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue ) {
            
            // Draw the background transparent...
            context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
            context.fill(CGRect(x: 0, y: 0, width: imgWidth+1, height: imgHeight+1))

            // Setup the basic fill and stroke colors...
            context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            
            // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
            context.saveGState()
            context.translateBy(x: 0, y: CGFloat(imgHeight))
            context.scaleBy(x: 1.0, y: -1.0)
            context.setLineWidth(2.0)
            
            for mode in RenderingMode.allCases {
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
                        let x_fw = Int(cx - size)
                        let x_nw = Int(cx - aSize)
                        let x_ne = Int(cx + aSize)
                        let x_fe = Int(cx + size)
                        
                        // m = middle
                        let y_n = Int(cy - bSize)
                        let y_m = Int(cy)
                        let y_s = Int(cy + bSize)
                        
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
            
            // Get your image
            //
            result = context.makeImage()
        }
        
        return result;
    }

    public static func cgPolarImage(for maze: Grid, cellSize: Int, solution: Bool = false, showGrid: Bool = false ) -> CGImage? {
        
        var result : CGImage? = nil
        
        let imageSize = 2*maze.rows*cellSize
        
        // Create a bitmap graphics context of the given size
        //
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let context = CGContext(data: nil, width: Int(imageSize)+1, height: Int(imageSize)+1, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue ) {
            
            // Draw ...
            // the background color...
            context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
            //context.addRect( CGRect(x: 0, y: 0, width: width, height: height) )
            context.fill(CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
            
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
            
            for mode in RenderingMode.allCases {
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
                                context.setLineWidth(1.0)
                                
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
                                context.setLineWidth(2.0)
                                
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
                    }
                    return false
                }
                
                // redraw the outside wall
                context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                context.setLineWidth(2.0)
                
                context.addEllipse(in: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
                context.drawPath(using: .stroke)
            }
            
            context.restoreGState()
            
            // Get your image
            //
            result = context.makeImage()
        }
        
        return result;
    }
   
    public static func cgTriangleImage(for maze: Grid, cellSize: Int, solution: Bool = false, showGrid: Bool = false ) -> CGImage? {
        
        var result : CGImage? = nil
        
        let size = Double(cellSize)
        let halfWidth = size / 2.0
        let height = size * Double(3.0).squareRoot() / 2.0
        let halfHeight = height / 2.0
        
        let imgWidth = Int(size * Double(maze.columns+1)/2.0)
        let imgHeight = Int(height * Double(maze.rows))
        
        // Create a bitmap graphics context of the given size
        //
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let context = CGContext(data: nil, width: imgWidth+1, height: imgHeight+1, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue ) {
            
            // Draw the background transparent...
            context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
            context.fill(CGRect(x: 0, y: 0, width: imgWidth+1, height: imgHeight+1))
            
            // Setup the basic fill and stroke colors...
            context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            context.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            
            // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
            context.saveGState()
            context.translateBy(x: 0, y: CGFloat(imgHeight))
            context.scaleBy(x: 1.0, y: -1.0)
            context.setLineWidth(2.0)
            
            for mode in RenderingMode.allCases {
                maze.eachCell { (cell) -> Bool in
                    
                    if let cell = cell as? TriangleCell {
                        
                        let row = Double(cell.row)
                        let col = Double(cell.column)
                        
                        let cx = halfWidth + col * halfWidth
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
            
            // Get your image
            //
            result = context.makeImage()
        }
        
        return result;
    }

}



public func output(_ image: Image?, url: URL) {
    if let image = image {
        #if os(macOS)
            if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                let bitmap = NSBitmapImageRep(cgImage: cgImage)
                if let data = bitmap.representation(using: .png, properties: [:]) {
                    try? data.write(to: url)
                    print( url )
                }
            }
        //        if let bits = imageRep.representations.first as? NSBitmapImageRep {
        //            if let data = bits.representation(using: .png, properties: [:]) {
        //                try? data.write(to: URL(fileURLWithPath: "./maze.png"))
        //            }
        //        }
        #endif
    }
}

