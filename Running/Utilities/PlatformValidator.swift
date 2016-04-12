//
//  Platform.swift
//  Running
//
//  Created by Daniel Steinmetz on 31.03.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation


struct PlatformValidator{

    static var isSimulator: Bool{
        return TARGET_OS_SIMULATOR != 0
    }
}