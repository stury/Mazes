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

    /// human readable algorithm to use when generating the maze.
    public var algorithm : String

    // Setting to say if a type of maze supports a designated Column variable
    public var supportColumns: Bool

    public var cellSize : Int
    public var strokeSize : Int
    
    /// Method to translate the underlying String into a ColoredGridMode value.
    func colorMode() -> ColoredGridMode {
        var result : ColoredGridMode = .green
        if let mode = ColoredGridMode(rawValue: color) {
            result = mode
        }
        return result
    }
    
    func algorithmMaze() -> Mazes {
        var result : Mazes = .recursiveBacktracker
        if let mode = Mazes(rawValue: algorithm) {
            result = mode
        }
        return result
    }
    
    init() {
        useColor = true
        color = ColoredGridMode.green.rawValue
        rows = 20
        cols = 20
        showSolution = false
        braided = false
        algorithm = Mazes.recursiveBacktracker.rawValue
        supportColumns = true
        cellSize = 40
        strokeSize = 2
    }
    
    mutating public func update( with helper: MazeHelper ) {
        supportColumns  = helper.supportsColumns
        cellSize        = helper.cellSize
        strokeSize      = helper.strokeSize
    }
    
//    convenience init(_ helper: MazeHelper) {
//        self.init()
//        color = helper.
//    }
    
    // MARK:  Equatable
    static public func == (lhs: MazeSettings, rhs: MazeSettings) -> Bool {
        var result = false
        
        if  lhs.color == rhs.color &&
            lhs.rows == rhs.rows &&
            lhs.cols == rhs.cols &&
            lhs.braided == rhs.braided &&
            lhs.useColor == rhs.useColor &&
            lhs.showSolution == rhs.showSolution &&
            lhs.algorithm == rhs.algorithm &&
            lhs.cellSize == rhs.cellSize &&
            lhs.strokeSize ==  rhs.strokeSize {
            result = true
        }
        
        return result
    }
}

