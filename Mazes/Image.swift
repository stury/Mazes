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
            maze.eachCell({ (cell) in
                if let cell = cell {
                    let x1 = cell.column * cellSize
                    let y1 = cell.row * cellSize
                    let x2 = (cell.column+1)*cellSize
                    let y2 = (cell.row+1)*cellSize
                    
                    if maze.background() {
                        let red, green, blue: CGFloat
                        (red, green, blue) = maze.backgroundColor(for: cell)
                        context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
                        if showGrid {
                            context.fill(CGRect(x: x1+1, y: y1+1, width: cellSize-1, height: cellSize-1))
                        }
                        else {
                            context.fill(CGRect(x: x1+1, y: y1+1, width: cellSize, height: cellSize))
                        }
                    }
                    else {
                        // Draw a box to eliminate the alpha location.
                        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        if showGrid {
                            context.fill(CGRect(x: x1+1, y: y1+1, width: cellSize-1, height: cellSize-1))
                        }
                        else {
                            context.fill(CGRect(x: x1+1, y: y1+1, width: cellSize, height: cellSize))
                        }
                    }
                    
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
                return false
            })
            
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
            
            // fill in each cell
            maze.eachCell({ (cell) in
                if let cell = cell as? PolarCell {
                    if cell.row > 0 {
                        let theta = 2 * Double.pi / Double(maze.grid[cell.row].count)
                        let innerRadius = Double(cell.row*cellSize)
                        let outerRadius = Double((cell.row+1)*cellSize)
                        let thetaCCW = Double(cell.column) * theta
                        let thetaCW = Double((cell.column+1)) * theta
                        
                        let ax = Int(Double(center)  + (innerRadius * cos(thetaCCW)))
                        let ay = Int(Double(center) + (innerRadius * sin(thetaCCW)))
                        let bx = Int(Double(center)  + (outerRadius * cos(thetaCCW)))
                        let by = Int(Double(center) + (outerRadius * sin(thetaCCW)))
                        let cx = Int(Double(center)  + (innerRadius * cos(thetaCW)))
                        let cy = Int(Double(center) + (innerRadius * sin(thetaCW)))
                        let dx = Int(Double(center)  + (outerRadius * cos(thetaCW)))
                        let dy = Int(Double(center) + (outerRadius * sin(thetaCW)))
                        
                        //                    if maze.background() {
                        //                        let red, green, blue: CGFloat
                        //                        (red, green, blue) = maze.backgroundColor(for: cell)
                        //                        context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
                        //
                        //                        context.move(to: CGPoint(x: ax, y: ay))
                        //                        context.addLine(to: CGPoint(x: bx, y: by))
                        //
                        //                        context.addLine(to: CGPoint(x: dx, y: dy))
                        //                        context.addLine(to: CGPoint(x: cx, y: cy))
                        //                        context.addLine(to: CGPoint(x: ax, y: ay))
                        //                        context.closePath()
                        //                        context.fillPath()
                        //                    }
                        //                    else {
                        //                        // Draw a box to eliminate the alpha location.
                        //                        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        //                        context.move(to: CGPoint(x: ax, y: ay))
                        //                        context.addLine(to: CGPoint(x: bx, y: by))
                        //                        //context.addArc(tangent1End: CGPoint(x: bx, y: by), tangent2End: CGPoint(x: dx, y: dy), radius: CGFloat(outerRadius))
                        //                        context.addLine(to: CGPoint(x: dx, y: dy))
                        //                        context.addLine(to: CGPoint(x: cx, y: cy))
                        //                        context.addLine(to: CGPoint(x: ax, y: ay))
                        //                        //context.addArc(tangent1End: CGPoint(x: cx, y: cy), tangent2End: CGPoint(x: ax, y: ay), radius: CGFloat(innerRadius))
                        //                        context.closePath()
                        //                        context.fillPath()
                        //                    }
                        
                        context.setLineWidth(2.0)
                        context.setFillColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                        
                        //                    // Draw the lines we need...
                        //                    context.move(to: CGPoint(x: ax, y: ay))
                        //                    context.addLine(to: CGPoint(x: bx, y: by))
                        //                    context.drawPath(using: .stroke)
                        //
                        //                    context.move(to: CGPoint(x: cx, y: cy))
                        //                    context.addLine(to: CGPoint(x: dx, y: dy))
                        //                    context.drawPath(using: .stroke)
                        
//                        func unless(_ condition: ()->Bool ) -> Bool {
//                            return !condition()
//                        }
                        
                        if let inward = cell.inward {
                            if !cell.linked(inward) {
                                context.move(to: CGPoint(x: ax, y: ay))
                                context.addLine(to: CGPoint(x: cx, y: cy))
                                context.drawPath(using: .stroke)

//                                context.addArc(center: centerPoint, radius: CGFloat(innerRadius), startAngle: CGFloat(thetaCW), endAngle: CGFloat(thetaCCW), clockwise: false)
//                                context.drawPath(using: .stroke)
//                                context.addArc(center: centerPoint, radius: CGFloat(outerRadius), startAngle: CGFloat(thetaCW), endAngle: CGFloat(thetaCCW), clockwise: false)
//                                context.drawPath(using: .stroke)
                            }
                        }

                        if let cw = cell.cw {
                            if !cell.linked(cw) {
                                context.move(to: CGPoint(x: cx, y: cy))
                                context.addLine(to: CGPoint(x: dx, y: dy))
                                context.drawPath(using: .stroke)
                            }
                        }
                        else {
                            context.move(to: CGPoint(x: cx, y: cy))
                            context.addLine(to: CGPoint(x: dx, y: dy))
                            context.drawPath(using: .stroke)
                        }

                    }
                    
                }
                
                return false
            })
            
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
                if let data = bitmap.representation(using: .PNG, properties: [:]) {
                    try? data.write(to: url)
                    print( url )
                }
            }
        #endif
        //        if let bits = imageRep.representations.first as? NSBitmapImageRep {
        //            if let data = bits.representation(using: .png, properties: [:]) {
        //                try? data.write(to: URL(fileURLWithPath: "./maze.png"))
        //            }
        //        }
    }
}

