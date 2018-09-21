//
//  Mask.swift
//  Mazes
//
//  Created by J. Scott Tury on 8/7/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(macOS)
    import AppKit
#endif

public class Mask {
    public let rows, columns : Int
    var bits : [[Bool]]
    
    public init( rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        
        let row = [Bool].init(repeating: true, count: columns)
        self.bits = [[Bool]].init(repeating: row, count: rows)
    }

    public subscript(_ location: (Int, Int)) -> Bool {
        get {
            var result : Bool = false
            if location.0 >= 0 && location.0 < rows &&
                location.1 >= 0 && location.1 < columns {
                result = bits[location.0][location.1]
            }
            return result
        }
        set (newValue) {
            let row = location.0
            let col = location.1
            if row >= 0 && row < rows &&
                col >= 0 && col < columns {
                bits[row][col] = newValue
            }
        }
    }

    var count : Int {
        get {
            var count = 0
            for row in bits {
                for col in row {
                    if col {
                        count += 1
                    }
                }
            }
            return count
        }
    }
    
    public func randomLocation() -> [Int] {
        while true {
            let row = random(rows)
            let col = random(columns)
            if bits[row][col] {
                return [row, col]
            }
        }
    }
    
}

public extension Mask {
    
    public static func from(_ text: String ) -> Mask {
        // First trim extra whitespace and line feeds form the string.
        let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var lines = trimmed.components(separatedBy: CharacterSet.newlines)
        
        let rows = lines.count
        // Need to trim whitespace from each line, in case someone accidentally added extra whitespace.
        #if swift(>=3.2)
            let columns = lines[0].trimmingCharacters(in: CharacterSet.whitespaces).count
        #else
            let columns = lines[0].trimmingCharacters(in: CharacterSet.whitespaces).characters.count
        #endif
        
        let mask : Mask = Mask(rows: rows, columns: columns)
        
        for (row, line) in lines.enumerated() {
            let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespaces)
            #if swift(>=3.2)
            for (col, char) in trimmedLine.enumerated() {
                if char == "X" || char == "x" {
                    mask[(row, col)] = false
                }
                // Should not need the following lines, since by default all cells should be available.
//                else {
//                    mask[(row, col)] = true
//                }
            }
            #else
                for (col, char) in trimmedLine.characters.enumerated() {
                    if char == "X" || char == "x" {
                        mask[[row, col]] = false
                    }
                }
            #endif
        }

        return mask
    }
    
    /// Simple method to fetch the cgImage from a Image.  NOTE: It may fail if you have a non bitmap representation.
    private static func cgImage( _ image: Image ) -> CGImage? {
        #if os(macOS)
            let result = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
        #else
            let result = image.cgImage
        #endif
        return result
    }

    /// This method copies the current image to a new CGImage in the format we're expecting.
    private static func cgImage32BitRGBA( _ image: Image ) -> CGImage? {
        var result : CGImage? = nil
        
        if let inputCGImage = Mask.cgImage(image) {
            let width  = inputCGImage.width
            let height = inputCGImage.height
            
            let bytesPerPixel = 4
            let bytesPerRow = bytesPerPixel*width
            let bitsPerComponent = 8
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            if let context = CGContext.init(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue |  CGBitmapInfo.byteOrder32Big.rawValue) {

                context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
                
                result = context.makeImage()
            }
        }
        
        return result
    }
    
    public static func from(_ image: Image ) -> Mask {

        let rows = Int(image.size.height)
        let columns = Int(image.size.width)
        
        let mask : Mask = Mask(rows: rows, columns: columns)
        
        // Calculate the mask based onthe image
        if let cgImage = Mask.cgImage32BitRGBA(image) {
            
            // Generic case:  Use the cgImage to get a dataProvider, so we can have access to teh raw data.
            // NOTE: that we will need to pay attention to the cgImage.bitmapInfo for the bytesPerRow!
            if let imageDataProvider = cgImage.dataProvider,
                let data = imageDataProvider.data {
                if let rawData = CFDataGetBytePtr(data) {
                    let bytesPerRow = cgImage.bytesPerRow
                    
                    for row in 0..<rows {
                        let rowBytesOffset = row*bytesPerRow
                        for col in 0..<columns {
                            // Get the pixel components from the Image data
                            let red   = rawData[rowBytesOffset+(col*4)]
                            let green = rawData[rowBytesOffset+(col*4+1)]
                            let blue  = rawData[rowBytesOffset+(col*4+2)]
                            let alpha = rawData[rowBytesOffset+(col*4+3)]
                            
                            // If the pixel is black, or alpha'd out of the image - delete it!
                            if (red == 0 && green == 0 && blue == 0) || (alpha == 0) {
                                mask[(row, col)] = false
                            }
                        }
                    }
                }
            }

//            // This was so much simpler on macOS, since there is the NSBitmapImageRep class!
//            for row in 0..<rows {
//                for col in 0..<columns {
//                    // Get a pixel from the Image and see if it's black or alpha'd out of the image.
//                    // If so, delete it!
//                    #if os(macOS)
//                        let bitmap = NSBitmapImageRep(cgImage: cgImage)
//                        if let color = bitmap.colorAt(x: col, y: row) {
//                            if color == NSColor.black || color == NSColor(calibratedRed: 0, green: 0, blue:0, alpha: 1) {
//                                mask[[row, col]] = false
//                            }
//                        }
//                    #endif
//                    
//                }
//            }
        }
        
        return mask
    }
    
    public static func from(_ url: URL ) -> Mask? {
        var result : Mask? = nil

        // The more complicated way...
//        let filePath : String = url.relativeString
//        if url.isFileURL, FileManager.default.fileExists(atPath: filePath ) {
//            if let fileContent = FileManager.default.contents(atPath: filePath) {
//                if let text = String(data: fileContent, encoding: .utf8) {
//                    result = Mask.from(text)
//                }
//            }
//        }

        // Much simpler....
        if let text = try? String(contentsOf: url) {
            result = Mask.from(text)
        }
        else {
            let image = Image(contentsOf: url)
            if let image = image {
                result = Mask.from(image)
            }
        }
        return result
    }

}
