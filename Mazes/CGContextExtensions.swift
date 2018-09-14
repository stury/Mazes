//
//  CGContextExtensions.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public extension CGContext {
    
    public func drawPolygon( points: [(Int, Int)], fill: Bool = true, stroke: Bool = true ) {
        
        if points.count > 0 {
            for (index, point) in points.enumerated() {
                if index == 0 {
                    move(to: CGPoint(x:point.0, y:point.1))
                }
                else {
                    addLine(to: CGPoint(x:point.0, y:point.1))
                }
            }
            addLine(to: CGPoint(x:points[0].0, y:points[0].1))
            
            if fill {
                fillPath()
            }
            if stroke {
                strokePath()
            }
        }
    }
    
    public func drawLineSegment( points: [(Int, Int)] ) {
        
        if points.count == 2 {
            move(to: CGPoint(x:points[0].0, y:points[0].1))
            addLine(to: CGPoint(x:points[1].0, y:points[1].1))
            strokePath()
        }
    }
    
}