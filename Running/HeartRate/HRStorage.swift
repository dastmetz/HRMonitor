//
//  HeartRateStore.swift
//  Running
//
//  Created by Daniel Steinmetz on 24.03.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation


struct HRStorage{
    
    static var sharedInstance = HRStorage()
    
    var store = [HRDataPoint(x: 0, y: 0)]
    
    mutating func addEntry(data: HRDataPoint){
        store.append(data)
    }
    
    func getDataPoints()-> [HRDataPoint]{
        return store
    }
    
    
    
}