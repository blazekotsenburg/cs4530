//
//  HomeView.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/24/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol HomeViewDelegate {
    func homeView(newGameFor homeView: HomeView)
}

class HomeView: UIView {
    
    var tableView: UITableView
    private var titleLabel: UILabel
    private var newGameButton: UIButton
    
    var delegate: HomeViewDelegate!
    
    override init(frame: CGRect) {
        tableView = UITableView()
        titleLabel = UILabel()
        newGameButton = UIButton()
        super.init(frame: frame)
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        newGameButton.addTarget(self, action: #selector(newGameButtonClicked), for: .touchUpInside)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        
//        backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.333, alpha: 1.0)
        backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
    }
    
    override func draw(_ rect: CGRect) {
//        tableView = UITableView(frame: CGRect(x: frame.width / 2.0, y: frame.height / 2.0, width: frame.width, height: frame.height * 0.333))
        tableView.frame.origin.x -= tableView.frame.width / 2.0
        tableView.frame.origin.y -= tableView.frame.height / 2.0
        tableView.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.333, alpha: 1.0)
        tableView.rowHeight = 80.0
        addSubview(tableView)
        
        titleLabel.text = "Battle Ship"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Avenir", size: 22)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        newGameButton.setTitle("New Game", for: .normal)
        addSubview(newGameButton)
        
        let views = ["tableView": tableView, "titleLabel": titleLabel, "newGameButton": newGameButton]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]-20-[tableView]-20-[newGameButton]-14-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[tableView]-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(frame.width * 0.15))-[newGameButton]-(\(frame.width * 0.15))-|", options: [], metrics: nil, views: views))
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
    
    @objc func newGameButtonClicked() {
        delegate.homeView(newGameFor: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
