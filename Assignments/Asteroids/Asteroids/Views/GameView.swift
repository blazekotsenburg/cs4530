//
//  GameView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol GameViewDelegate {
    func gameView(getAngleForShipIn gameView: GameView) -> Float
    func gameView(rotateLeftPressed gameView: GameView, rotating: Bool)
    func gameView(rotateRightPressed gameView: GameView, rotating: Bool)
    func gameView(thrusterPressed gameView: GameView, thrusterOn: Bool)
    func gameView(shootButtonToggled gameView: GameView, fireProjectile: Bool)
    func gameView(getPositionForShipIn gameView: GameView) -> (x: Float, y: Float)
    func gameView(getAsteroidPositionsIn gameView: GameView) -> [String: [AsteroidObject]]
    func gameView(getBulletPositionsIn gameView: GameView) -> [(x: Float, y: Float)]
    func gameView(homeButtonPressed: GameView)
    func gameView(getAngleForAsteroiFor key: String, at index: Int) -> Float
}

class GameView: UIView {
    
    private var shipView: SpaceShipView
    private var largeAsteroid: AsteroidLarge
    private var mediumAsteroid: AsteroidMedium
    private var smallAsteroid: AsteroidSmall
    private var explosionView: ExplosionView
    private var gameLabelStackView: UIStackView
    private var rotateButtonsStackView: UIStackView
    private var controlStackView: UIStackView
    private var scoreLabel: UILabel
    private var livesLabel: UILabel
    private var rotateLeftButton: UIButton
    private var rotateRightButton: UIButton
    private var thrustButton: UIButton
    private var shootButton: UIButton
    private var returnHomeButton: UIButton
    private var labelViews: [String: Any]
    private var buttonViews: [String: Any]
    private var controlViews: [String: Any]
    private var asteroids: [String: [Any]]
    private var bullets: [BulletView]
    var currAngle:CGFloat = 0.0
    private var shipRespawned: Bool
    private var respawnedAt: Date
    
    var timer: Timer = Timer()
    
    var delegate: GameViewDelegate?
    
