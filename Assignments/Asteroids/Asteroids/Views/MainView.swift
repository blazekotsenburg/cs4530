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
    
    private var logoImageView: UIImageView
    private var gameButton: UIButton
    private var highScoreButton: UIButton
    private var stackView: UIStackView
    private var views: [String: Any]
    
    var delegate: MainViewDelegate?
    
    override init(frame: CGRect) {
        logoImageView = UIImageView()
        gameButton = UIButton()
        highScoreButton = UIButton()
        stackView = UIStackView()
        views = ["gameButton": gameButton, "highScoreButton": highScoreButton]
        super.init(frame: frame)
        
        backgroundColor = UIColor(patternImage: UIImage(named: "star_bckgnd")!)
        
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
        
        gameButton.setTitle("New Game", for: .normal)
        gameButton.titleLabel?.font = UIFont(name: "Avenir", size: 18.0)
        gameButton.backgroundColor = .cyan
        gameButton.layer.borderColor = UIColor.white.cgColor
        gameButton.layer.borderWidth = 2.0
        
        highScoreButton.setTitle("High Scores", for: .normal)
        highScoreButton.titleLabel?.font = UIFont(name: "Avenir", size: 18.0)
        highScoreButton.backgroundColor = .cyan
        highScoreButton.layer.borderColor = UIColor.white.cgColor
        highScoreButton.layer.borderWidth = 2.0
    }
    
    override func draw(_ rect: CGRect) {
        
        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
}
