//
//  HomeViewController.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/24/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeViewDelegate {
    
//    var gamesList: [BattleShip] = []
    var lobbyGameList: [LobbyGame] = []
    var guidDict: [String: String] = [String: String]()
    private var webURL: URL = URL(string: "http://174.23.159.139:2142/api/lobby")!
    
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
        
        homeView.tableView.reloadData()
        
        let task = URLSession.shared.dataTask(with: webURL) { [weak self] (data, response, error) in
            guard error == nil else {
                fatalError("URL dataTask failed: \(error!)")
            }
            guard let data = data,
                let _ = String(bytes: data, encoding: .utf8) else {
                    fatalError("no data to work with")
            }
            //            print(datastring)
            self?.lobbyGameList = try! JSONDecoder().decode([LobbyGame].self, from: data)
            DispatchQueue.main.async {
                self?.homeView.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    //MARK: UITableView Delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lobbyGameList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
        cell.textLabel?.font = UIFont(name: "Avenir", size: 14)
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 14)
        cell.backgroundColor = color
        cell.textLabel?.text = lobbyGameList[indexPath.row].name
        cell.detailTextLabel?.text = lobbyGameList[indexPath.row].status
        
//        let player = gamesList[indexPath.row].currentPlayer == .p1 ? "P1" : "P2"
//
//        if gamesList.count > 0 {
//            if gamesList[indexPath.row].winner == .none {
//                cell.textLabel?.text = "In Progress - " + player + "'s Turn"
//                cell.textLabel?.textColor = UIColor(red: 0.99, green: 0.38, blue: 0.38, alpha: 1.0)
//            }
//            else {
//                cell.textLabel?.textColor = UIColor(red: 0.35, green: 0.99, blue: 0.35, alpha: 1.0)
//                cell.textLabel?.text = gamesList[indexPath.row].winner == .p1 ? "Winner:P1" : "Winner:P2"
//            }
//            if let p1Ships = gamesList[indexPath.row].shipHitPoints[.p1], let p2Ships = gamesList[indexPath.row].shipHitPoints[.p2] {
//                cell.detailTextLabel?.textColor = .white
//                cell.detailTextLabel?.text = "P1: \(p1Ships.count)  P2: \(p2Ships.count)"
//            }
//        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let gameAtIndex: LobbyGame = lobbyGameList[indexPath.row]

        if gameAtIndex.status == "WAITING" {
            let joinGameViewController: JoinGameViewController = JoinGameViewController()
            joinGameViewController.guid = lobbyGameList[indexPath.row].id
            joinGameViewController.guidDict = guidDict
            present(joinGameViewController, animated: true, completion: nil)
        }
        else if gameAtIndex.status == "PLAYING" {
            if guidDict[gameAtIndex.id] != nil {
                let gameViewController: GameViewController = GameViewController()
                gameViewController.guid = gameAtIndex.id
                gameViewController.playerId = guidDict[gameAtIndex.id]!
                present(gameViewController, animated: true, completion: nil)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            lobbyGameList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .bottom)
//            saveGameState()
//        }
//    }
    
    func homeView(newGameFor homeView: HomeView) {
        let newGameViewController: NewGameViewController = NewGameViewController()
        newGameViewController.guidDict = guidDict
        present(NewGameViewController(), animated: true, completion: nil)
    }
    
    //This function will need to be updated to save player id's and game id's.
    func saveGameState() {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        do {
            guard let jsonData = try? JSONEncoder().encode(guidDict) else {
                throw BattleShip.Error.encoding
            }
            guard (try? jsonData.write(to: docDirectory.appendingPathComponent(Constants.gameListFile))) != nil else {
                throw BattleShip.Error.writing
            }
        } catch let error where error is BattleShip.Error {
            print(error)
        } catch {
            print(error)
        }
    }
    
    func loadSavedGames() {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonData = try! Data(contentsOf: docDirectory.appendingPathComponent(Constants.gameListFile))
        guidDict = try! JSONDecoder().decode([String: String].self, from: jsonData)
    }
}
