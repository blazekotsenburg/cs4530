//
//  HomeViewController.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/24/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeViewDelegate {
    
    var gamesList: [BattleShip] = []
    
    var homeView: HomeView {
        return view as! HomeView
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !UserDefaults.standard.bool(forKey: "hasLoggedInBefore") {
            UserDefaults.standard.set(true, forKey: "hasLoggedInBefore")
            saveGameState()
        }
        else {
            loadSavedGames()
        }
    }
    
    //MARK: UITableView Delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        cell.textLabel?.font = UIFont(name: "Avenir", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 14)
        cell.backgroundColor = color

        if gamesList.count > 0 {
            if gamesList[indexPath.row].winner == .none {
                cell.textLabel?.text = "In Progress"
                cell.textLabel?.textColor = UIColor(red: 0.99, green: 0.38, blue: 0.38, alpha: 1.0)
//                cell.backgroundColor = UIColor(red: 0.53, green: 0.88, blue: 0.91, alpha: 1.0)
            }
            else {
                cell.textLabel?.textColor = UIColor(red: 0.35, green: 0.99, blue: 0.35, alpha: 1.0)
                cell.textLabel?.text = gamesList[indexPath.row].winner == .p1 ? "Winner:\nP1" : "Winner:\nP2"
//                0.53 green:0.91 blue:0.76
//                cell.backgroundColor = UIColor(red: 0.53, green: 0.91, blue: 0.88, alpha: 1.0)
            }
            if let p1Ships = gamesList[indexPath.row].shipHitPoints[.p1], let p2Ships = gamesList[indexPath.row].shipHitPoints[.p2] {
                cell.detailTextLabel?.textColor = .white
                cell.detailTextLabel?.text = "P1 Ships: \(p1Ships.count)  P2 Ships: \(p2Ships.count)"
            }
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameViewController: GameViewController = GameViewController()
        // New instance of BattleShip game
        let battleShip: BattleShip = gamesList[indexPath.row]
        // Initialize new GameViewControllers model to new BattleShip model
        gameViewController.battleShip = battleShip
        // Append games list with new instance of Battleship (will need to eventually make sure that this instance gets updated between all gamesLists)
        gameViewController.gameIndex = indexPath.row
        gameViewController.gamesList = gamesList
        present(gameViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            gamesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            saveGameState()
        }
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func homeView(newGameFor homeView: HomeView) {
        // Initialize a new GameViewController which will be initialized with a new BattleShip Game
        let gameViewController: GameViewController = GameViewController()
        // New instance of BattleShip game
        let battleShip: BattleShip = BattleShip()
        // Initialize new GameViewControllers model to new BattleShip model
        gameViewController.battleShip = battleShip
        // Append games list with new instance of Battleship (will need to eventually make sure that this instance gets updated between all gamesLists)
        gamesList.insert(battleShip, at: 0)
        gameViewController.gameIndex = 0
        gameViewController.gamesList = gamesList
        present(gameViewController, animated: true, completion: nil)
    }
    
    func saveGameState() {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        do {
            try gamesList.save(to: docDirectory.appendingPathComponent(Constants.battleShipListFile))
        } catch let error where error is BattleShip.Error {
            print(error)
        } catch {
            print(error)
        }
    }
    
    func loadSavedGames() {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonData = try! Data(contentsOf: docDirectory.appendingPathComponent(Constants.battleShipListFile))
        gamesList = try! JSONDecoder().decode([BattleShip].self, from: jsonData)
    }
}
