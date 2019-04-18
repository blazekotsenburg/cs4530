//
//  SpaceShipView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/17/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class BulletView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: frame.height, height: frame.width)
        context.addEllipse(in: rect)
//        context.setStrokeColor(UIColor(red: 0.11, green: 0.99, blue: 0.98, alpha: 1.0).cgColor)
//        context.setLineWidth(2.0)
        context.setFillColor(UIColor(red: 0.11, green: 0.99, blue: 0.98, alpha: 1.0).cgColor)
        context.drawPath(using: .fillStroke)
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
}
