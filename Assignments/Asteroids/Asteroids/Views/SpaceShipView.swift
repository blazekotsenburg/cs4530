//
//  SpaceShipView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class SpaceShipView: UIView {
    
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
        
        path.move(to: CGPoint(x: bounds.width * 0.5, y: 0.0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.85))
        path.addLine(to: CGPoint(x: 0.0, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width * 0.5, y: 0.0))
        path.lineWidth = 2.0
        path.lineCapStyle = .round
        UIColor(red: 1.0, green: 0.47, blue: 0.74, alpha: 1.0).setStroke()
        path.stroke()
        path.close()
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
}
