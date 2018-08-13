//
//  Mask.swift
//  Mazes
//
//  Created by J. Scott Tury on 8/7/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation
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

    public subscript(_ location: [Int]) -> Bool {
        get {
            var result : Bool = false
            if location.count == 2 {
                let point = Point(row: location[0], col: location[1])
                if point.row >= 0 && point.row < rows &&
                    point.col >= 0 && point.col < columns {
                    result = bits[point.row][point.col]
                }
            }
            return result
        }
        set (newValue) {
            if location.count == 2 {
                let row = location[0]
                let col = location[1]
                if row >= 0 && row < rows &&
                    col >= 0 && col < columns {
                    bits[row][col] = newValue
                }
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
                    mask[[row, col]] = false
                }
                // Should not need the following lines, since by default all cells should be available.
//                else {
//                    mask[[row, col]] = true
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
    
    private static func cgImage( _ image: Image ) -> CGImage? {
        #if os(macOS)
            let result = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
        #else
            let result = image.cgImage
        #endif
        return result
    }
    
    public static func from(_ image: Image ) -> Mask {

        let rows = Int(image.size.height)
        let columns = Int(image.size.width)
        
        let mask : Mask = Mask(rows: rows, columns: columns)
        
        // Calculate the mask based onthe image
        if let cgImage = Mask.cgImage(image) {

            for row in 0..<rows {
                for col in 0..<columns {
                    // Get a pixel from the Image and see if it's black or alpha'd out of the image.
                    // If so, delete it!
                    #if os(macOS)
                        let bitmap = NSBitmapImageRep(cgImage: cgImage)
                        if let color = bitmap.colorAt(x: col, y: row) {
                            if color == NSColor.black || color == NSColor(calibratedRed: 0, green: 0, blue:0, alpha: 1) {
                                mask[[row, col]] = false
                            }
                        }
                    #endif
                    
                }
            }
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