    override init(frame: CGRect) {
        shipView = SpaceShipView()
        largeAsteroid = AsteroidLarge()
        mediumAsteroid = AsteroidMedium()
        smallAsteroid = AsteroidSmall()
        explosionView = ExplosionView()
        gameLabelStackView = UIStackView()
        rotateButtonsStackView = UIStackView()
        controlStackView = UIStackView()
        scoreLabel = UILabel()
        livesLabel = UILabel()
        rotateLeftButton = UIButton()
        rotateRightButton = UIButton()
        thrustButton = UIButton()
        shootButton = UIButton()
        returnHomeButton = UIButton()
        labelViews = ["scoreLabel": scoreLabel, "livesLabel": livesLabel]
        buttonViews = ["rotateLeft": rotateLeftButton, "rotateRight": rotateRightButton, "shootButton": shootButton]
        controlViews = ["thrustButton": thrustButton, "shootButton": shootButton]
        asteroids = ["large": [], "medium": [], "small": []]
        bullets = []
        shipRespawned = false
        respawnedAt = Date()
        super.init(frame: frame)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "galaxy_background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        insertSubview(backgroundImage, at: 0)
        
        gameLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        rotateButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        controlStackView.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        rotateLeftButton.translatesAutoresizingMaskIntoConstraints = false
        rotateRightButton.translatesAutoresizingMaskIntoConstraints = false
        shootButton.translatesAutoresizingMaskIntoConstraints = false
        returnHomeButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .black
        shipView.contentMode = .redraw
        addSubview(shipView)
        gameLabelStackView.contentMode = .redraw
        addSubview(gameLabelStackView)
        rotateButtonsStackView.contentMode = .redraw
        addSubview(rotateButtonsStackView)
        controlStackView.contentMode = .redraw
        addSubview(controlStackView)
        
        gameLabelStackView.alignment = .leading
        gameLabelStackView.axis = .vertical
        gameLabelStackView.distribution = .fillEqually
        
        rotateButtonsStackView.alignment = .center
        rotateButtonsStackView.axis = .horizontal
        rotateButtonsStackView.distribution = .fillEqually
//        rotateButtonsStackView.spacing = 10.0
        
        controlStackView.alignment = .center
        controlStackView.axis = .horizontal
        controlStackView.distribution = .fillEqually
        controlStackView.spacing = 10.0
        
        scoreLabel.text = "00"
        scoreLabel.font = UIFont(name: "EarthOrbiter", size: 24.0)
        scoreLabel.textColor = .green
        
        livesLabel.text = "♥︎ ♥︎ ♥︎"
        livesLabel.font = UIFont(name: "spacefont", size: 20.0)
        livesLabel.textColor = .white
        
        rotateLeftButton.setTitle("Left", for: .normal)
        rotateLeftButton.titleLabel?.textColor = .black
        rotateLeftButton.titleLabel?.font = UIFont(name: "EarthOrbiter", size: 20.0)
        rotateLeftButton.addTarget(self, action: #selector(rotateShipLeftPressed), for: .touchDown)
        rotateLeftButton.addTarget(self, action: #selector(rotateShipLeftReleased), for: .touchUpInside)
        
        rotateRightButton.setTitle("Right", for: .normal)
        rotateRightButton.titleLabel?.textColor = .black
        rotateRightButton.titleLabel?.font = UIFont(name: "EarthOrbiter", size: 20.0)
        rotateRightButton.addTarget(self, action: #selector(rotateShipRightPressed), for: .touchDown)
        rotateRightButton.addTarget(self, action: #selector(rotateShipRightReleased), for: .touchUpInside)
        
        thrustButton.setTitle("Go", for: .normal)
        thrustButton.titleLabel?.textColor = .white
        thrustButton.titleLabel?.font = UIFont(name: "EarthOrbiter", size: 20.0)
        thrustButton.addTarget(self, action: #selector(thrusterPressed), for: .touchDown)
        thrustButton.addTarget(self, action: #selector(thrusterReleased), for: .touchUpInside)
        
        shootButton.setTitle("Fire", for: .normal)
        shootButton.titleLabel?.textColor = .white
        shootButton.titleLabel?.font = UIFont(name: "EarthOrbiter", size: 20.0)
        shootButton.addTarget(self, action: #selector(shootButtonPressed), for: .touchDown)
        shootButton.addTarget(self, action: #selector(shootButtonReleased), for: .touchUpInside)
        
        returnHomeButton.setTitle("HOME", for: .normal)
        returnHomeButton.titleLabel?.textColor = .white
        returnHomeButton.titleLabel?.font = UIFont(name: "EarthOrbiter", size: 20.0)
        returnHomeButton.addTarget(self, action: #selector(returnHomeButtonPressed), for: .touchUpInside)
        addSubview(returnHomeButton)
        returnHomeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15.0).isActive = true
        returnHomeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15.0).isActive = true
        returnHomeButton.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        returnHomeButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        gameLabelStackView.addArrangedSubview(scoreLabel)
        gameLabelStackView.addArrangedSubview(livesLabel)
        
        rotateButtonsStackView.addArrangedSubview(rotateLeftButton)
        rotateButtonsStackView.addArrangedSubview(shootButton)
        rotateButtonsStackView.addArrangedSubview(rotateRightButton)
        
        controlStackView.addArrangedSubview(thrustButton)
//        controlStackView.addArrangedSubview(shootButton)
        
        gameLabelStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12.0).isActive = true
        gameLabelStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12.0).isActive = true
        gameLabelStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.25).isActive = true
        gameLabelStackView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        rotateButtonsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15.0).isActive = true
        rotateButtonsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5.0).isActive = true
        rotateButtonsStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4).isActive = true
        rotateButtonsStackView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        
        shootButton.topAnchor.constraint(equalTo: rotateButtonsStackView.topAnchor).isActive = true
        shootButton.bottomAnchor.constraint(equalTo: rotateButtonsStackView.bottomAnchor).isActive = true
        rotateLeftButton.topAnchor.constraint(equalTo: rotateButtonsStackView.topAnchor).isActive = true
        rotateLeftButton.bottomAnchor.constraint(equalTo: rotateButtonsStackView.bottomAnchor).isActive = true
        rotateRightButton.topAnchor.constraint(equalTo: rotateButtonsStackView.topAnchor).isActive = true
        rotateRightButton.bottomAnchor.constraint(equalTo: rotateButtonsStackView.bottomAnchor).isActive = true
        thrustButton.topAnchor.constraint(equalTo: controlStackView.topAnchor).isActive = true
        thrustButton.bottomAnchor.constraint(equalTo: controlStackView.bottomAnchor).isActive = true
        
        controlStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15.0).isActive = true
        controlStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15.0).isActive = true
        controlStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3).isActive = true
        controlStackView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        
        rotateButtonsStackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[rotateLeft][shootButton][rotateRight]", options: [], metrics: nil, views: buttonViews))
        
        gameLabelStackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[scoreLabel]-|", options: [], metrics: nil, views: labelViews))
        gameLabelStackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[livesLabel]-|", options: [], metrics: nil, views: labelViews))
        
        explosionView = ExplosionView()
        explosionView.center = CGPoint(x: 0.0, y: 0.0)
        explosionView.bounds = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        explosionView.contentMode = .redraw
        addSubview(explosionView)
        bringSubviewToFront(explosionView)
        explosionView.isHidden = true
        
        beginTimer()
        asteroidPositions()
    }
    
    // this should be get asteroids positions
    private func asteroidPositions() {
        guard let delegate = delegate else { return }
        let positions = delegate.gameView(getAsteroidPositionsIn: self)
        
        for (size, positionList) in positions {
            
            if let asteroidList = asteroids[size] {
                if asteroidList.count < positionList.count {
                    switch size {
                        case "large":
//                            for i in 0..<positionList.count {
                            let asteroid: AsteroidLarge = AsteroidLarge()
                            asteroids[size]?.append(asteroid)
                            let index: Int = asteroids[size]!.count - 1
                            spawnAsteroids(withSize: size, atIndex: index, for: positionList)
                            addSubview(asteroid)
                            break
//                            }
                        case "medium":
//                            for i in 0..<positionList.count {
                            let asteroid: AsteroidMedium = AsteroidMedium()
                            asteroids[size]?.append(asteroid)
                            let index: Int = asteroids[size]!.count - 1
                            spawnAsteroids(withSize: size, atIndex: index, for: positionList)
                            addSubview(asteroid)
                            break
//                            }
                        case "small":
//                            for i in 0..<positionList.count {
                            let asteroid: AsteroidSmall = AsteroidSmall()
                            asteroids[size]?.append(asteroid)
                            let index: Int = asteroids[size]!.count - 1
                            spawnAsteroids(withSize: size, atIndex: index, for: positionList)
                            addSubview(asteroid)
                            break
//                            }
                        default:
                            break
                        
                    }
                }
                else { // Else the asteroidList is not empty and positions in asteroid dictionary need to be updated
                    for i in 0..<positionList.count {
                        spawnAsteroids(withSize: size, atIndex: i, for: positionList)
                    }
                }
            }
        }
    }
    
    func bulletPositions() {
        guard let delegate = delegate else { return }
        let positions = delegate.gameView(getBulletPositionsIn: self)
        
        let difference = bullets.count - positions.count
        
        switch difference {
            case let x where x < 0:
                for i in 0..<abs(difference) {
                    let bullet: BulletView = BulletView()
                    bullets.append(bullet)
                    bullet.center = CGPoint(x: CGFloat(positions[i].x), y: CGFloat(positions[i].y))
                    bullet.bounds = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
                    addSubview(bullet)
                }
            break
            case let x  where x > 0:
                for i in 0..<abs(difference) {
                    if i < bullets.count {
                        bullets[i].removeFromSuperview()
                        bullets.removeFirst()
                    }
                    
                }
            break
            default:
                for i in 0..<positions.count {
                    bullets[i].center = CGPoint(x: CGFloat(positions[i].x), y: CGFloat(positions[i].y))
                    bullets[i].bounds = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
                }
            break
        }
    }
    
    private func spawnAsteroids(withSize: String, atIndex: Int, for positionList: [AsteroidObject]) {
        switch withSize {
            case "large":
                if let asteroidLarge = asteroids[withSize]?[atIndex] as? AsteroidLarge {
                    let x = CGFloat(positionList[atIndex].position.x)
                    let y = CGFloat(positionList[atIndex].position.y)
                    asteroidLarge.center = CGPoint(x: x, y: y)
                    asteroidLarge.bounds = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
                    asteroidLarge.contentMode = .redraw
                    asteroidLarge.transform = CGAffineTransform(rotationAngle: CGFloat((delegate?.gameView(getAngleForAsteroiFor: withSize, at: atIndex))!))
                }
            case "medium":
                if let asteroidMedium = asteroids[withSize]?[atIndex] as? AsteroidMedium {
                    asteroidMedium.contentMode = .redraw
                    let x = CGFloat(positionList[atIndex].position.x)
                    let y = CGFloat(positionList[atIndex].position.y)
                    asteroidMedium.center = CGPoint(x: x, y: y)
                    asteroidMedium.bounds = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
                    asteroidMedium.contentMode = .redraw
                    asteroidMedium.transform = CGAffineTransform(rotationAngle: CGFloat((delegate?.gameView(getAngleForAsteroiFor: withSize, at: atIndex))!))
                }
            case "small":
                if let asteroidSmall = asteroids[withSize]?[atIndex] as? AsteroidSmall {
                    asteroidSmall.contentMode = .redraw
                    let x = CGFloat(positionList[atIndex].position.x)
                    let y = CGFloat(positionList[atIndex].position.y)
                    asteroidSmall.center = CGPoint(x: x, y: y)
                    asteroidSmall.bounds = CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0)
                    asteroidSmall.contentMode = .redraw
                    asteroidSmall.transform = CGAffineTransform(rotationAngle: CGFloat((delegate?.gameView(getAngleForAsteroiFor: withSize, at: atIndex))!))
                }
            default:
                return
            }
    }
    
    func setScoreLabel(with score: String) {
        scoreLabel.text = score
    }
    
    func setLivesLabel(with livesString: String) {
        livesLabel.text = livesString
    }
    
    func removeShip() {
        explosionView.center = CGPoint(x: shipView.frame.origin.x, y: shipView.frame.origin.y)
        explosionView.bounds = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        explosionView.isHidden = false
        shipRespawned = true
        respawnedAt = Date()
    }
    
    func removeAsteroid(key: String, index: Int) {
        switch key {
        case "large":
//            let i = (index == asteroids[key]?.count) ? index - 1: index
            if index <= asteroids[key]!.count - 1 {
                (asteroids[key]?[index] as? AsteroidLarge)?.removeFromSuperview()
                asteroids[key]?.remove(at: index)
            }
            break
        case "medium":
//            let i = (index == asteroids[key]?.count) ? index - 1: index
            if index <= asteroids[key]!.count - 1 {
                (asteroids[key]?[index] as? AsteroidMedium)?.removeFromSuperview()
                asteroids[key]?.remove(at: index)
            }
            break
        case "small":
//            let i = (index == asteroids[key]?.count) ? index - 1: index
            if index <= asteroids[key]!.count - 1 {
                (asteroids[key]?[index] as? AsteroidSmall)?.removeFromSuperview()
                asteroids[key]?.remove(at: index)
            }
            break
        default:
            break
        }
    }
    
    func beginTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true, block: { _ in
            self.updateUI()
        })
    }
    
    @objc func rotateShipLeftPressed(sender: Any) {
        if let button = sender as? UIButton {
            if button == rotateLeftButton {
                delegate?.gameView(rotateLeftPressed: self, rotating: true)
            }
        }
    }
    
    @objc func rotateShipLeftReleased(sender: Any) {
        if let button = sender as? UIButton {
            if button == rotateLeftButton {
                delegate?.gameView(rotateLeftPressed: self, rotating: false)
            }
        }
    }
    
    @objc func rotateShipRightPressed(sender: Any) {
        if let button = sender as? UIButton {
            if button == rotateRightButton {
                delegate?.gameView(rotateRightPressed: self, rotating: true)
            }
        }
    }
    
    @objc func rotateShipRightReleased(sender: Any) {
        if let button = sender as? UIButton {
            if button == rotateRightButton {
                delegate?.gameView(rotateRightPressed: self, rotating: false)
            }
        }
    }
    
    @objc func thrusterPressed(sender: Any) {
        if let button = sender as? UIButton {
            if button == thrustButton {
                guard let delegate = delegate else { return }
                shipView.thrustersOn = true
                shipView.reloadData()
                delegate.gameView(thrusterPressed: self, thrusterOn: true)
            }
        }
    }
    
    @objc func thrusterReleased(sender: Any) {
        if let button = sender as? UIButton {
            if button == thrustButton {
                guard let delegate = delegate else { return }
                shipView.thrustersOn = false
                shipView.reloadData()
                delegate.gameView(thrusterPressed: self, thrusterOn: false)
            }
        }
    }
    
    @objc func shootButtonPressed(sender: Any) {
        if let button = sender as? UIButton {
            if button == shootButton {
                guard let delegate = delegate else { return }
                delegate.gameView(shootButtonToggled: self, fireProjectile: true)
            }
        }
    }
    
    @objc func shootButtonReleased(sender: Any) {
        if let button = sender as? UIButton {
            if button == shootButton {
                guard let delegate = delegate else { return }
                delegate.gameView(shootButtonToggled: self, fireProjectile: false)
            }
        }
    }
    
    @objc func returnHomeButtonPressed(sender: Any) {
        if let button = sender as? UIButton {
            if button == returnHomeButton {
                guard let delegate = delegate else { return }
                delegate.gameView(homeButtonPressed: self)
            }
        }
    }
    
    func updateUI() {
        
        guard let delegate = delegate else { return }
        let shipPoint = delegate.gameView(getPositionForShipIn: self)
        
//        let x = CGFloat(shipPoint.x) * bounds.width
//        let y = CGFloat(shipPoint.y) * 0.5 * bounds.height
        
//        shipView.center = CGPoint(x: x, y: y)
        if shipRespawned {
            let now: Date = Date()
            let elapsed: TimeInterval = now.timeIntervalSince(respawnedAt)
//            self.lastDate = now
            if elapsed < 3.0 {
                explosionView.setNeedsDisplay()
            }
            else {
                shipRespawned = false
                explosionView.isHidden = true
            }
        }
        
        shipView.center = CGPoint(x: CGFloat(shipPoint.x), y: CGFloat(shipPoint.y))
        shipView.bounds = CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0)
        shipView.transform = CGAffineTransform(rotationAngle: CGFloat(delegate.gameView(getAngleForShipIn: self)))
        shipView.reloadData()
        asteroidPositions()
        bulletPositions()
        
        bringSubviewToFront(controlStackView)
        bringSubviewToFront(rotateButtonsStackView)
        bringSubviewToFront(gameLabelStackView)
        // -game.width * 0.5 -> game.width * 0.5
        // xview = (xmodel + game.width * 0.5) / game.width * view.bounds.width
        // yview = (ymodel + 1) * 0.5 * height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
//        guard let shipPoint = delegate?.gameView(getPositionForShipIn: self) else { return }
//        shipView.frame = CGRect(x: shipPoint.x, y: shipPoint.y, width: 25.0, height: 25.0)
        setNeedsDisplay()
    }
}
