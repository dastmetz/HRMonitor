//
//  Constants.swift
//  Running
//
//  Created by Daniel Steinmetz on 21.03.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit
import CoreBluetooth

struct Constants {
    
    // Bluetooth Services
    static let HR_ServiceID = CBUUID(string: "180D") // heart rate service
    static let deviceInfo_ServiceID = CBUUID(string:"180A")
    
    // Bluetooth Characteristics
    static let HR_MeasurementID = CBUUID(string:"2A37")
    static let HR_ProducerID = CBUUID(string:"2A29")
    static let HR_LocationID = CBUUID(string: "2A38")
    
    // HR Constans
    static let HR_Range = CGFloat(120)
    
}