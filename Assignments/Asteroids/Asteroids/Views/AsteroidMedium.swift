//
//  AsteroidMedium.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/5/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class AsteroidMedium: UIView {
    
//    private var asteroidRect: CGRect
    
    override init(frame: CGRect) {
//        asteroidRect = CGRect()
        super.init(frame: frame)
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
//        asteroidRect = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height)
        
        let path: UIBezierPath = UIBezierPath()
        
        path.move(to: CGPoint(x: bounds.width * 0.5, y: 0.0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height * 0.15))
        path.addLine(to: CGPoint(x: bounds.width * 0.8, y: bounds.height * 0.35))
        path.addLine(to: CGPoint(x: bounds.width * 0.95, y: bounds.height * 0.55))
        path.addLine(to: CGPoint(x: bounds.width * 0.65, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width * 0.2, y: bounds.height * 0.85))
        path.addLine(to: CGPoint(x: bounds.width * 0.35, y: bounds.height * 0.75))
        path.addLine(to: CGPoint(x: bounds.width * 0.3, y: bounds.height * 0.72))
        path.addLine(to: CGPoint(x: bounds.width * 0.2, y: bounds.height * 0.68))
        path.addLine(to: CGPoint(x: bounds.width * 0.12, y: bounds.height * 0.58))
        path.addLine(to: CGPoint(x: bounds.width * 0.08, y: bounds.height * 0.25))
        path.addLine(to: CGPoint(x: bounds.width * 0.18, y: bounds.height * 0.2))
        path.addLine(to: CGPoint(x: bounds.width * 0.5, y: 0.0))
        path.lineWidth = 2.0
        path.lineCapStyle = .round
        UIColor(red: 0.83, green: 0.59, blue: 1.0, alpha: 1.0).setStroke()
//        UIColor.white.setStroke()
        path.stroke()
        path.close()
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
}
