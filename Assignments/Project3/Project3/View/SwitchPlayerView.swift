//
//  SwitchPlayerView.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/27/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol SwitchPlayerViewDelegate {
    func switchPlayerView(_ switchPlayerView: SwitchPlayerView, playerReady: Bool)
}

class SwitchPlayerView: UIView {
    
    var delegate: SwitchPlayerViewDelegate?
    
//    private var playerLabel: UILabel
//    private var shipHitLabel: UILabel
//    private var tapToContinueLabel: UILabel
    
//    init(frame: CGRect, nextPlayer: String, shipHit: Bool) {
//        super.init(frame: frame)
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.switchPlayerView(self, playerReady: true)
    }
}
