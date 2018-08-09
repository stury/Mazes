//
//  Mask.swift
//  Mazes
//
//  Created by J. Scott Tury on 8/7/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class Mask {
    public let rows, columns : Int
    var bits : [[Bool]]
    
    public init( rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        
        let row = [Bool].init(repeating: true, count: columns)
        self.bits = [[Bool]].init(repeating: row, count: rows)
    }

    public subscript(_ location: [Int]) -> Bool? {
        get {
            var result : Bool? = nil
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
            if let newValue = newValue, location.count == 2 {
                let point = Point(row: location[0], col: location[1])
                if point.row >= 0 && point.row < rows &&
                    point.col >= 0 && point.col < columns {
                    bits[point.row][point.col] = newValue
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
