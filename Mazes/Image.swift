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
    
    public static func cgImage(for maze: Grid, cellSize: Int, solution: Bool = false ) -> CGImage? {
        
        var result : CGImage? = nil
        
        let imageWidth = cellSize * maze.columns
        let imageHeight = cellSize * maze.rows
        
        // Create a bitmap graphics context of the given size
        //
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let context = CGContext(data: nil, width: Int(imageWidth /** imageScale*/)+1, height: Int(imageHeight /** imageScale*/)+1, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue ) {
            
            // Draw ...
            // the background color...
            context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            //context.addRect( CGRect(x: 0, y: 0, width: width, height: height) )
            context.fill(CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
            
            // Flip the drawing coordinates so I can draw this top to bottom as it is in the ascii maze...
            context.saveGState()
            context.translateBy(x: 0, y: CGFloat(imageHeight))
            context.scaleBy(x: 1.0, y: -1.0)
            
            // fill in each cell
            maze.eachCell({ (cell) in
                let x1 = cell.column * cellSize
                let y1 = cell.row * cellSize
                let x2 = (cell.column+1)*cellSize
                let y2 = (cell.row+1)*cellSize
                
                if grid.background() {
                    let red, green, blue: CGFloat
                    (red, green, blue) = grid.backgroundColor(for: cell)
                    context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
                    //context.addRect( CGRect(x: 0, y: 0, width: width, height: height) )
                    context.fill(CGRect(x: x1, y: y1, width: x2-x1, height: y2-y1))
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

