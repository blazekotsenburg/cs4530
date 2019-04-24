//
//  SpaceShipView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class SpaceShipView: UIView {
    
    var thrustersOn: Bool = false
    var thrusterColor: Int = 0
    
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
        
        if thrustersOn {
            let path2: UIBezierPath = UIBezierPath()
            if thrusterColor < 10 {
                UIColor(red: 0.12, green: 1.0, blue: 0.78, alpha: 1.0).setStroke()
                thrusterColor += 1
            }
            else if thrusterColor >= 10 && thrusterColor < 20 {
                UIColor(red: 0.78, green: 1.0, blue: 0.1, alpha: 1.0).setStroke()
                thrusterColor += 1
            }
            else {
                thrusterColor = 0
            }
            path2.move(to: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.75))
            path2.addLine(to: CGPoint(x: bounds.width * 0.5, y: bounds.height))
            
            path2.lineWidth = 4.0
            path2.lineCapStyle = .butt
            path2.stroke()
            path2.close()
        }
        
        UIColor(red: 1.0, green: 0.47, blue: 0.74, alpha: 1.0).setStroke()
        path.move(to: CGPoint(x: bounds.width * 0.5, y: 0.0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.75))
        path.addLine(to: CGPoint(x: 0.0, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width * 0.5, y: 0.0))
        path.lineWidth = 2.0
        path.lineCapStyle = .round
        path.stroke()
        path.close()
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
}
