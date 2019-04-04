//
//  HomeViewController.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/24/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeViewDelegate {
    
    var lobbyGameList: [LobbyGame] = []
    var guidDict: [String: String] = [String: String]()
    
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
        homeView.segmentedControl.selectedSegmentIndex = 0
        
        let waitingURL: URL = URL(string: "http://174.23.151.160:2142/api/lobby?status=WAITING")!
        let task = URLSession.shared.dataTask(with: waitingURL) { [weak self] (data, response, error) in
            guard error == nil else {
                fatalError("URL dataTask failed: \(error!)")
            }
            guard let data = data,
                let _ = String(bytes: data, encoding: .utf8) else {
                    fatalError("no data to work with")
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode)
                else {
                    print("Network Error")
                    return
            }
            //            print(datastring)
            self?.lobbyGameList = try! JSONDecoder().decode([LobbyGame].self, from: data)
            DispatchQueue.main.async {
                self?.homeView.tableView.reloadData()
            }
        }
        task.resume()
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let color = UIColor(red: 0.25, green: 0.25, blue: 0.333, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "Avenir", size: 14)
        cell.textLabel?.textColor = UIColor(red: 0.19, green: 0.83, blue: 0.52, alpha: 1.0)
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 14)
        cell.backgroundColor = color
        cell.textLabel?.text = lobbyGameList[indexPath.row].name
        cell.detailTextLabel?.text = lobbyGameList[indexPath.row].status
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let gameAtIndex: LobbyGame = lobbyGameList[indexPath.row]

        if gameAtIndex.status == "WAITING" {
            if guidDict[gameAtIndex.id] != nil {
                let gameViewController: GameViewController = GameViewController()
                gameViewController.guid = gameAtIndex.id
                gameViewController.playerId = guidDict[gameAtIndex.id]!
                present(gameViewController, animated: true, completion: nil)
            }
            else {
                let joinGameViewController: JoinGameViewController = JoinGameViewController()
                joinGameViewController.guid = lobbyGameList[indexPath.row].id
                joinGameViewController.guidDict = guidDict
                present(joinGameViewController, animated: true, completion: nil)
            }
        }
        else if gameAtIndex.status == "PLAYING" {
            if guidDict[gameAtIndex.id] != nil {
                let gameViewController: GameViewController = GameViewController()
                gameViewController.guid = gameAtIndex.id
                gameViewController.playerId = guidDict[gameAtIndex.id]!
                present(gameViewController, animated: true, completion: nil)
            }
            else {
                let gameDetailViewController: GameDetailViewController = GameDetailViewController()
                gameDetailViewController.guid = gameAtIndex.id
                present(gameDetailViewController, animated: true, completion: nil)
            }
        }
        else if gameAtIndex.status == "DONE" {
            if guidDict[gameAtIndex.id] != nil {
                let gameViewController: GameViewController = GameViewController()
                gameViewController.guid = gameAtIndex.id
                gameViewController.playerId = guidDict[gameAtIndex.id]!
                present(gameViewController, animated: true, completion: nil)
            }
            else {
                let gameDetailViewController: GameDetailViewController = GameDetailViewController()
                gameDetailViewController.guid = gameAtIndex.id
                present(gameDetailViewController, animated: true, completion: nil)
            }
        }
    }
    
    func homeView(newGameFor homeView: HomeView) {
        let newGameViewController: NewGameViewController = NewGameViewController()
        newGameViewController.guidDict = guidDict
        present(NewGameViewController(), animated: true, completion: nil)
    }
    
    func homeView(filterGamesFor homeView: HomeView, index: Int) {
        switch(index) {
            case 0:
                let waitingFilterURL: URL = URL(string: "http://174.23.151.160:2142/api/lobby?status=WAITING")!
                let task = URLSession.shared.dataTask(with: waitingFilterURL) { [weak self] (data, response, error) in
                    guard error == nil else {
                        fatalError("URL dataTask failed: \(error!)")
                    }
                    guard let data = data,
                        let _ = String(bytes: data, encoding: .utf8) else {
                            fatalError("no data to work with")
                    }
                    guard let response = response as? HTTPURLResponse,
                        (200...299).contains(response.statusCode)
                        else {
                            print("Network Error")
                            return
                    }
                    //            print(datastring)
                    self?.lobbyGameList = try! JSONDecoder().decode([LobbyGame].self, from: data)
                    DispatchQueue.main.async {
                        self?.homeView.tableView.reloadData()
                    }
                }
                task.resume()
                break
            case 1:
                let playingFilterURL: URL = URL(string: "http://174.23.151.160:2142/api/lobby?status=PLAYING")!
                let task = URLSession.shared.dataTask(with: playingFilterURL) { [weak self] (data, response, error) in
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
                break
            case 2:
                let doneFilterURL: URL = URL(string: "http://174.23.151.160:2142/api/lobby?status=DONE")!
                let task = URLSession.shared.dataTask(with: doneFilterURL) { [weak self] (data, response, error) in
                    guard error == nil else {
                        fatalError("URL dataTask failed: \(error!)")
                    }
                    guard let data = data,
                        let _ = String(bytes: data, encoding: .utf8) else {
                            fatalError("no data to work with")
                    }
                    guard let response = response as? HTTPURLResponse,
                        (200...299).contains(response.statusCode)
                        else {
                            print("Network Error")
                            return
                    }
                    //            print(datastring)
                    self?.lobbyGameList = try! JSONDecoder().decode([LobbyGame].self, from: data)
                    DispatchQueue.main.async {
                        self?.homeView.tableView.reloadData()
                    }
                }
                task.resume()
                break
            default:
                let doneFilterURL: URL = URL(string: "http://174.23.151.160:2142/api/lobby")!
                let task = URLSession.shared.dataTask(with: doneFilterURL) { [weak self] (data, response, error) in
                    guard error == nil else {
                        fatalError("URL dataTask failed: \(error!)")
                    }
                    guard let data = data,
                        let _ = String(bytes: data, encoding: .utf8) else {
                            fatalError("no data to work with")
                    }
                    guard let response = response as? HTTPURLResponse,
                        (200...299).contains(response.statusCode)
                        else {
                            print("Network Error")
                            return
                    }
                    //            print(datastring)
                    let guidList = try! JSONDecoder().decode([[String: String]].self, from: data)
                    DispatchQueue.main.async {
                        
                        self?.lobbyGameList = []
                        for item in guidList {
                            if self?.guidDict[item["id"]!] != nil {
                                self?.getGameDetails(for: item["id"]!)
                            }
                        }
                    }
                }
                task.resume()
                break
            }
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
    
    func getGameDetails(for guid: String) {
        let webURL: URL = URL(string: "http://174.23.151.160:2142/api/lobby/\(guid)")!
        let loadBoardTask = URLSession.shared.dataTask(with: webURL) { [weak self] (data, response, error) in
            guard error == nil else {
                fatalError("URL dataTask failed: \(error!)")
            }
            guard let data = data,
                let _ = String(bytes: data, encoding: .utf8) else {
                    fatalError("no data to work with")
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode)
                else {
                    print("Network Error")
                    return
            }
            let gameDetailData = try! JSONDecoder().decode(LobbyGame.self, from: data)
            DispatchQueue.main.async {
                self?.lobbyGameList.append(gameDetailData)
                self?.homeView.tableView.reloadData()
            }
        }
        loadBoardTask.resume()
    }
    
    func loadSavedGames() {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonData = try! Data(contentsOf: docDirectory.appendingPathComponent(Constants.gameListFile))
        guidDict = try! JSONDecoder().decode([String: String].self, from: jsonData)
    }
}
