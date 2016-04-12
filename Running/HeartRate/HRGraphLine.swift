//
//  HRGraphLine.swift
//  Running
//
//  Created by Daniel Steinmetz on 11.04.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation
import UIKit


class HRGraphLine: UIView {
    var maxSamples = 200 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    var maxVal: CGFloat = 200.0{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var minVal: CGFloat = 0.0{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    
    // MARK:-Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(bounds.height)
        setupLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(bounds.height)
        setupLine()
    }
    
    private func setupLine(){
        layer.drawsAsynchronously = true
        backgroundColor = UIColor.clearColor()
        opaque = false
    }
    
    // MARK:-Drawing
    
    internal override func drawRect(rect: CGRect) {
        UIColor.whiteColor().setStroke()
        drawGraph()
    }
    
    private func drawGraph(){
        let sampleWidth = bounds.width / CGFloat(maxSamples-1)
        
        let chartOrigin = CGPoint(x: bounds.origin.x + bounds.height - 20, y: bounds.origin.y + bounds.height - 20)
        let window = bounds.width                               // TODO
        let currentProgress = CGFloat(HRStorage.sharedInstance.getDataPoints().count)/CGFloat(maxSamples)
        var xVal: CGFloat = (currentProgress-1.0) * window * (-1.0)
        
        let path = UIBezierPath()
        var firstPoint = true
        for sample in HRStorage.sharedInstance.getDataPoints(){
            let point = CGPoint(x: xVal, y: chartOrigin.y-CGFloat(sample.HR_value) )
            if firstPoint {
                path.moveToPoint(point)
            } else {
                path.addLineToPoint(point)
            }
            xVal += sampleWidth
            firstPoint = false
        }
        path.lineWidth = CGFloat(2.0)
        path.stroke()
    }
    
    
}