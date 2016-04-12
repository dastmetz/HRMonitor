//
//  ViewController.swift
//  Running
//
//  Created by Daniel Steinmetz on 21.03.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit

protocol GraphDrawingDelegate{
    func updateLabel(value: String)
    func drawGraph(point: HRDataPoint)
}

class ViewController: UIViewController, GraphDrawingDelegate{

    @IBOutlet var heartRateLabel: UILabel!
    @IBOutlet var graphView: HRGraphView!
    
    
    var manager: ConnectionManager?
    var dataGenerator: DummyDataGenerator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PlatformValidator.isSimulator {
            dataGenerator = DummyDataGenerator(delegate: self, timeDummy: 0)
            var _ = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "accessGeneratorViaTimer", userInfo: nil, repeats: true)
        } else {
            manager = ConnectionManager(delegate: self)
            let services = [Constants.HR_ServiceID, Constants.deviceInfo_ServiceID]
        }
    }

    func accessGeneratorViaTimer(){
        dataGenerator?.addPoint()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabel(value: String) {
        heartRateLabel.text = value
    }
    
    
    func drawGraph(point: HRDataPoint) {
        HRStorage.sharedInstance.addEntry(point)
        graphView.updateGraph()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview?.convertPoint(CGPointZero, fromView: self.view)
    }

}

