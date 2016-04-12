//
//  ConnectionManager.swift
//  Running
//
//  Created by Daniel Steinmetz on 21.03.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation
import CoreBluetooth


class ConnectionManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let services = [Constants.HR_ServiceID, Constants.deviceInfo_ServiceID]
    
    var centralManager: CBCentralManager?
    var heartRateMonitor: CBPeripheral?
    
    var connectionStatus: CBPeripheralState?
    
    var delegate: GraphDrawingDelegate
    
    var timerDummy: Int = 0 // TODO: record duration
    
    init(delegate: GraphDrawingDelegate){
        self.delegate = delegate
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
    }
    
    
    // MARK: CBCentralManagerDelegate
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        connectionStatus = CBPeripheralState.Connected
        print(connectionStatus)
        
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        connectionStatus = CBPeripheralState.Disconnected
        print(" \(connectionStatus) - Connection failed")
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String{
            if name.characters.count > 0 {
                print("Found monitor \(name)")
                self.centralManager!.stopScan()
                self.heartRateMonitor = peripheral
                peripheral.delegate = self
                self.centralManager!.connectPeripheral(peripheral, options: nil)
            }
        }
        
        
    }

    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state{
        case .PoweredOn:
            print("Powered on")
            let test = centralManager!.scanForPeripheralsWithServices(services, options: nil)
            print(test)
        case .PoweredOff:
            print("Powered off")
        case .Resetting:
            print("Resetting")
        case .Unauthorized:
            print("Unauthorized")
        case .Unsupported:
            print("Unsupported")
        case .Unknown:
            print("Unknown")
        }
    }
    
    
    // MARK: CBPeripheralDelegate
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        guard peripheral.services != nil else { return}
        for service in peripheral.services!{
            print("Discovered service \(service.UUID)")
            peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if service.UUID == Constants.HR_ServiceID{
            for characteristic in service.characteristics!{
                if characteristic.UUID == Constants.HR_MeasurementID{
                    
                    print("Heart rate measurement characteristic found")
                    heartRateMonitor?.setNotifyValue(true, forCharacteristic: characteristic)
                    
                } else if characteristic.UUID == Constants.HR_LocationID{
                    
                    print("location characteristic found")
                    heartRateMonitor?.readValueForCharacteristic(characteristic)
                    
                }
            }
        }
        
        if service.UUID == Constants.deviceInfo_ServiceID{
            for characteristic in service.characteristics!{
                if characteristic.UUID == Constants.HR_ProducerID{
                
                    print("producer characteristic found")
                    heartRateMonitor?.readValueForCharacteristic(characteristic)
                    
                }
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        if characteristic.UUID == Constants.HR_MeasurementID{
            getBPMData(characteristic, error: error)
        }
        
        if characteristic.UUID == Constants.HR_LocationID{
            getBodyLocation(characteristic)
        }
        
    }
    
    // MARK: Characteristics Helper
    
    func getBPMData(characteristic: CBCharacteristic, error: NSError?){
        
        if let dataBytes = characteristic.value {
            var buffer = [UInt8](count: dataBytes.length, repeatedValue: 0x00)
            dataBytes.getBytes(&buffer, length: buffer.count)
            
            var bpm: UInt16?
            if buffer.count >= 2 {
                if (buffer[0] & 0x01 == 0){
                    bpm = UInt16(buffer[1]);
                }else {
                    bpm = UInt16(buffer[1]) << 8
                    bpm =  bpm! | UInt16(buffer[2])
                }
            }
            if let bpm = bpm {
                delegate.updateLabel(String(bpm))
                let val = Int(bpm)
                let point = HRDataPoint(x: val, y: timerDummy)
                delegate.drawGraph(point)
            }
            timerDummy += 2
        }
    }
        
    
    func getProducerName(characteristic: CBCharacteristic){
        let name = String(data: characteristic.value!, encoding: NSUTF8StringEncoding)
        print(name)
    }
    
    func getBodyLocation(characteristic: CBCharacteristic){
        if let locationBytes = characteristic.value{
            var buffer = [UInt8](count: locationBytes.length, repeatedValue: 0x00)
            locationBytes.getBytes(&buffer, length: buffer.count)
            
            let location = buffer[0]
            if location == UInt8(1){
                print("chest")
            } else {
                print("wrong")
            }
        }
    }

}



