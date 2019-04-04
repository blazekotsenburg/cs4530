//
//  GameView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol GameViewDelegate {
    
}

class GameView: UIView {
    
    private var shipView: SpaceShipView
    
    var delegate: GameViewDelegate?
    
    override init(frame: CGRect) {
        shipView = SpaceShipView()
        super.init(frame: frame)
        
        backgroundColor = .black
        addSubview(shipView)
    }
    
    override func draw(_ rect: CGRect) {
        shipView.frame = CGRect(x: frame.width * 0.5, y: frame.height * 0.5, width: 40.0, height: 40.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
}
