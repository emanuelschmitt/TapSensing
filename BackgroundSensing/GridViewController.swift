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

let rectSize = 100

class GridViewController: UIViewController {
    
    var buttons = [UIButton]()
    var currentButton: UIButton?
    var motionController = MotionController()
    var touchEventController = TouchEventController()
    
    
    // MARK: - Helper

    private func createButton(xPos: Double, yPos: Double, tag: Int) -> UIButton {
        let button = UIButton(frame: CGRect(x: xPos, y: yPos, width: Double(rectSize), height: Double(rectSize)))
        button.backgroundColor = .yellow
        
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        // forward Touch events to underlying layer
        button.isUserInteractionEnabled = false
        
        button.tag = tag
        
        return button
    }
    
    private func createGrid() {
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
                
                buttons.append(button)
                self.view.addSubview(button)
            }
        }
    }
    
    private func nextTile() {
        if buttons.isEmpty {
            endTrail()
            return;
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(buttons.count)))
        currentButton = buttons.remove(at: randomIndex)
        currentButton!.backgroundColor = UIColor.green
    }
    
    private func endTrail() {
        motionController.stopSensorRecordings()
        
        motionController.persistSensorRecordings()
        touchEventController.persistTouchEvents()
        
        if let parent = self.parent as? SessionViewController{
            parent.goToNextPage()
        }
    }
    
    // MARK: -- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGrid()
        motionController.startSensorRecording()
        nextTile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches, type: "TOUCH_DOWN")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches, type: "TOUCH_UP")
    }
    
    fileprivate func handleTouches(_ touches: Set<UITouch>, type: String) {
        for touch in touches {
            let point = touch.location(in: self.view)
            let isHit = (currentButton?.frame.contains(point)) ?? false
            
            touchEventController.addTouchEvent(
                x: Double(point.x),
                y: Double(point.y),
                type: type,
                gridID: isHit ? (currentButton?.tag)! : -1,
                isHit: isHit
            )
            
            if (isHit && type == "TOUCH_UP") {
                currentButton?.backgroundColor = UIColor.red
                nextTile()
            }
        }
    }
    
}
