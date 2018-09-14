//
//  RenderingMode.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

#if swift(>=4.2)
public enum RenderingMode : String, CaseIterable {
    case backgrounds
    case walls
}
#else
public enum RenderingMode : String {
    case backgrounds
    case walls
}
#endif

extension RenderingMode {
    #if swift(>=4.2)
    #else
    static var allCases : [RenderingMode]  {
        get {
            return [.backgrounds, .walls]
        }
    }
    #endif
}
