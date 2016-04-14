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
    func updateProducerLabel(value: String)
    func drawGraph(point: HRDataPoint)
}

class ViewController: UIViewController, GraphDrawingDelegate{

    @IBOutlet var heartRateLabel: UILabel!
    @IBOutlet var graphView: HRGraphView!
    @IBOutlet var monitorLabel: UILabel!
    
    var manager: ConnectionManager?
    var dataGenerator: DummyDataGenerator?
    var blurView: UIVisualEffectView?
    
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
    
    override func viewWillAppear(animated: Bool) {
        setupBlur()
    }
    
    
    // blur graph view in demo mode
    private func setupBlur(){
        let blurEffect = UIBlurEffect(style: .Dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView!.frame = graphView.bounds
        blurView!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        blurView!.alpha = 0.6
        
        self.graphView.addSubview(blurView!)
        blurView!.center = graphView.convertPoint(graphView.center, fromView: graphView.superview)
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
    
    func updateProducerLabel(value: String) {
        monitorLabel.text = value
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

