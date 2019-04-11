//
//  AsteroidLarge.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/10/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class AsteroidSmall: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let path: UIBezierPath = UIBezierPath()
        
        path.move(to: CGPoint(x: bounds.width * 0.25, y: 0.0))
        path.addLine(to: CGPoint(x: bounds.width * 0.85, y: bounds.height * 0.15))
        path.addLine(to: CGPoint(x: bounds.width * 0.7, y: bounds.height * 0.35))
        path.addLine(to: CGPoint(x: bounds.width * 0.8, y: bounds.height * 0.65))
        path.addLine(to: CGPoint(x: bounds.width * 0.9, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width * 0.2, y: bounds.height * 0.85))
        path.addLine(to: CGPoint(x: bounds.width * 0.15, y: bounds.height * 0.75))
        path.addLine(to: CGPoint(x: bounds.width * 0.2, y: bounds.height * 0.68))
        path.addLine(to: CGPoint(x: 0.0, y: bounds.height * 0.58))
        path.addLine(to: CGPoint(x: bounds.width * 0.22, y: bounds.height * 0.3))
        path.addLine(to: CGPoint(x: bounds.width * 0.18, y: bounds.height * 0.2))
        path.addLine(to: CGPoint(x: bounds.width * 0.25, y: 0.0))
        path.lineWidth = 2.0
        path.lineCapStyle = .round
        UIColor.white.setStroke()
        path.stroke()
        path.close()
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
}
