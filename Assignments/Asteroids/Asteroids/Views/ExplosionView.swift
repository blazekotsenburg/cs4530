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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        if toggleColorCounter < 10 {
            let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: bounds.width * 75, height: bounds.height * 75)
            context?.addEllipse(in: rect)
            context?.setStrokeColor(UIColor.cyan.cgColor)
            context?.setLineWidth(2.0)
            toggleColorCounter += 1
        }
        
        context?.drawPath(using: .stroke)
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
