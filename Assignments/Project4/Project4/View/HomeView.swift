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
    func homeView(filterGamesFor homeView: HomeView, index: Int)
}

class HomeView: UIView {
    
    var tableView: UITableView
    private var titleLabel: UILabel
    private var newGameButton: UIButton
    var segmentedControl: UISegmentedControl
    
    var delegate: HomeViewDelegate!
    
    override init(frame: CGRect) {
        tableView = UITableView()
        titleLabel = UILabel()
        newGameButton = UIButton()
        segmentedControl = UISegmentedControl()
        super.init(frame: frame)
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        newGameButton.addTarget(self, action: #selector(newGameButtonClicked), for: .touchUpInside)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.addTarget(self, action: #selector(updateGameFilter), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Waiting", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Playing", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Done", at: 2, animated: true)
        segmentedControl.insertSegment(withTitle: "My Games", at: 3, animated: true)
        addSubview(segmentedControl)
//        backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.333, alpha: 1.0)
        backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
    }
    
    override func draw(_ rect: CGRect) {
//        tableView = UITableView(frame: CGRect(x: frame.width / 2.0, y: frame.height / 2.0, width: frame.width, height: frame.height * 0.333))
        tableView.frame.origin.x -= tableView.frame.width / 2.0
        tableView.frame.origin.y -= tableView.frame.height / 2.0
        tableView.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.333, alpha: 1.0)
        tableView.rowHeight = 80.0
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.borderWidth = 2.0
        addSubview(tableView)
        
        titleLabel.text = "Battle Ship"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Avenir", size: 22)
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .black
        titleLabel.layer.borderWidth = 2.0
        titleLabel.layer.borderColor = UIColor.white.cgColor
        addSubview(titleLabel)
        
        newGameButton.setTitle("New Game", for: .normal)
        newGameButton.titleLabel!.font = UIFont(name: "Avenir", size: 22)
        newGameButton.backgroundColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        newGameButton.layer.borderColor = UIColor.white.cgColor
        newGameButton.layer.borderWidth = 2.0
        addSubview(newGameButton)
        
        segmentedControl.backgroundColor = .black
        segmentedControl.tintColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        
        let views = ["tableView": tableView, "titleLabel": titleLabel, "newGameButton": newGameButton, "segControl": segmentedControl]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[segControl]-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[titleLabel]-20-[segControl]-10-[tableView]-20-[newGameButton]-14-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[tableView]-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(frame.width * 0.15))-[newGameButton]-(\(frame.width * 0.15))-|", options: [], metrics: nil, views: views))
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
    
    @objc func newGameButtonClicked() {
        delegate.homeView(newGameFor: self)
    }
    
    @objc func updateGameFilter() {
        delegate.homeView(filterGamesFor: self, index: segmentedControl.selectedSegmentIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
