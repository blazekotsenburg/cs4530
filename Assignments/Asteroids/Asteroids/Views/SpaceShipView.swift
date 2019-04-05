//
//  SpaceShipView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class SpaceShipView: UIView {
    
    private var shipRect: CGRect
    
    override init(frame: CGRect) {
        shipRect = CGRect()
        super.init(frame: .zero)
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        shipRect = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        
        let path: UIBezierPath = UIBezierPath()
        
        path.move(to: CGPoint(x: frame.width * 0.5, y: 0.0))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: frame.width * 0.5, y: frame.height * 0.85))
        path.addLine(to: CGPoint(x: 0.0, y: frame.height))
        path.addLine(to: CGPoint(x: frame.width * 0.5, y: 0.0))
        path.lineWidth = 2.0
        path.lineCapStyle = .round
        UIColor(red: 1.0, green: 0.47, blue: 0.74, alpha: 1.0).setStroke()
        path.stroke()
        path.close()
    }
}
