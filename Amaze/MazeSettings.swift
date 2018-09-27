//
//  MazeSettings.swift
//  Amaze
//
//  Created by Scott Tury on 9/25/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation
import MazeKit

public struct MazeSettings : Equatable, Codable {
    
    public var useColor : Bool
    public var color : String
    public var rows : Int
    public var cols : Int
    public var showSolution : Bool
    public var braided : Bool
    
    /// Method to translate the underlying String into a ColoredGridMode value.
    func colorMode() -> ColoredGridMode {
        var result : ColoredGridMode = .green
        if let mode = ColoredGridMode(rawValue: color) {
            result = mode
        }
        return result
    }
    
    init() {
        useColor = true
        color = "green"
        rows = 20
        cols = 20
        showSolution = false
        braided = false
    }
    
    // MARK:  Equatable
    static public func == (lhs: MazeSettings, rhs: MazeSettings) -> Bool {
        var result = false
        
        if  lhs.color == rhs.color &&
            lhs.rows == rhs.rows &&
            lhs.cols == rhs.cols &&
            lhs.braided == rhs.braided &&
            lhs.useColor == rhs.useColor &&
            lhs.showSolution == rhs.showSolution {
            result = true
        }
        
        return result
    }
}

