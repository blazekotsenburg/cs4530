//
//  ClockView.swift
//  Time
//
//  Created by Blaze Kotsenburg on 1/23/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class ClockView: UIView {
    
    var touchPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {
            timer in
            self.touchPoint.x += -1.0
            self.setNeedsDisplay()
        })
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let touch: UITouch = touches.first!
        touchPoint = touch.location(in: self)
        print("touchPoint x: \(touchPoint.x), y: \(touchPoint.y)")
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let faceRect: CGRect = CGRect(x: 1.0, y: bounds.height * 0.5 - bounds.width * 0.5 + 1.0, width: bounds.width - 1.0, height: bounds.width - 1.0)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
//        context.addRect(faceRect)
        context.addEllipse(in: faceRect)
        context.setStrokeColor(UIColor.cyan.cgColor)
        context.setLineWidth(2.0)
        context.setFillColor(UIColor.darkGray.cgColor)
        context.drawPath(using: .fillStroke)
        
        let circle: CGRect = CGRect(x: touchPoint.x - 5.0, y: touchPoint.y - 5.0, width: 10.0, height: 10.0)
        context.addEllipse(in: circle)
        context.setFillColor(UIColor.yellow.cgColor)
        context.drawPath(using: .fill)
        
//        let center = CGPoint(faceRect.midX, faceRect.midY)
//        context.addLine(to: red)
    }
}
