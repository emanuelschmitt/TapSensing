//
//  GridViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 18.05.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit
import CoreMotion
import Foundation

class GridViewController: UIViewController {
    
    // MARK: - Variables
    var sessionButtons = [UIButton]()
    var clickedButtons = [UIButton]()
    var activeButton: UIButton?
    
    var motionController = MotionController()
    var touchEventController = TouchEventController()
    var gridShape: String?
    
    // MARK: - Experiment Variables
    
    // These are the sizes that have to be played.
    var rectSizes = [120]
    var rectSize: Int = 0
    
    // This is the amount of times a grid size has to be played
    // Once all buttons are clicked, the grid will refresh and the size has to be played again.
    let numRepeatsPerGrid = 14
    var gridPlayedCount = 0
    
    // MARK: -- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTrail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Helper
    
    private func createButton(xPos: Double, yPos: Double, tag: Int) -> UIButton {
        let button = UIButton(frame: CGRect(x: xPos, y: yPos, width: Double(rectSize), height: Double(rectSize)))
        button.backgroundColor = .yellow
        
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        // forward touch events to underlying layer
        button.isUserInteractionEnabled = false
        
        button.tag = tag
        
        return button
    }
    
    private func setupGrid() {
        let screenWidth = Float(self.view!.bounds.width)
        let screenHeight = Float(self.view!.bounds.height)
        
        let rectAmountHorizontal = floor(screenWidth / Float(rectSize))
        let whiteSpaceHorizontal = screenWidth.truncatingRemainder(dividingBy: Float(rectSize))
        let paddingHorizontal = whiteSpaceHorizontal / Float((rectAmountHorizontal + 1))
        
        let rectAmountVertical = floor(screenHeight / Float(rectSize))
        let whiteSpaceVertical = screenHeight.truncatingRemainder(dividingBy: Float(rectSize))
        let paddingVertical = Float(whiteSpaceVertical) / Float((rectAmountVertical + 1))
        
        for v in (0..<Int(rectAmountVertical)){
            for h in (0..<Int(rectAmountHorizontal)){
                
                let x = paddingHorizontal + Float(h * (rectSize + Int(paddingHorizontal)))
                let y = paddingVertical + Float(v * (rectSize + Int(paddingVertical)))
                
                // create Id for Button
                let stringId = String(v + 1) + String(h + 1)
                let intId = Int(stringId)
                
                print("Button X: \(x), Y: \(y)")
                let button = createButton(xPos: Double(x), yPos: Double(y), tag: intId!)
                
                sessionButtons.append(button)
                self.view.addSubview(button)
            }
        }
        
        // Set gridshape for tracking
        self.gridShape = "(\( Int(rectAmountVertical) ), \( Int(rectAmountHorizontal) ))"
        print(self.gridShape!)
    }
    
    private func startTrail() {
        motionController.startSensorRecording()
    
        if (self.rectSizes.isEmpty) {
            print ("No sizes set.")
            self.endTrial()
            return;
        }
        
        self.rectSize = self.rectSizes.popLast()!
        initializeTrial()
    }
    
    private func initializeTrial() {
        if self.gridPlayedCount >= self.numRepeatsPerGrid {
            
            // check if all grid sizes where played.
            if self.rectSizes.isEmpty {
                self.endTrial()
                return;
            }
            
            // set next grid size
            self.rectSize = self.rectSizes.popLast()!
        }
        
        // Remove all button from View.
        let _ = self.clickedButtons.map {$0.removeFromSuperview()}
        self.setupGrid()
        self.selectNextActiveButton()
        
        self.gridPlayedCount += 1
    }
    
    private func selectNextActiveButton() {
        if let activeButton = self.activeButton {
            clickedButtons.append(activeButton)
        }
        
        if sessionButtons.isEmpty {
            initializeTrial()
            return;
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(sessionButtons.count)))
        activeButton = sessionButtons.remove(at: randomIndex)
        activeButton?.backgroundColor = UIColor.green
    }
    
    private func endTrial() {
        motionController.stopSensorRecordings()
        
        motionController.persistSensorRecordings()
        touchEventController.persistTouchEvents()
        
        if let parent = self.parent as? SessionViewController {
            parent.goToNextPage()
        }
    }

    
    // MARK: -- Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches, type: "TOUCH_DOWN")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches, type: "TOUCH_UP")
    }
    
    fileprivate func handleTouches(_ touches: Set<UITouch>, type: String) {
        for touch in touches {
            let point = touch.location(in: self.view)
            let isHit = (activeButton?.frame.contains(point)) ?? false
            
            touchEventController.addTouchEvent(
                x: Double(point.x),
                y: Double(point.y),
                type: type,
                gridID: isHit ? (activeButton?.tag)! : -1,
                isHit: isHit,
                gridShape: self.gridShape!
            )
            
            if (isHit && type == "TOUCH_UP") {
                activeButton?.backgroundColor = UIColor.red
                selectNextActiveButton()
            }
        }
    }
    
}
