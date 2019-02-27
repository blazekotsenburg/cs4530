//
//  HomeView.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/24/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol HomeViewDelegate {
    func homeView(loadDataFor homeView: HomeView)
}

class HomeView: UIView {
    
    private var tableView: UITableView
    
    var delegate: HomeViewDelegate!
    
    override init(frame: CGRect) {
        tableView = UITableView()
        super.init(frame: frame)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .blue
    }
    
    override func draw(_ rect: CGRect) {
        tableView = UITableView(frame: CGRect(x: frame.width / 2, y: frame.height / 2, width: frame.width, height: 300))
        tableView.frame.origin.x -= tableView.frame.width / 2
        tableView.frame.origin.y -= tableView.frame.height / 2
//        let views = ["tableView": tableView, "view": self]
//        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[tableView]-|", options: [], metrics: nil, views: views))
        addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
