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
    
    var playerLabel: UILabel?
//    var shipHitLabel: UILabel?
    private var tapToContinueLabel: UILabel?
    
    override init(frame: CGRect) {
        playerLabel = UILabel()
        tapToContinueLabel = UILabel()
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        playerLabel?.translatesAutoresizingMaskIntoConstraints = false
        tapToContinueLabel?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func draw(_ rect: CGRect) {
        playerLabel?.textColor = .black
        playerLabel?.font = UIFont(name: "Avenir", size: 32.0)
        playerLabel?.font = UIFont.boldSystemFont(ofSize: 32.0)
        playerLabel?.textAlignment = .center
        self.addSubview(playerLabel!)
        
        tapToContinueLabel?.text = "Tap to Continue"
        tapToContinueLabel?.textColor = .black
        tapToContinueLabel?.font = UIFont(name: "Avenir", size: 24.0)
        tapToContinueLabel?.textAlignment = .center
        self.addSubview(tapToContinueLabel!)
        
        let views: [String: Any] = ["playerLabel": playerLabel!, "tapToContinueLabel": tapToContinueLabel!]
        
        // set the height and widths used below to properties of the view so that it can be updated in the viewController on willTransitionTo
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[playerLabel]-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[tapToContinueLabel]-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(frame.height * 0.333))-[playerLabel(<=\(frame.width * 0.25))]-50-[tapToContinueLabel(<=\(frame.width * 0.25))]", options: [], metrics: nil, views: views))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.switchPlayerView(self, playerReady: true)
    }
}
