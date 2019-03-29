//
//  NewGameView.swift
//  Project4
//
//  Created by Blaze Kotsenburg on 3/21/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol NewGameViewDelegate {
    func newGameView(createGameFor newGameView: NewGameView)
    func newGameView(exitGameViewFor newGameView: NewGameView)
}

class NewGameView: UIView {
    var gameNameLabel: UILabel = UILabel()
    var playerNameLabel: UILabel = UILabel()
    var gameNameTextField: UITextField = UITextField()
    var playerNameTextField: UITextField = UITextField()
    var submitButton: UIButton = UIButton()
    var backButton: UIButton = UIButton()
    var stackView: UIStackView = UIStackView()
    
    var delegate: NewGameViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        
        gameNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        gameNameTextField.translatesAutoresizingMaskIntoConstraints = false
        playerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        //should constraints be done inside draw?
//        addSubview(gameNameTextField)
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12.0).isActive = true
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 10.0
        
        addSubview(gameNameLabel)
        gameNameLabel.text = "Game Name"
        gameNameLabel.font = UIFont(name: "Avenir", size: 18.0)
        gameNameLabel.textColor = .white
        
        addSubview(gameNameTextField)
        gameNameTextField.placeholder = "eg. Enemy Seas"
        gameNameTextField.textColor = .black
        gameNameTextField.font = UIFont(name: "Avenir", size: 14.0)
        gameNameTextField.backgroundColor = .lightGray
        gameNameTextField.returnKeyType = .done
        gameNameTextField.addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
        
        addSubview(playerNameLabel)
        playerNameLabel.text = "Player Name"
        playerNameLabel.font = UIFont(name: "Avenir", size: 18.0)
        playerNameLabel.textColor = .white
        
        addSubview(playerNameTextField)
        playerNameTextField.placeholder = "eg. Captain"
        playerNameTextField.textColor = .black
        playerNameTextField.font = UIFont(name: "Avenir", size: 14.0)
        playerNameTextField.backgroundColor = .lightGray
        playerNameTextField.returnKeyType = .done
        playerNameTextField.addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
        
        addSubview(submitButton)
        submitButton.setTitle("Create Game", for: .normal)
        submitButton.backgroundColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        
        let views: [String: Any] = ["gameNameLabel": gameNameLabel, "gameNameField": gameNameTextField,
                                    "playerNameLabel": playerNameLabel, "playerNameField": playerNameTextField,
                                    "submitButton": submitButton]
        
        stackView.addArrangedSubview(gameNameLabel)
        stackView.addArrangedSubview(gameNameTextField)
        stackView.addArrangedSubview(playerNameLabel)
        stackView.addArrangedSubview(playerNameTextField)
        stackView.addArrangedSubview(submitButton)
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[gameNameLabel]-|", options: [], metrics: nil, views: views))
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[gameNameField]-|", options: [], metrics: nil, views: views))
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[playerNameLabel]-|", options: [], metrics: nil, views: views))
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[playerNameField]-|", options: [], metrics: nil, views: views))
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[submitButton]-20-|", options: [], metrics: nil, views: views))
        
        backButton.setTitle("← Back", for: .normal)
        backButton.titleLabel!.font = UIFont(name: "Avenir", size: 18)
        addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12.0)
        backButton.widthAnchor.constraint(lessThanOrEqualToConstant: 80.0)
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
    
    @objc func dismissKeyboard(sender: Any) {
        if let textField = sender as? UITextField {
            if textField == gameNameTextField || textField == playerNameTextField{
                textField.resignFirstResponder()
            }
        }
    }
    
    @objc func submitButtonPressed(sender: Any) {
        if let _ = sender as? UIButton {
            delegate?.newGameView(createGameFor: self)
        }
    }
    
    @objc func backButtonPressed(sender: Any) {
        if let _ = sender as? UIButton {
            delegate?.newGameView(exitGameViewFor: self)
        }
    }
}
