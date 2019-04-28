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
    func gameOverView(saveGameFor player: String)
}

class GameOverView: UIView {
    
    private var stackView: UIStackView
    private var gameOverLabel: UILabel
    private var scoreLabel: UILabel
    private var leaderBoardLabel: UILabel
    private var playerNameField: UITextField
    private var saveScoreButton: UIButton
    private var views: [String: Any]
    
    var delegate: GameOverViewDelegate?
    
    override init(frame: CGRect) {
        stackView = UIStackView()
        scoreLabel = UILabel()
        leaderBoardLabel = UILabel()
        gameOverLabel = UILabel()
        playerNameField = UITextField()
        saveScoreButton = UIButton()
        views = ["gameOverLabel": gameOverLabel, "scoreLabel": scoreLabel, "leaderBoardLabel": leaderBoardLabel, "playerNameField": playerNameField]
        super.init(frame: frame)
        
        gameOverLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        leaderBoardLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        playerNameField.translatesAutoresizingMaskIntoConstraints = false
        saveScoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.textColor = .white
        gameOverLabel.font = UIFont(name: "EarthOrbiter", size: 48.0)
        gameOverLabel.textAlignment = .center
        
        scoreLabel.font = UIFont(name: "EarthOrbiter", size: 32.0)
        scoreLabel.textColor = .green
        scoreLabel.textAlignment = .center
        
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.75).isActive = true
        stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        stackView.addArrangedSubview(gameOverLabel)
        stackView.addArrangedSubview(leaderBoardLabel)
        stackView.addArrangedSubview(scoreLabel)
        stackView.addArrangedSubview(playerNameField)
        stackView.addArrangedSubview(saveScoreButton)
        
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[gameOverLabel]-|", options: [], metrics: nil, views: views))
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[scoreLabel]-|", options: [], metrics: nil, views: views))
    }
    
    func setPlayerNameField() {
        leaderBoardLabel.text = "New LeaderBoard Score:"
        leaderBoardLabel.font = UIFont(name: "EarthOrbiter", size: 24.0)
        leaderBoardLabel.textColor = .white
        leaderBoardLabel.textAlignment = .center
        
        playerNameField.placeholder = "Enter Name"
        playerNameField.textColor = .black
        playerNameField.font = UIFont(name: "EarthOrbiter", size: 20.0)
        playerNameField.backgroundColor = .lightGray
        playerNameField.returnKeyType = .done
        playerNameField.textAlignment = .center
        playerNameField.addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
        playerNameField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
        playerNameField.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        saveScoreButton.setTitle("Save", for: .normal)
        saveScoreButton.backgroundColor = .lightGray
        saveScoreButton.titleLabel?.font = UIFont(name: "EarthOrbiter", size: 20.0)
        saveScoreButton.widthAnchor.constraint(equalTo: playerNameField.widthAnchor).isActive = true
        saveScoreButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        saveScoreButton.addTarget(self, action: #selector(saveGameScore), for: .touchUpInside)
        
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[leaderBoardLabel]-|", options: [], metrics: nil, views: views))
    }
    
    @objc func dismissKeyboard(sender: Any) {
        if let textField = sender as? UITextField {
            if textField == playerNameField {
                textField.resignFirstResponder()
            }
        }
    }
    
    @objc func saveGameScore(sender: Any) {
        if let saveButton = sender as? UIButton {
            if saveButton == saveScoreButton {
                guard let delegate = delegate else { return }
                delegate.gameOverView(saveGameFor: playerNameField.text ?? "")
            }
        }
    }
    
    func setScoreLabel(score: Int) {
        scoreLabel.text = score.description
    }
    
    func reloadData() {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let delegate = delegate else { return }
        delegate.gameOverViewReturnToMain()
    }
}
