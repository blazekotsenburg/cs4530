//
//  ExplosionView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/24/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class ExplosionView: UIView {
    
    private var toggleColorCounter: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        var color1: CGColor = UIColor.clear.cgColor
        var color2: CGColor = UIColor.clear.cgColor
        var color3: CGColor = UIColor.clear.cgColor
        var color4: CGColor = UIColor.clear.cgColor
        
        if toggleColorCounter < 10 {
            color1 = UIColor.cyan.cgColor
            color2 = UIColor.yellow.cgColor
            color3 = UIColor.red.cgColor
            color4 = UIColor.green.cgColor
            toggleColorCounter += 1
        }
        else if toggleColorCounter >= 10 && toggleColorCounter < 20 {
            color1 = UIColor.green.cgColor
            color2 = UIColor.cyan.cgColor
            color3 = UIColor.yellow.cgColor
            color4 = UIColor.red.cgColor
            toggleColorCounter += 1
        }
        else if toggleColorCounter >= 20 && toggleColorCounter < 30 {
            color1 = UIColor.red.cgColor
            color2 = UIColor.green.cgColor
            color3 = UIColor.cyan.cgColor
            color4 = UIColor.yellow.cgColor
            toggleColorCounter += 1
        }
        else if toggleColorCounter >= 30 && toggleColorCounter < 40{
            color1 = UIColor.red.cgColor
            color2 = UIColor.green.cgColor
            color3 = UIColor.cyan.cgColor
            color4 = UIColor.yellow.cgColor
            toggleColorCounter += 1
        }
        else {
            toggleColorCounter = 0
        }
        
        let context = UIGraphicsGetCurrentContext()
        var rect: CGRect = CGRect(x: 0.0, y: 0.0, width: bounds.width * 0.9, height: bounds.height * 0.9)
        rect.origin.y = (bounds.height - rect.height) / 2.0
        rect.origin.x = (bounds.width - rect.width) / 2.0
        context?.addEllipse(in: rect)
        context?.setStrokeColor(color1)
        context?.setLineWidth(3.0)
        context?.drawPath(using: .stroke)
        
        var rect2: CGRect = CGRect(x: 0.0, y: 0.0, width: bounds.width * 0.65, height: bounds.height * 0.65)
        rect2.origin.y = (bounds.height - rect2.height) / 2.0
        rect2.origin.x = (bounds.width - rect2.width) / 2.0
        context?.addEllipse(in: rect2)
        context?.setStrokeColor(color2)
        context?.setLineWidth(2.0)
        context?.drawPath(using: .stroke)
        
        var rect3: CGRect = CGRect(x: 0.0, y: 0.0, width: bounds.width * 0.45, height: bounds.height * 0.45)
        rect3.origin.y = (bounds.height - rect3.height) / 2.0
        rect3.origin.x = (bounds.width - rect3.width) / 2.0
        context?.addEllipse(in: rect3)
        context?.setStrokeColor(color3)
        context?.setLineWidth(2.5)
        context?.drawPath(using: .stroke)
        
        var rect4: CGRect = CGRect(x: 0.0, y: 0.0, width: bounds.width * 0.25, height: bounds.height * 0.25)
        rect4.origin.y = (bounds.height - rect4.height) / 2.0
        rect4.origin.x = (bounds.width - rect4.width) / 2.0
        context?.addEllipse(in: rect4)
        context?.setStrokeColor(color4)
        context?.setFillColor(color4)
        context?.setLineWidth(2.5)
        context?.drawPath(using: .fill)
    }
    
//    func updateUI() {
////        let now = Date()
////        let elapsed = now.timeIntervalSince(spawnRate)
////        spawnRate = now
////
////        if elapsed >= 0.2 {
////            let ring = CGRect(x: bounds.width * 0.5, y: bounds.height * 0.5, width: 0.0, height: 0.0)
////            rings.append((rect: ring, radius: CGFloat(0.0)))
////        }
////
////        for i in 0..<rings.count {
////            let context = UIGraphicsGetCurrentContext()
////            context?.addEllipse(in: rings[i].rect)
////            context?.setStrokeColor(UIColor.cyan.cgColor)
////            context?.setLineWidth(2.0)
////            context?.drawPath(using: .stroke)
////            rings[i].radius += 1.0
////            rings[i].rect = CGRect(x: bounds.width * 0.5, y: bounds.height * 0.5, width: rings[i].radius, height: rings[i].radius)
////            rings[i].rect.origin.y = bounds.height * 0.5 - rings[i].rect.height * 0.5
//        }
//        
////        if !rings.isEmpty {
////            if rings[0].radius >= bounds.width * 0.5 {
////                rings.removeFirst()
////            }
////        }
//    }
}
