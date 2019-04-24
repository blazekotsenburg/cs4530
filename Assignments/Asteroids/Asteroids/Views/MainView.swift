//
//  MainView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol MainViewDelegate {
    func mainView(presentHighScoresFor mainView: MainView)
    func mainView(presentGameViewFor mainView: MainView)
}

class MainView: UIView {
    
    private var logoLabel: UILabel
    private var gameButton: UIButton
    private var highScoreButton: UIButton
    private var stackView: UIStackView
    private var views: [String: Any]
    
    var delegate: MainViewDelegate?
    
    override init(frame: CGRect) {
        logoLabel = UILabel()
        gameButton = UIButton()
        highScoreButton = UIButton()
        stackView = UIStackView()
        views = ["gameButton": gameButton, "highScoreButton": highScoreButton]
        super.init(frame: frame)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "galaxy_background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        insertSubview(backgroundImage, at: 0)
        
        logoLabel.text = "ASTEROIDS"
        logoLabel.font = UIFont(name: "EarthOrbiter", size: 56.0)
        logoLabel.textColor = UIColor(red: 1.0, green: 0.47, blue: 0.74, alpha: 1.0)
        logoLabel.textAlignment = .center
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        addSubview(logoLabel)
        
        gameButton.addTarget(self, action: #selector(homeViewButtonPressed), for: .touchUpInside)
        highScoreButton.addTarget(self, action: #selector(homeViewButtonPressed), for: .touchUpInside)
        addSubview(stackView)
        stackView.addArrangedSubview(gameButton)
        stackView.addArrangedSubview(highScoreButton)
        
        gameButton.translatesAutoresizingMaskIntoConstraints = false
        highScoreButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 25.0
        
        //For all earth orbiter fonts view: https://www.dafont.com/earth-orbiter.font
        gameButton.setTitle("New Game", for: .normal)
        gameButton.titleLabel?.font = UIFont(name: "EarthOrbiter", size: 20.0)
        gameButton.backgroundColor = .black
        gameButton.layer.borderColor = UIColor.cyan.cgColor
        gameButton.layer.borderWidth = 2.0
        
        highScoreButton.setTitle("High Scores", for: .normal)
        highScoreButton.titleLabel?.font = UIFont(name: "EarthOrbiter", size: 20.0)
        highScoreButton.backgroundColor = .black
        highScoreButton.layer.borderColor = UIColor.cyan.cgColor
        highScoreButton.layer.borderWidth = 2.0
    }
    
    override func draw(_ rect: CGRect) {
        logoLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50.0).isActive = true
        
        //consider making this centered with a width of half the screen
        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 100.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -100.0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[gameButton]-50-|", options: [], metrics: nil, views: views))
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[highScoreButton]-30-|", options: [], metrics: nil, views: views))
    }
    
    @objc func homeViewButtonPressed(sender: Any) {
        if let button = sender as? UIButton {
            if button == gameButton {
                delegate?.mainView(presentGameViewFor: self)
            }
            else if button == highScoreButton {
                delegate?.mainView(presentHighScoresFor: self)
            }
        }
    }
    
    func setGameButtonText(with text: String) {
        gameButton.setTitle(text, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
}
