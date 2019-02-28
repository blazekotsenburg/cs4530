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
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
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
        let color = UIColor(red: 0.25, green: 0.25, blue: 0.333, alpha: 1.0)
//        let color = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        cell.backgroundColor = color
        cell.textLabel?.text = "hello, world: \(indexPath.row)"
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.text = "existing game"
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Cell clicked to load game")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func homeView(newGameFor homeView: HomeView) {
        present(GameViewController(), animated: true, completion: nil)
    }
    
    func homeView(loadDataFor homeView: HomeView) {
        
    }
}
