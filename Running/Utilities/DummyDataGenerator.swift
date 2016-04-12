//
//  DummyDataGenerator.swift
//  Running
//
//  Created by Daniel Steinmetz on 31.03.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation


struct DummyDataGenerator{
    
    var delegate: GraphDrawingDelegate
    var timeDummy = 0
    
    mutating func addPoint(){
        let point = HRDataPoint(x: Int((arc4random_uniform(120) + 40)), y: timeDummy)
        delegate.drawGraph(point)
        delegate.updateLabel(String(point.HR_value))
        timeDummy += 2
    }
}
