//
//  GridViewController.swift
//  BackgroundSensing
//
//  Created by Emanuel Schmitt on 18.05.17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit

class GridViewController : UIViewController {
    
    var buttons = [UIButton]()
    var currentButton : UIButton?
    let rectSize = 70
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    private func createButton(xPos: Int, yPos: Int) -> UIButton {
        let button = UIButton(frame: CGRect(x: xPos, y: yPos, width: rectSize, height: rectSize))
        button.backgroundColor = .yellow
        
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        // forward Touch events to underlying
        button.isUserInteractionEnabled = false
        
        return button
    }
    
    private func createGrid() {
        let screenWidth = Int(self.view!.bounds.width)
        let screenHeight = Int(self.view!.bounds.height)
        
        let rectAmountHorizontal = screenWidth / rectSize
        let whiteSpaceHorizontal = screenWidth % rectSize
        let paddingHorizontal = Double(whiteSpaceHorizontal) / Double((rectAmountHorizontal + 1))
        
        let rectAmountVertical = screenHeight / rectSize
        let whiteSpaceVertical = screenHeight % rectSize
        let paddingVertical = Double(whiteSpaceVertical) / Double((rectAmountVertical + 1))
        
        for v in (0..<rectAmountVertical){
            for h in (0..<rectAmountHorizontal){
                
                let x = Int(paddingHorizontal)  + h * (rectSize + Int(paddingHorizontal))
                let y = Int(paddingVertical) + v * (rectSize + Int(paddingVertical))
                
                print("Button X: \(x), Y: \(y)")
                let button = createButton(xPos: x, yPos: y)
                
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
        highlightNextButton()
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
