//
//  HRGraphView.swift
//  Running
//
//  Created by Daniel Steinmetz on 24.03.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit


class HRGraphView: UIView {
    
    private let backgroundLayer = CAGradientLayer()
    private var graphLine: HRGraphLine!

    var maxVal: CGFloat = 200.0{
        didSet{
            self.graphLine.maxVal = maxVal
        }
    }
    var minVal: CGFloat = 0.0{
        didSet{
            self.graphLine.maxVal = maxVal
        }
    }
    
    // MARK:- Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGraphView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGraphView()
    }
    
    private func setupGraphView(){
        self.backgroundColor = UIColor.clearColor()
        backgroundLayer.colors = [UIColor(red: 255.0/255.0, green: 148.0/255.0, blue:  86.0/255.0, alpha: 1.0).CGColor,UIColor(red: 253.0/255.0, green:  58.0/255.0, blue:  52.0/255.0, alpha: 1.0).CGColor]
        backgroundLayer.cornerRadius = CGFloat(5.0)
        backgroundLayer.frame = layer.bounds
        self.layer.addSublayer(backgroundLayer)

        graphLine = HRGraphLine(frame: bounds)
        graphLine.layer.cornerRadius = CGFloat(0.0)
        graphLine.maxVal = maxVal
        graphLine.minVal = minVal
        addSubview(graphLine)
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        backgroundLayer.frame = self.layer.bounds
        graphLine.frame = self.layer.frame
        backgroundLayer.setNeedsDisplay()
        graphLine.setNeedsDisplay()
        backgroundLayer.removeAllAnimations()
        graphLine.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    func updateGraph(){
        graphLine.setNeedsDisplay()
    }
    
}