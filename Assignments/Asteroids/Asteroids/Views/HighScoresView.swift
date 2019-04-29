//
//  HighScoresView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol HighScoresViewDelegate {
    func highScoresView(backButtonPressedFor highScoresView: HighScoresView)
}

class HighScoresView: UIView {
    
    var tableView: UITableView
    private var backButton: UIButton
    
    var delegate: HighScoresViewDelegate?
    
    override init(frame: CGRect) {
        tableView = UITableView()
        backButton = UIButton()
        super.init(frame: frame)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "galaxy_background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        insertSubview(backgroundImage, at: 0)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        tableView.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.333, alpha: 0.7)
        tableView.layer.cornerRadius = 5.0
        
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.textColor = .white
        backButton.titleLabel?.font = UIFont(name: "EarthOrbiter", size: 24.0)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tableView)
        addSubview(backButton)
    }
    
    @objc func backButtonPressed(sender: Any) {
        if let _ = sender as? UIButton {
            delegate?.highScoresView(backButtonPressedFor: self)
        }
    }
    
    override func draw(_ rect: CGRect) {
        tableView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
        tableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.85).isActive = true
        tableView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15.0).isActive = true
        backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15.0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
    
    func reloadTableViewData() {
        tableView.reloadData()
    }
}
