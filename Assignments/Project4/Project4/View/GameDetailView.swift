//
//  GameDetailView.swift
//  Project4
//
//  Created by Blaze Kotsenburg on 3/29/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol GameDetailViewDelegate {
    func gameDetailView(dismiss gameDetailView: GameDetailView)
}

class GameDetailView: UIView {

    var stackView: UIStackView = UIStackView()
    var gameDetailsLabel: UILabel = UILabel()
    var gameNameLabel: UILabel = UILabel()
    var playerLabel: UILabel = UILabel()
    var opponentLabel: UILabel = UILabel()
    var winnerLabel: UILabel = UILabel()
    var gameStatusLabel: UILabel = UILabel()
    var totalMissilesLaunchedLabel: UILabel = UILabel()
    
    var delegate: GameDetailViewDelegate?
    
    func reloadData() {
        setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        gameDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        gameNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        opponentLabel.translatesAutoresizingMaskIntoConstraints = false
        winnerLabel.translatesAutoresizingMaskIntoConstraints = false
        gameStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        totalMissilesLaunchedLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50.0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50.0).isActive = true
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 10.0
        
        addSubview(gameDetailsLabel)
        gameDetailsLabel.text = "Game Details"
        gameDetailsLabel.font = UIFont(name: "Avenir", size: 28.0)
        gameDetailsLabel.textAlignment = .center
        gameDetailsLabel.textColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        
        addSubview(gameDetailsLabel)
        gameNameLabel.text = "Game Name"
        gameNameLabel.font = UIFont(name: "Avenir", size: 20.0)
        gameNameLabel.textAlignment = .center
        gameNameLabel.textColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        
        addSubview(playerLabel)
        playerLabel.text = "Player Name"
        playerLabel.font = UIFont(name: "Avenir", size: 20.0)
        playerLabel.textAlignment = .center
        playerLabel.textColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        
        addSubview(opponentLabel)
        opponentLabel.text = "Opponent Name"
        opponentLabel.font = UIFont(name: "Avenir", size: 20.0)
        opponentLabel.textAlignment = .center
        opponentLabel.textColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        
        addSubview(winnerLabel)
        winnerLabel.text = "Opponent Name"
        winnerLabel.font = UIFont(name: "Avenir", size: 20.0)
        winnerLabel.textAlignment = .center
        winnerLabel.textColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        
        addSubview(gameStatusLabel)
        gameStatusLabel.text = "Opponent Name"
        gameStatusLabel.font = UIFont(name: "Avenir", size: 20.0)
        gameStatusLabel.textAlignment = .center
        gameStatusLabel.textColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        
        let views: [String: Any] = ["gameDetails": gameDetailsLabel, "gameName": gameNameLabel, "playerLabel": playerLabel, "opponentLabel": opponentLabel, "winnerLabel": winnerLabel,
                                    "gameStatusLabel": gameStatusLabel]
        
        stackView.addArrangedSubview(gameDetailsLabel)
        stackView.addArrangedSubview(gameNameLabel)
        stackView.addArrangedSubview(playerLabel)
        stackView.addArrangedSubview(opponentLabel)
        stackView.addArrangedSubview(winnerLabel)
        stackView.addArrangedSubview(gameStatusLabel)
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[gameDetails]-|", options: [], metrics: nil, views: views))
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[gameName]-|", options: [], metrics: nil, views: views))
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[playerLabel]-|", options: [], metrics: nil, views: views))
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[opponentLabel]-|", options: [], metrics: nil, views: views))
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[winnerLabel]-|", options: [], metrics: nil, views: views))
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[gameStatusLabel]-|", options: [], metrics: nil, views: views))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.gameDetailView(dismiss: self)
    }
}
