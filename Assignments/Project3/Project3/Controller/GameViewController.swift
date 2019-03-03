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
    
    //MARK: - UIViewController Ovrrides
    override func loadView() {
        view = GameView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("GameVC appeared")
        saveGameState()
        gameView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameView.delegate = self
        battleShip.delegate = self
        gameView.reloadData()
        gameView.translatesAutoresizingMaskIntoConstraints = false
    }

    //MARK: - GameViewDelegate Methods
    func gameView(_ gameView: GameView, currentPlayerTokenFor row: Int, and col: Int) -> String{ //the gameView doesn't update on a turn taken fast enough. consider a way to display a hit for opponnent board and then transitioning to the other viewcontroller.
        let currPlayer = battleShip.currentPlayer
        var cell: String = ""
        if let token = battleShip.boardMap[currPlayer]?[row][col] {
                switch(token) {
                case .hit:  cell = "🔥"
                case .miss: cell = "💧"
                case .ship5: cell = "5"
                case .ship4: cell = "4"
                case .ship3: cell = "3"
                case .ship2A: cell = "2"
                case .ship2B: cell = "2"
                default:    cell = ""
            }
        }
        
        return cell
    }
    
    func gameView(_ gameView: GameView, opponentTokenFor row: Int, and col: Int) -> String {
        
        let currPlayer = battleShip.currentPlayer
        var cell: String = ""
        if currPlayer == .p1 { // since the currPlayer gets updated after initial touch, this is updating the board for the wrong person.
            if let token = battleShip.boardMap[.p2]?[row][col] { // this is broken still
                switch(token) {
                    case .hit:  cell = "🔥"
                    case .miss: cell = "💧"
                    default:    cell = ""
                }
            }
        }
        else {
            if let token = battleShip.boardMap[.p1]?[row][col] {
                switch(token) {
                    case .hit:  cell = "🔥"
                    case .miss: cell = "💧"
                    default:    cell = ""
                }
            }
        }
        return cell
    }
    
    func gameView(_ gameView: GameView, cellTouchedAt row: Int, and col: Int) {
        if battleShip.winner == .none {
            battleShip.takeTurn(at: row, and: col)
        }
    }
    
    func battleShip(_ battleShip: BattleShip, cellChangedAt row: Int, and col: Int) {
        let switchPlayerViewController = SwitchPlayerViewController()
        switchPlayerViewController.currGame = battleShip
        gamesList[gameIndex] = battleShip // this will not always be the case, will need to save game index
        
        saveGameState()
        present(switchPlayerViewController, animated: true, completion: nil) // switch view controller after a player takes their turn
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isPortrait {
            gameView.frameWidth = gameView.frame.height
            gameView.homeRectOriginX = gameView.frameWidth / 2 - gameView.homeRect.width / 2
            gameView.homeRectOriginY = gameView.opponentRect.origin.y + gameView.opponentRect.width + gameView.opponentRect.width * 0.08
            
            gameView.reloadData()
        }
        else if UIDevice.current.orientation.isLandscape {
            gameView.frameWidth = gameView.frame.width
            gameView.homeRectOriginX = gameView.opponentRect.origin.x + gameView.opponentRect.width + gameView.opponentRect.width * 0.08
            gameView.homeRectOriginY = gameView.frameWidth / 2 - gameView.homeRect.height / 2
            
            gameView.reloadData()
        }
    }
}

