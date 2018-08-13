//
//  ColoredGrid.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/25/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

#if swift(>=4.2)
public enum ColoredGridMode : String, CaseIterable {
    case red
    case green
    case blue
    case yellow
    case cyan
    case magenta
    case gray
}
#else
public enum ColoredGridMode : String {
    case red
    case green
    case blue
    case yellow
    case cyan
    case magenta
    case gray
}
#endif

extension ColoredGridMode {
    //static var allCases: Self.AllCases
    #if swift(>=4.2)
    #else
    static var allCases : [ColoredGridMode]  {
        get {
            return [.red, .green, .blue, .yellow, .cyan, .magenta, .gray]
        }
    }
    #endif
}


public class ColoredGrid : Grid {
    var mode : ColoredGridMode = .green
    var maximum : Int = 0
    var distances : Distances? {
        didSet {
            if let distances = distances {
                (_, distance: maximum) = distances.max()
            }
        }
    }
    
    // protocol for Image callback to grid to see if we want to color the backgrounds.
    override public func background( ) -> Bool {
        return true
    }
    
    // protocol for Image callback to grid for the background color
    override public func backgroundColor( for cell: Cell ) -> (CGFloat, CGFloat, CGFloat) {
        var result = (CGFloat(1.0), CGFloat(1.0), CGFloat(1.0))
        if let distances = distances {
            if let distance = distances[cell] {
                let intensity = CGFloat(maximum - distance)/CGFloat(maximum)
                let dark = CGFloat(1.0 * intensity)
                let bright = CGFloat(0.5 + (0.5*intensity))
                switch mode {
                case .red:
                    result = (bright, dark, dark)
                case .green:
                    result = (dark, bright, dark)
                case .blue:
                    result = (dark, dark, bright)
                case .yellow:
                    result = (bright, bright, dark)
                case .cyan:
                    result = (dark, bright, bright)
                case .magenta:
                    result = (bright, dark, bright)
                case .gray:
                    result = (bright, bright, bright)
                }
            }
        }
        return result
    }

}
