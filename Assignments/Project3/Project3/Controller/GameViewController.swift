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
    var battleShip: BattleShip?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        battleShip?.delegate = self
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
        gameView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameView.delegate = self
        battleShip?.delegate = self
        gameView.reloadData()
        gameView.translatesAutoresizingMaskIntoConstraints = false
    }

    //MARK: - GameViewDelegate Methods
    func gameView(_ gameView: GameView, currentPlayerTokenFor row: Int, and col: Int) -> String{ //the gameView doesn't update on a turn taken fast enough. consider a way to display a hit for opponnent board and then transitioning to the other viewcontroller.
        let currPlayer = battleShip?.currentPlayer
        var cell: String = ""
//        if currPlayer == .p1 { // since the currPlayer gets updated after initial touch, this is updating the board for the wrong person.
//            if let token = battleShip?.boardMap[.p2]?[row][col] { // this is broken still
//                switch(token) {
//                    case .hit:  cell = "🔥"
//                    case .miss: cell = "💧"
//                    default:    cell = ""
//                }
//            }
//        }
//        else {
//            if let token = battleShip?.boardMap[.p1]?[row][col] {
//                switch(token) {
//                    case .hit:  cell = "🔥"
//                    case .miss: cell = "💧"
//                    default:    cell = ""
//                }
//            }
//        }
        
        if let token = battleShip?.boardMap[currPlayer!]?[row][col] { // this is broken still
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
        
        let currPlayer = battleShip?.currentPlayer
        var cell: String = ""
                if currPlayer == .p1 { // since the currPlayer gets updated after initial touch, this is updating the board for the wrong person.
                    if let token = battleShip?.boardMap[.p2]?[row][col] { // this is broken still
                        switch(token) {
                            case .hit:  cell = "🔥"
                            case .miss: cell = "💧"
                            default:    cell = ""
                        }
                    }
                }
                else {
                    if let token = battleShip?.boardMap[.p1]?[row][col] {
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
        battleShip?.takeTurn(at: row, and: col)
    }
    
    func battleShip(_ battleShip: BattleShip, cellChangedAt row: Int, and col: Int) {
//        gameView.reloadData()
        let switchPlayerViewController = SwitchPlayerViewController()
        switchPlayerViewController.currGame = battleShip
        switchPlayerViewController.gamesList = gamesList
        present(switchPlayerViewController, animated: true, completion: nil) // switch view controller after a player takes their turn
    }
}

