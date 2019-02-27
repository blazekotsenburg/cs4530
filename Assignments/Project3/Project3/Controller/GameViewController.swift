//
//  ViewController.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/20/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameViewDelegate {
    
    //MARK: - Instance Elements
    var battleShip: BattleShip = BattleShip()
    
    var gameView: GameView {
        return view as! GameView
    }
    
    //MARK: - UIViewController Ovrrides
    override func loadView() {
        view = GameView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameView.delegate = self
        gameView.translatesAutoresizingMaskIntoConstraints = false
    }

    //MARK: - GameViewDelegate Methods
    func gameView(_ gameView: GameView, tokenFor player: BattleShip.Token, at row: Int, and col: Int) -> BattleShip.Token {
        return battleShip.boardMap[player]![row][col]
    }
    
    func gameView(_ gameView: GameView, cellTouchedAt row: Int, and col: Int) {
        let currPlayer = battleShip.currentPlayer
        print("Entered delegate function for player ", currPlayer)
        switch currPlayer {
        case .p2:
            if battleShip.boardMap[.p1]![row][col] != .hit && battleShip.boardMap[.p1]![row][col] != .none {
                print("hit a ship")
                print(battleShip.boardMap[.p1]![row][col])
                battleShip.shipHitPoints[.p1]![battleShip.boardMap[.p1]![row][col], default: 0] -= 1
                battleShip.boardMap[.p1]![row][col] = .hit
                if let shipHP = battleShip.shipHitPoints[.p1]![battleShip.boardMap[.p1]![row][col]] {
                    if shipHP == 0 {
                        print("Sank a ship!")
                        battleShip.shipHitPoints.removeValue(forKey: battleShip.boardMap[.p1]![row][col])
                        print(battleShip.shipHitPoints.count)
                    }
                }
                //if shipCount for ship token is == 0, sunk ship.
                //then check if that players shipHitpoints dictionary is empty, if so game over
            }
        case .p1:
            if battleShip.boardMap[.p2]![row][col] != .hit && battleShip.boardMap[.p2]![row][col] != .none {
                print("hit a ship")
                print(battleShip.boardMap[.p2]![row][col])
                battleShip.shipHitPoints[.p2]![battleShip.boardMap[.p2]![row][col], default: 0] -= 1
                battleShip.boardMap[.p2]![row][col] = .hit
                if let shipHP = battleShip.shipHitPoints[.p2]![battleShip.boardMap[.p2]![row][col]] {
                    if shipHP == 0 {
                        print("Sank a ship!")
                        battleShip.shipHitPoints.removeValue(forKey: battleShip.boardMap[.p2]![row][col])
                        print(battleShip.shipHitPoints.count)
                    }
                }
            }
        default:
            return
        }
    }
}

