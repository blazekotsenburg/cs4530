//
//  HighScoresView.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol HighScoresViewDelegate {
    
}

class HighScoresView: UIView {
    
    var tableView: UITableView
    
    var delegate: HighScoresViewDelegate?
    
    override init(frame: CGRect) {
        tableView = UITableView()
        super.init(frame: frame)
        
        backgroundColor = .cyan
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        addSubview(tableView)
    }
    
    override func draw(_ rect: CGRect) {
        tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30.0).isActive = true
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60.0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60.0).isActive = true
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
