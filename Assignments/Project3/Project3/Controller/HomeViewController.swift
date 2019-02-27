//
//  HomeViewController.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/24/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeViewDelegate {
    
    var homeView: HomeView {
        return view as! HomeView
    }
    
    //MARK: Override functions
    override func loadView() {
        view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.delegate = self
//        print(homeView.frame)
//        print(view.frame)
//        let tableView: UITableView = UITableView(frame: self.view.frame)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
//        
//        let views: [String: Any] = ["tableView": tableView]
//
//        homeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[tableView]-|", options: [], metrics: nil, views: views))
//        homeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[tableView]-|", options: [], metrics: nil, views: views))
//        homeView.addSubview(tableView)
    }
    
    //MARK: UITableView Delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self)) as? TableViewCell else {
            fatalError("Coulod not dequeue reusable cell of type: \(TableViewCell.self)")
        }
        _ = cell.increment
        // this is where you can actually customize a cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let color = UIColor(hue: CGFloat(indexPath.row) / 42.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        cell.backgroundColor = color
        cell.textLabel?.text = "hello, world: \(indexPath.row)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 42
    }
    
    func homeView(loadDataFor homeView: HomeView) {
        
    }
}
