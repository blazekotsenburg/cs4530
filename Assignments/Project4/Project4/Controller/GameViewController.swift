//
//  ViewController.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/20/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameViewDelegate, BattleShipDelegate {
    
    //MARK: - Instance Elements
    var gamesList: [BattleShip] = []
    var battleShip: BattleShip = BattleShip()
    var gameIndex: Int = 0
    var playerId: String = ""
    var guid: String = ""
    var status: String = ""
    var gameDetailTimer: Timer = Timer()
    var isYourTurn: Bool = Bool()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        battleShip.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var gameView: GameView {
        return view as! GameView
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - UIViewController Ovrrides
    override func loadView() {
        view = GameView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        saveGameState()
        gameDetailTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { _ in
            self.turnDetailForGame()
        })
        gameView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameView.delegate = self
        battleShip.delegate = self
        loadBattleshipBoards()
        gameView.reloadData()
        gameView.translatesAutoresizingMaskIntoConstraints = false
    }

    //MARK: - GameViewDelegate Methods
    func gameView(backButtonPressedFor gameView: GameView) {
//        saveGameState()
        dismiss(animated: true, completion: nil)
    }
    
    func gameView(_ gameView: GameView, currentPlayerTokenFor row: Int, and col: Int) -> String{
        var cell: String = ""
        if let token = battleShip.boardMap[.player]?[row][col] {
                switch(token) {
                case .hit:  cell = "🔥"
                case .miss: cell = "💧"
                case .ship: cell = "🛳"
                default:    cell = ""
            }
        }
        
        return cell
    }
    
    func gameView(_ gameView: GameView, opponentTokenFor row: Int, and col: Int) -> String {
        
        var cell: String = ""
        if let token = battleShip.boardMap[.opponent]?[row][col] { // this is broken still
            switch(token) {
                case .hit:  cell = "🔥"
                case .miss: cell = "💧"
                default:    cell = ""
            }
        }
        return cell
    }
    
    func gameView(_ gameView: GameView, cellTouchedAt row: Int, and col: Int) {
        if isYourTurn {
            isYourTurn = false
            let gamesWebURL: URL = URL(string: "http://174.23.159.139:2142/api/games/\(guid)")!
            if battleShip.winner == .none {
                //            battleShip.takeTurn(at: row, and: col)
                var post: URLRequest = URLRequest(url: gamesWebURL)
                post.httpMethod = "POST"
                let dataString: [String: Any] = ["playerId": playerId, "xPos": col, "yPos": row]
                let jsonData: Data
                do {
                    jsonData = try JSONSerialization.data(withJSONObject: dataString, options: [])
                    post.httpBody = jsonData
                } catch {
                    print("Error creating JSON string.")
                    return
                }
                
                let task = URLSession.shared.dataTask(with: post) { [weak self] (data, response, error) in
                    guard error == nil else {
                        fatalError("URL has failed.")
                    }
                    
                    guard let data = data,
                        let dataString = String(bytes: data, encoding: .utf8) else {
                            fatalError("no data to work with")
                    }
                    print(dataString)
                    guard let response = response as? HTTPURLResponse,
                        (200...299).contains(response.statusCode)
                        else {
                            print("Network Error: Game turns")
                            return
                    }
                    if let missileFiredData = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async { [weak self] in
                            let hit = missileFiredData["hit"] as! Bool
                            let shipSunk = missileFiredData["shipSunk"] as! Int
                            
                            var status: String = ""
                            if hit {
                                status = "HIT!"
                            }
                            else {
                                status = "MISS!"
                            }
                            
                            self?.loadBattleshipBoards()
                            
                            self?.gameDetailTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { _ in
                                self?.turnDetailForGame()
                            })
                            
                            let switchPlayerViewController: SwitchPlayerViewController = SwitchPlayerViewController()
                            switchPlayerViewController.status = status
                            self?.present(switchPlayerViewController, animated: true, completion: nil)
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    func battleShip(_ battleShip: BattleShip, cellChangedAt row: Int, and col: Int) {
        let switchPlayerViewController = SwitchPlayerViewController()
//        switchPlayerViewController.currGame = battleShip
        gamesList[gameIndex] = battleShip // this will not always be the case, will need to save game index
        
//        saveGameState()
        present(switchPlayerViewController, animated: true, completion: nil) // switch view controller after a player takes their turn
    }
    
//    func saveGameState() {
//        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        do {
//            try gamesList.save(to: docDirectory.appendingPathComponent(Constants.gameListFile))
//        } catch let error where error is BattleShip.Error {
//            print(error)
//        } catch {
//            print(error)
//        }
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isPortrait {
            gameView.frameWidth = gameView.frame.height
            gameView.homeRectOriginX = gameView.frameWidth / 2 - gameView.homeRect.width / 2
            gameView.homeRectOriginY = gameView.opponentRect.origin.y + gameView.opponentRect.width + gameView.opponentRect.width * 0.1
            
            gameView.reloadData()
        }
        else if UIDevice.current.orientation.isLandscape {
            gameView.frameWidth = gameView.frame.width
            gameView.homeRectOriginX = gameView.opponentRect.origin.x + gameView.opponentRect.width + gameView.opponentRect.width * 0.1
            gameView.homeRectOriginY = gameView.frameWidth / 2 - gameView.homeRect.height / 2
            
            gameView.reloadData()
        }
    }
    
    func loadBattleshipBoards() {
        let webURL: URL = URL(string: "http://174.23.159.139:2142/api/games/\(guid)/boards?playerId=\(playerId)")!
        let loadBoardTask = URLSession.shared.dataTask(with: webURL) { [weak self] (data, response, error) in
            guard error == nil else {
                fatalError("URL dataTask failed: \(error!)")
            }
            guard let data = data,
                let _ = String(bytes: data, encoding: .utf8) else {
                    fatalError("no data to work with")
            }
            self?.battleShip = try! JSONDecoder().decode(BattleShip.self, from: data)
            DispatchQueue.main.async {
                self?.gameView.reloadData()
            }
        }
        loadBoardTask.resume()
    }
    
func turnDetailForGame() {
        let webURL: URL = URL(string: "http://174.23.159.139:2142/api/games/\(guid)?playerId=\(playerId)")!
        let whosTurnTask = URLSession.shared.dataTask(with: webURL) { [weak self] (data, response, error) in
            guard error == nil else {
                fatalError("URL dataTask failed: \(error!)")
            }
            guard let data = data,
                let _ = String(bytes: data, encoding: .utf8) else {
                    fatalError("no data to work with")
            }
            if let turnDetailData = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DispatchQueue.main.async {
                    if turnDetailData["isYourTurn"] as! Bool{
                        self?.gameDetailTimer.invalidate()
                        self?.isYourTurn = true
                        self?.loadBattleshipBoards()
                        self?.gameView.reloadData()
                    }
                    if turnDetailData["winner"] as! String != "IN_PROGRESS" {
                        //TODO: Handle the winner
                    }
                }
            }
        }
        whosTurnTask.resume()
    }
}

