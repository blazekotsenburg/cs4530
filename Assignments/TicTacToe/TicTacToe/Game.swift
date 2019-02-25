//
//  Game.swift
//  TicTacToe
//
//  Created by Blaze Kotsenburg on 2/20/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

protocol Board {
    
}

class Game {
    enum Token {
        case none
        case red
        case blue
    }
    
    var board: [[Token]] = [[.none, .none, .none],
                            [.none, .none, .none],
                            [.none, .none, .none]]
    var currentPlayer: Token = .red
    var winner: Token = .none
    
    func takeTurn(at col: Int, and row: Int) {
        //TODO:Prevent current cells from being used
        if board[col][row] == .none {
            board[col][row] = currentPlayer
            if currentPlayer == .red {
                currentPlayer = .blue
            }
            else {
                currentPlayer = .red
            }
        }
        
    }
}
