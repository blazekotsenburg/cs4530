//
//  GameView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol GameViewDelegate {
    func gameView(updateAngleIn gameView: GameView, for shipAngle: CGFloat)
    func gameView(accelerateShipIn gameView: GameView)
    func gameView(getPositionForShipIn gameView: GameView) -> CGPoint
}

class GameView: UIView {
    
    private var shipView: SpaceShipView
    private var largeAsteroid: AsteroidLarge
    private var mediumAsteroid: AsteroidMedium
    private var gameLabelStackView: UIStackView
    private var rotateButtonsStackView: UIStackView
    private var controlStackView: UIStackView
    private var scoreLabel: UILabel
    private var livesLabel: UILabel
    private var rotateLeftButton: UIButton
    private var rotateRightButton: UIButton
    private var thrustButton: UIButton
    private var shootButton: UIButton
    private var labelViews: [String: Any]
    private var buttonViews: [String: Any]
    private var controlViews: [String: Any]
    var currAngle:CGFloat = 0.0
    
    var timer: Timer = Timer()
    
    var delegate: GameViewDelegate?
    
    override init(frame: CGRect) {
        shipView = SpaceShipView(frame: .zero)
        largeAsteroid = AsteroidLarge()
        mediumAsteroid = AsteroidMedium()
        gameLabelStackView = UIStackView()
        rotateButtonsStackView = UIStackView()
        controlStackView = UIStackView()
        scoreLabel = UILabel()
        livesLabel = UILabel()
        rotateLeftButton = UIButton()
        rotateRightButton = UIButton()
        thrustButton = UIButton()
        shootButton = UIButton()
        labelViews = ["scoreLabel": scoreLabel, "livesLabel": livesLabel]
        buttonViews = ["rotateLeft": rotateLeftButton, "rotateRight": rotateRightButton]
        controlViews = ["thrustButton": thrustButton, "shootButton": shootButton]
        super.init(frame: frame)
        
        gameLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        rotateButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        controlStackView.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .black
        addSubview(shipView)
        addSubview(largeAsteroid)
        addSubview(mediumAsteroid)
        addSubview(gameLabelStackView)
        addSubview(rotateButtonsStackView)
        addSubview(controlStackView)
        
        gameLabelStackView.alignment = .leading
        gameLabelStackView.axis = .vertical
        gameLabelStackView.distribution = .fillEqually
        
        rotateButtonsStackView.alignment = .center
        rotateButtonsStackView.axis = .horizontal
        rotateButtonsStackView.distribution = .fillEqually
        rotateButtonsStackView.spacing = 10.0
        
        controlStackView.alignment = .center
        controlStackView.axis = .horizontal
        controlStackView.distribution = .fillEqually
        controlStackView.spacing = 10.0
        
        scoreLabel.text = "00000"
        scoreLabel.font = UIFont(name: "spacefont", size: 24.0)
        scoreLabel.textColor = .white
        
        livesLabel.text = "♥︎ ♥︎ ♥︎"
        livesLabel.font = UIFont(name: "spacefont", size: 20.0)
        livesLabel.textColor = .white
        
        rotateLeftButton.setTitle("Left", for: .normal)
        rotateLeftButton.titleLabel?.textColor = .black
        rotateLeftButton.addTarget(self, action: #selector(rotateShip), for: .allTouchEvents)
        
        rotateRightButton.setTitle("Right", for: .normal)
        rotateRightButton.titleLabel?.textColor = .black
        rotateRightButton.addTarget(self, action: #selector(rotateShip), for: .allTouchEvents)
        
        thrustButton.setTitle("Go", for: .normal)
        thrustButton.titleLabel?.textColor = .white
        thrustButton.addTarget(self, action: #selector(accelerateShip), for: .allTouchEvents)
        
        shootButton.setTitle("Fire", for: .normal)
        shootButton.titleLabel?.textColor = .white
        
        gameLabelStackView.addArrangedSubview(scoreLabel)
        gameLabelStackView.addArrangedSubview(livesLabel)
        
        rotateButtonsStackView.addArrangedSubview(rotateLeftButton)
        rotateButtonsStackView.addArrangedSubview(rotateRightButton)
        
        controlStackView.addArrangedSubview(thrustButton)
        controlStackView.addArrangedSubview(shootButton)
        
        beginTimer()
    }
    
    private func beginTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true, block: { _ in
//            self.UpdateShip()
            self.setNeedsDisplay()
        })

    }
    
    @objc func rotateShip(sender: Any) {
        
        if let button = sender as? UIButton {
            if button == rotateLeftButton {
                UIView.animate(withDuration: 0.2, animations: {
                    self.shipView.transform = CGAffineTransform(rotationAngle: (self.currAngle - (5.0 * .pi) / 180.0))
                    self.currAngle -= (5.0 * .pi) / 180.0
                    self.delegate?.gameView(updateAngleIn: self, for: self.currAngle)
                })
            }
            else if button == rotateRightButton {
                UIView.animate(withDuration: 0.2, animations: {
                    self.shipView.transform = CGAffineTransform(rotationAngle: (self.currAngle + (5.0 * .pi) / 180.0))
                    self.currAngle += (5.0 * .pi) / 180.0
                    self.delegate?.gameView(updateAngleIn: self, for: self.currAngle)
                })
            }
        }
    }
    
    @objc func accelerateShip(sender: Any) {
        if let button = sender as? UIButton {
            if button == thrustButton {
                delegate?.gameView(accelerateShipIn: self)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let shipPoint = delegate?.gameView(getPositionForShipIn: self) else { return }
        
        shipView.frame = CGRect(x: shipPoint.x, y: shipPoint.y, width: 25.0, height: 25.0)
        
        largeAsteroid.frame = CGRect(x: 100.0, y: 100.0, width: 120.0, height: 120.0)
        mediumAsteroid.frame = CGRect(x: 200.0, y: 200.0, width: 60.0, height: 60.0)
        
        gameLabelStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12.0).isActive = true
        gameLabelStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12.0).isActive = true
        gameLabelStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.25).isActive = true
        gameLabelStackView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        rotateButtonsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15.0).isActive = true
        rotateButtonsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 15.0).isActive = true
        rotateButtonsStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3).isActive = true
        rotateButtonsStackView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        
        controlStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15.0).isActive = true
        controlStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 15.0).isActive = true
        controlStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3).isActive = true
        controlStackView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        
        gameLabelStackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[scoreLabel]-|", options: [], metrics: nil, views: labelViews))
        gameLabelStackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[livesLabel]-|", options: [], metrics: nil, views: labelViews))
        
        //Data from model
    }
    
//    func UpdateShip() {
//        shipView.frame.origin.y += 1
//        shipView.frame.origin.x += 1
//        setNeedsDisplay()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        guard let shipPoint = delegate?.gameView(getPositionForShipIn: self) else { return }
        shipView.frame = CGRect(x: shipPoint.x, y: shipPoint.y, width: 25.0, height: 25.0)
        setNeedsDisplay()
        shipView.reloadData()
    }
}
