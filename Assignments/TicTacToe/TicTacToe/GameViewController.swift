//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Blaze Kotsenburg on 2/20/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameViewDelegate {
    func gameView(_ gameView: GameView, cellTouchedAt col: Int, and row: Int) {
        
    }
    
    
    //TODO: Define data model (an instance of game)
    //TODO: Add a loadView override that displays a GameView
    
    var game = Game()
    
    //MARK: - Instance Elements
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
        
        gameView.reloadData()
        gameView.delegate = self // in here or willAppear?
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameView.reloadData()
    }

    //MARK: - GameViewDelegate Methods
    func gameView(_ gameView: GameView, tokenFor col: Int, and row: Int) -> String {
        var token: String
        switch (game.board[col][row]) {
            case .none: token = ""
            case .red:  token = "X"
            case .blue: token = "O"
        }
        
        return token
    }
}

