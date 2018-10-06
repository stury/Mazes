//
//  ColoredGrid.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/25/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation
import CoreGraphics

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
    public static var allCases : [ColoredGridMode]  {
        get {
            return [.red, .green, .blue, .yellow, .cyan, .magenta, .gray]
        }
    }
    #endif
    
    public static var rawArray : [String] {
        get {
            var result = [String]()
            
            for item in allCases {
                result.append(item.rawValue)
            }
            
            return result
        }
    }
    
    public static var loclizedRawArray : [String] {
        get {
            var result = [String]()
            
            for item in rawArray {
                result.append(NSLocalizedString(item, comment: ""))
            }
            
            return result
        }
    }

}

public protocol ColoredGrid {
    var mode : ColoredGridMode { get set}
    var maximum : Int { get set}
    var distances : Distances? {get set}
    
    func backgroundColor( for cell: Cell ) -> (CGFloat, CGFloat, CGFloat)
}

extension ColoredGrid {
    
    // protocol for Image callback to grid for the background color
    public func backgroundColor( for cell: Cell ) -> (CGFloat, CGFloat, CGFloat) {
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

public class ColoredRectGrid : DistanceGrid, ColoredGrid {
    public var mode : ColoredGridMode = .green
    public var maximum : Int = 0
    public override var distances : Distances? {
        didSet {
            if let distances = distances {
                (_, distance: maximum) = distances.max()
            }
        }
    }
}
