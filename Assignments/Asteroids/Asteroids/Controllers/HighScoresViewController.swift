//
//  HighScoresViewController.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class HighScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HighScoresViewDelegate {
    
    private var highScores: [HighScores] = []
    
    var highScoresView: HighScoresView {
        return view as! HighScoresView
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        highScores = (UserDefaults.standard.array(forKey: "highScores") as! [(name: String, score: Int)])
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        highScores = loadSavedScores()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        highScoresView.tableView.reloadData()
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
        let color = UIColor.clear
        cell.textLabel?.font = UIFont(name: "EarthOrbiter", size: 20)
        cell.textLabel?.textColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        cell.detailTextLabel?.font = UIFont(name: "EarthOrbiter", size: 14)
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
        if !highScores.isEmpty {
            if highScores.count - 1 >= indexPath.row {
                cell.textLabel?.text = "\(indexPath.row + 1)\(placement) \(highScores[indexPath.row].name)"
                cell.detailTextLabel?.text = highScores[indexPath.row].score.description
            }
            else {
                cell.textLabel?.text = "\(indexPath.row + 1)\(placement)"
                cell.detailTextLabel?.text = "N/A"
            }
        }
        else {
            cell.textLabel?.text = "\(indexPath.row + 1)\(placement)"
            cell.detailTextLabel?.text = "N/A"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10.0
    }
    
    func loadSavedScores() -> [HighScores] {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonData = try! Data(contentsOf: docDirectory.appendingPathComponent(Constants.highScoresFile))
        let highScores = try! JSONDecoder().decode([HighScores].self, from: jsonData)
        return highScores
    }
}
