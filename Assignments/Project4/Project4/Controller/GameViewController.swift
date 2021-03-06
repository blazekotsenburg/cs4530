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
    var battleShip: BattleShip = BattleShip()
    var gameIndex: Int = 0
    var playerId: String = ""
    var guid: String = ""
    var status: String = ""
    var gameDetailTimer: Timer = Timer()
    var isYourTurn: Bool = Bool()
    var gameOver: Bool = false
    
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
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
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
            let gamesWebURL: URL = URL(string: "http://174.23.151.160:2142/api/games/\(guid)")!
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
                            
                            var launchStatus: String
                            switch(shipSunk) {
                                case 5:
                                    launchStatus = "CARRIER SANK!"
                                    break
                                case 4:
                                    launchStatus = "BATTLESHIP SANK!"
                                    break
                                case 3:
                                    launchStatus = "SUBMARINE SANK!" //Consider adding some means of determining whether sub or cruiser sank
                                    break
                                case 2:
                                    launchStatus = "DESTROYER SANK!"
                                    break
                                default:
                                    launchStatus = ""
                            }
                            
                            var status: String = ""
                            if hit {
                                if !launchStatus.isEmpty {
                                    status = launchStatus
                                }
                                else {
                                    status = "HIT!"
                                }
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
        //TODO: - Need to set up switch player view accoridingly now
        present(switchPlayerViewController, animated: true, completion: nil) // switch view controller after a player takes their turn
    }
    
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
        let webURL: URL = URL(string: "http://174.23.151.160:2142/api/games/\(guid)/boards?playerId=\(playerId)")!
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
        let webURL: URL = URL(string: "http://174.23.151.160:2142/api/games/\(guid)?playerId=\(playerId)")!
        let whosTurnTask = URLSession.shared.dataTask(with: webURL) { [weak self] (data, response, error) in
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
                    print("Network Error: Game turns")
                    return
            }
            if let turnDetailData = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DispatchQueue.main.async {
                    if turnDetailData["isYourTurn"] as! Bool{
                        self?.gameDetailTimer.invalidate()
                        self?.isYourTurn = true
                        self?.loadBattleshipBoards()
                        self?.gameView.opponentLabel.text = "Your Turn!"
                        self?.gameView.reloadData()
                    }
                    else {
                        self?.gameView.opponentLabel.text = "Opponents Turn!"
                        self?.gameView.reloadData()
                    }
                    if turnDetailData["winner"] as! String != "IN_PROGRESS" {
                        if !(self?.gameOver)! {
                            self?.gameOver = true
                            self?.isYourTurn = false
                            self?.gameDetailTimer.invalidate()
                            let switchPlayerViewController: SwitchPlayerViewController = SwitchPlayerViewController()
                            if let winnerName = turnDetailData["winner"] as? String {
                                switchPlayerViewController.status = "\(winnerName) WINS!"
                            }
                            self?.present(switchPlayerViewController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        whosTurnTask.resume()
    }
}

