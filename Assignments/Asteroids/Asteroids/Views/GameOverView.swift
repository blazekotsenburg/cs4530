//
//  GameOverView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/19/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol GameOverViewDelegate {
    func gameOverViewReturnToMain()
}

class GameOverView: UIView {
    
    var delegate: GameOverViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let delegate = delegate else { return }
        delegate.gameOverViewReturnToMain()
    }
}
