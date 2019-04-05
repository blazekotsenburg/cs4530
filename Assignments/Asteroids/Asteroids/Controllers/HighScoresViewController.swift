//
//  HighScoresViewController.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class HighScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HighScoresViewDelegate {
    
    var highScoresView: HighScoresView {
        return view as! HighScoresView
    }
    
    override func loadView() {
        view = HighScoresView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScoresView.delegate = self
        highScoresView.tableView.delegate = self
        highScoresView.tableView.dataSource = self
    }
    
    func highScoresView(backButtonPressedFor highScoresView: HighScoresView) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self)) as? TableViewCell else {
            fatalError("Coulod not dequeue reusable cell of type: \(TableViewCell.self)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let color = UIColor(red: 0.25, green: 0.25, blue: 0.333, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "Avenir", size: 20)
        cell.textLabel?.textColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 14)
        cell.backgroundColor = color
        let placement: String
        switch(indexPath.row) {
            case 0:
                placement = "st"
                break
            case 1:
                placement = "nd"
                break
            case 2:
                placement = "rd"
                break
            default:
                placement = "th"
                break
        }
        cell.textLabel?.text = "\(indexPath.row)\(placement)"
        cell.detailTextLabel?.text = "N/A"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10.0
    }
}
