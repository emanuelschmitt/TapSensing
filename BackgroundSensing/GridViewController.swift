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

let activeColor = UIColor.red
let unvisitedColor = UIColor.lightGray
let visitedColor = UIColor.darkGray

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
    var rectSizes = [(2,2), (4,3), (6,4)]
    var rectSize = (0, 0)
    
    // This is the amount of times a grid size has to be played
    // Once all buttons are clicked, the grid will refresh and the size has to be played again.
    let numRepeatsPerGrid = 5
    
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
    
    private func createButton(xPos: Double, yPos: Double, width: Double, height: Double, tag: Int) -> UIButton {
        let button = UIButton(frame: CGRect(x: xPos, y: yPos, width: width, height: height))
        button.backgroundColor = unvisitedColor
        
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        // forward touch events to underlying layer
        button.isUserInteractionEnabled = false
        
        button.tag = tag
        
        return button
    }
    
    private func setupGrid() {
        let (verticalItems, horizontalItems) = self.rectSize
        
        let screenWidth = Float(self.view!.bounds.width)
        let screenHeight = Float(self.view!.bounds.height)

        let maximalRectWidth = Int(screenWidth) / horizontalItems
        let maximalRectHeight = Int(screenHeight) / verticalItems
        
        var rectSize = min(maximalRectWidth, maximalRectHeight)
        rectSize = 50
        
        let paddingHorizontal = (screenWidth - Float(horizontalItems * rectSize)) / Float(horizontalItems + 1)
        let paddingVertical = (screenHeight - Float(verticalItems * rectSize)) / Float(verticalItems + 1)
        
        for h in (0..<Int(verticalItems)){
            for v in (0..<Int(horizontalItems)){
                
                let x = paddingHorizontal + Float(v * (rectSize + Int(paddingHorizontal)))
                let y = paddingVertical + Float(h * (rectSize + Int(paddingVertical)))
                
                // create Id for Button
                let stringId = String(v + 1) + String(h + 1)
                let intId = Int(stringId)
                
                print("Button X: \(x), Y: \(y)")
                let button = createButton(
                    xPos: Double(x),
                    yPos: Double(y),
                    width: Double(rectSize),
                    height: Double(rectSize),
                    tag: intId!
                )
                
                sessionButtons.append(button)
                self.view.addSubview(button)
            }
        }
        
        // Set gridshape for tracking
        self.gridShape = "(\( Int(verticalItems) ), \( Int(horizontalItems) ))"
        print(self.gridShape!)
    }
    
    private func startTrail() {
        motionController.startSensorRecording()
    
        if (self.rectSizes.isEmpty) {
            print ("No sizes set.")
            self.endTrial()
            return;
        }
        
        let rectSizes_temp = self.rectSizes
        // Append self onto array for the amount of trails to play per gridsize
        for _ in (1..<numRepeatsPerGrid) {
            self.rectSizes = self.rectSizes + rectSizes_temp
        }
        // shuffle the result
        self.rectSizes.shuffle()
        
        initializeTrial()
    }
    
    private func initializeTrial() {
        // check if all grid sizes where played.
        if self.rectSizes.isEmpty {
            self.endTrial()
            return;
        }
        
        // set next grid size
        self.rectSize = self.rectSizes.popLast()!
        
        // Remove all button from View.
        let _ = self.clickedButtons.map {$0.removeFromSuperview()}
        self.setupGrid()
        self.selectNextActiveButton()
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
        activeButton?.backgroundColor = activeColor
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
                activeButton?.backgroundColor = visitedColor
                selectNextActiveButton()
            }
        }
    }
    
}
