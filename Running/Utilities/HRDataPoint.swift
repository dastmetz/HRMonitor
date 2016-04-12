//
//  HRDataPoint.swift
//  Running
//
//  Created by Daniel Steinmetz on 24.03.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation


struct HRDataPoint{

    var seconds: Int
    var HR_value: Int
    
    init(x: Int, y: Int){
        HR_value = x
        seconds = y
    }

}