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
    func switchPlayerView(getLaunchStatus switchPlayerView: SwitchPlayerView) -> String
}

class SwitchPlayerView: UIView {
    
    var delegate: SwitchPlayerViewDelegate?
    
    var status: UILabel = UILabel()
    private var tapToContinueLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0)
        status.translatesAutoresizingMaskIntoConstraints = false
        tapToContinueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func draw(_ rect: CGRect) {
        
        status.text = delegate?.switchPlayerView(getLaunchStatus: self)
        status.textColor = .black
        status.font = UIFont(name: "Avenir", size: 32.0)
        status.textAlignment = .center
        addSubview(status)
        
        tapToContinueLabel.text = "Tap to Continue"
        tapToContinueLabel.textColor = .black
        tapToContinueLabel.font = UIFont(name: "Avenir", size: 24.0)
        tapToContinueLabel.textAlignment = .center
        addSubview(tapToContinueLabel)
        
        status.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
        status.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        status.centerXAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: safeAreaLayoutGuide.centerXAnchor, multiplier: 0.5).isActive = true
        
        tapToContinueLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50.0).isActive = true
        tapToContinueLabel.centerXAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: safeAreaLayoutGuide.centerXAnchor, multiplier: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.switchPlayerView(self, playerReady: true)
    }
}
