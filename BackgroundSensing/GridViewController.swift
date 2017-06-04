//
//  GridViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 18.05.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit
import Foundation

class GridViewController : UIViewController {
    
    var buttons = [UIButton]()
    var currentButton : UIButton?
    let rectSize = 63
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    private func createButton(xPos: Double, yPos: Double) -> UIButton {
        let button = UIButton(frame: CGRect(x: xPos, y: yPos, width: Double(rectSize), height: Double(rectSize)))
        button.backgroundColor = .yellow
        
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        // forward Touch events to underlying
        button.isUserInteractionEnabled = false
        
        return button
    }
    
    private func createGrid() {
        let screenWidth = Float(self.view!.bounds.width)
        let screenHeight = Float(self.view!.bounds.height)
        
        let rectAmountHorizontal = floor(screenWidth / Float(self.rectSize))
        let whiteSpaceHorizontal = screenWidth.truncatingRemainder(dividingBy: Float(self.rectSize))
        let paddingHorizontal = whiteSpaceHorizontal / Float((rectAmountHorizontal + 1))
        
        let rectAmountVertical = floor(screenHeight / Float(self.rectSize))
        let whiteSpaceVertical = screenHeight.truncatingRemainder(dividingBy: Float(self.rectSize))
        let paddingVertical = Float(whiteSpaceVertical) / Float((rectAmountVertical + 1))
        
        for v in (0..<Int(rectAmountVertical)){
            for h in (0..<Int(rectAmountHorizontal)){
                
                let x = paddingHorizontal + Float(h * (self.rectSize + Int(paddingHorizontal)))
                let y = paddingVertical + Float(v * (self.rectSize + Int(paddingVertical)))
                
                print("Button X: \(x), Y: \(y)")
                let button = createButton(xPos: Double(x), yPos: Double(y))
                
                buttons.append(button)
                self.view.addSubview(button)
            }
        }
    }
    
    private func highlightNextButton() {
        
        if buttons.isEmpty {
            return;
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(buttons.count)))
        currentButton = buttons.remove(at: randomIndex)
        currentButton!.backgroundColor = UIColor.green
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGrid()
        startSensorRecording()
        highlightNextButton()
    }
    
    private func startSensorRecording() {
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        let point = touch!.location(in: self.view)
        let pointX = point.x
        let pointY = point.y
        
        let timestamp = NSDate()
        
        print("X: \(pointX), Y: \(pointY)")
        
        if (currentButton?.frame.contains(point))! {
            print("contains")
            currentButton?.backgroundColor = UIColor.red
            highlightNextButton()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
