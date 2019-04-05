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
        
        backgroundColor = .black
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        
        backButton.setTitle("←", for: .normal)
        backButton.titleLabel?.textColor = .white
        backButton.titleLabel?.font = UIFont(name: "Avenir", size: 24.0)
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
        tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60.0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60.0).isActive = true
        
        backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15.0).isActive = true
        backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15.0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
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
