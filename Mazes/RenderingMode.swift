//
//  MazeRenderingMode.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

#if swift(>=4.2)
public enum MazeRenderingMode : String, CaseIterable {
    case backgrounds
    case walls
}
#else
public enum MazeRenderingMode : String {
    case backgrounds
    case walls
}
#endif

extension MazeRenderingMode {
    #if swift(>=4.2)
    #else
    static var allCases : [MazeRenderingMode]  {
        get {
            return [.backgrounds, .walls]
        }
    }
    #endif
}
