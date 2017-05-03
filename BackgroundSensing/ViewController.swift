//
//  ViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 18/04/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit
import CoreMotion
import Alamofire

class ViewController: UIViewController {

    var gyroTimer = Timer()
    var funcTimer = Timer()
    
    var backgroundTask = BackgroundTask()
    var queue = Queue<CMGyroData>()
    var counter = 0
    let motionManager = CMMotionManager()
    
    
    @IBOutlet weak var startTaskButton: UIButton!
    @IBOutlet weak var stopTaskButton: UIButton!
    
    
    @IBAction func startBackgroundTask(sender: AnyObject) {
        backgroundTask.startBackgroundTask()
        
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
        
        gyroTimer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(self.update),
            userInfo: nil,
            repeats: true
        )
        
        funcTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.timerAction),
            userInfo: nil,
            repeats: true
        )
        
        startTaskButton.alpha = 0.5
        startTaskButton.isUserInteractionEnabled = false
        
        stopTaskButton.alpha = 1
        stopTaskButton.isUserInteractionEnabled = true
    }
    
    @IBAction func stopBackgroundTask(sender: AnyObject) {
        startTaskButton.alpha = 1
        startTaskButton.isUserInteractionEnabled = true
        stopTaskButton.alpha = 0.5
        stopTaskButton.isUserInteractionEnabled = false
        
        funcTimer.invalidate()
        gyroTimer.invalidate()
        
        backgroundTask.stopBackgroundTask()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func timerAction() {
        // print("SomeCoolTaskRunning..... \(counter)")
        counter += 1
    }
    
    func update() {
//        if let accelerometerData = motionManager.accelerometerData {
//            print(accelerometerData)
//        }
        if let gyroData = motionManager.gyroData {
            
            let data = GyroData(
                x: gyroData.rotationRate.x,
                y: gyroData.rotationRate.y,
                z: gyroData.rotationRate.z,
                timestamp: String(gyroData.timestamp)
            )
            
            self.queue.enqueue(gyroData)
            
            var request = URLRequest(url: URL(string: "http://52.29.70.27:8000/gyro")!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var payload = data.toJSON()
            print(String(data: payload!, encoding: String.Encoding.utf8))

            request.httpBody = payload
            

            Alamofire.request(request)
                .responseJSON { response in
                    // do whatever you want here
                    switch response.result {
                    case .failure(let error):
                        print(error)
                        
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            print(responseString)
                        }
                    case .success(let responseObject):
                        print(responseObject)
                    }
            }

            if (queue.count > 1000) {
                print(gyroData.timestamp)
                print(gyroData.rotationRate.x)
                print(gyroData.rotationRate.y)
                print(gyroData.rotationRate.z)
            }
            
        }
        
//        if let magnetometerData = motionManager.magnetometerData {
//            print(magnetometerData)
//        }
//        if let deviceMotion = motionManager.deviceMotion {
//            print(deviceMotion)
//        }
    }
    
    func doRequest() {
        
    }
}

