//
//  BattleShip.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/20/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

class BattleShip {
    enum Token {
        case none //where board is water
        case p1   //marks position of player1 ship
        case p2   //marks position of player2 ship
        case hit  //marks a ship who has been hit
        case ship5
        case ship4
        case ship3
        case ship2A
        case ship2B
    }
    
    var winner: Token
    var currentPlayer: Token
    var boardMap: [Token : [[Token]]] = [.p1: [], .p2: []]
    var shipHitPoints: [Token: Int] = [.ship5: 0, .ship4: 0, .ship3: 0, .ship2A: 0, .ship2B: 0]
    
    init() {
        winner = .none
        currentPlayer = .p1
        initBoards()
        printMaps()
//        print(boardMap[.p1])
    }
    
    /**
     Initializes boards of enum Token for each player.
     */
    private func initBoards() {
        
        for (k, _) in boardMap {
            for _ in 0..<10 {
                boardMap[k]?.append([.none, .none, .none, .none, .none, .none, .none, .none, .none, .none])
            }
        }
        
        for (player, _) in boardMap {
            var ships: [Int] = [5, 4, 3, 2, 2]
            var shipToken: [Int: Token] = [5: .ship5, 4: .ship4, 3: .ship3, 2: .ship2A, 1: .ship2B]
            while ships.count > 0 {
                let direction: Int = Int.random(in: 1...10) % 4
                var row = Int.random(in: 0 ..< 10)
                var col = Int.random(in: 0 ..< 10)
                
                while boardMap[player]![row][col] != .none {
                    row = Int.random(in: 0 ..< 10)
                    col = Int.random(in: 0 ..< 10)
                }
                var shipCache: [(row: Int, col: Int)] = [(row, col)]
                boardMap[player]?[row][col] = shipToken[ships.count]!
                
                var moveTo: Int = 1
                var shipWasPlaced: Bool = true
                
                switch(direction) { // place ship in right direction
                    case 0:
                        while moveTo < ships.first! {
                            if col + moveTo <= 9 {
                                if let token: Token = boardMap[player]?[row][col + moveTo] {
                                    if token == .none {
                                        boardMap[player]?[row][col + moveTo] = shipToken[ships.count]!
                                        shipHitPoints[token, default: ships.first!] += 1
                                        shipCache.append((row: row, col: col + moveTo))
                                    }
                                }
                                else {
                                    for ship in shipCache {
                                        boardMap[player]?[ship.row][ship.col] = .none
                                    }
                                    shipWasPlaced = false
                                    if let token: Token = boardMap[player]?[row][col] {
                                        shipHitPoints[token] = 0
                                    }
                                    break
                                }
                            }
                            else{
                                for ship in shipCache {
                                    boardMap[player]?[ship.row][ship.col] = .none
                                }
                                shipWasPlaced = false
                                if let token: Token = boardMap[player]?[row][col] {
                                    shipHitPoints[token] = 0
                                }
                                break
                            }
                            moveTo += 1
                        }
                        if shipWasPlaced {
                            ships.removeFirst()
                        }
                        break
                    
                    case 2: // place ship in left direction
                        while moveTo < ships.first! {
                            if col - moveTo >= 0 {
                                if let token = boardMap[player]?[row][col - moveTo] {
                                    if token == .none {
                                        boardMap[player]?[row][col - moveTo] = shipToken[ships.count]!
                                        shipHitPoints[token, default: ships.first!] += 1
                                        shipCache.append((row: row, col: col - moveTo))
                                    }
                                }
                                else {
                                    for ship in shipCache {
                                        boardMap[player]?[ship.row][ship.col] = .none
                                    }
                                    shipWasPlaced = false
                                    if let token: Token = boardMap[player]?[row][col] {
                                        shipHitPoints[token] = 0
                                    }
                                    break
                                }
                            }
                            else{
                                for ship in shipCache {
                                    boardMap[player]?[ship.row][ship.col] = .none
                                }
                                shipWasPlaced = false
                                if let token: Token = boardMap[player]?[row][col] {
                                    shipHitPoints[token] = 0
                                }
                                break
                            }
                            moveTo += 1
                        }
                        if shipWasPlaced {
                            ships.removeFirst()
                        }
                        break
                    
                    case 3: // place ship in downward direction
                        while moveTo < ships.first! {
                            if row + moveTo <= 9 {
                                if let token: Token = boardMap[player]?[row + moveTo][col] {
                                    if token == .none {
                                        boardMap[player]?[row + moveTo][col] = shipToken[ships.count]!
                                        shipCache.append((row: row + moveTo, col: col))
                                    }
                                }
                                else {
                                    for ship in shipCache {
                                        boardMap[player]?[ship.row][ship.col] = .none
                                    }
                                    shipWasPlaced = false
                                    if let token: Token = boardMap[player]?[row][col] {
                                        shipHitPoints[token] = 0
                                    }
                                    break
                                }
                            }
                            else{
                                for ship in shipCache {
                                    boardMap[player]?[ship.row][ship.col] = .none
                                }
                                shipWasPlaced = false
                                if let token: Token = boardMap[player]?[row][col] {
                                    shipHitPoints[token] = 0
                                }
                                break
                            }
                            moveTo += 1
                        }
                        if shipWasPlaced {
                            ships.removeFirst()
                        }
                        break
                    
                    default: // place ship in upward
                        while moveTo < ships.first! {
                            if row - moveTo >= 0 {
                                if let token: Token = boardMap[player]?[row - moveTo][col] {
                                    if token == .none {
                                        boardMap[player]?[row - moveTo][col] = shipToken[ships.count]!
                                        shipCache.append((row: row - moveTo, col: col))
                                    }
                                }
                                else {
                                    for ship in shipCache {
                                        boardMap[player]?[ship.row][ship.col] = .none
                                    }
                                    shipWasPlaced = false
                                    if let token: Token = boardMap[player]?[row][col] {
                                        shipHitPoints[token] = 0
                                    }
                                    break
                                }
                            }
                            else{
                                for ship in shipCache {
                                    boardMap[player]?[ship.row][ship.col] = .none
                                }
                                shipWasPlaced = false
                                if let token: Token = boardMap[player]?[row][col] {
                                    shipHitPoints[token] = 0
                                }
                                break
                            }
                            moveTo += 1
                        }
                        if shipWasPlaced {
                            ships.removeFirst()
                        }
                    break
                }
            }
        }
    }
    
    private func printMaps() {
            
        for (k, _) in boardMap {
            print(k)
            for row in 0..<10 {
                var rowString = ""
                for col in 0..<10 {
                    if boardMap[k]?[row][col] == Token.ship5 {
                        rowString += "5 "
                    }
                    else if boardMap[k]?[row][col] == Token.ship4 {
                        rowString += "4 "
                    }
                    else if boardMap[k]?[row][col] == Token.ship3 {
                        rowString += "3 "
                    }
                    else if boardMap[k]?[row][col] == Token.ship2A || boardMap[k]?[row][col] == Token.ship2B {
                        rowString += "2 "
                    }
                    else {
                        rowString += "0 "
                    }
                }
                print(rowString)
            }
            print("\n")
        }
    }
    
    /**
     This function is used to update the board after a touchesEnded event has completed in GameView. If the player makes an invalid placement (i.e. has already hit a ship), then the board will not update
     - parameter row: the row of the board matrix where touch event occurred
     - parameter col: the column of the board matrix where touch event occurred
     
     - Return: returns true if the player successfully hit an opponenets ship, false otherwise.
     */
    func takeTurn(at row: Int, and col: Int) -> Bool {
        if currentPlayer == .p1 {
            if let pos = boardMap[.p2]?[row][col] {
                if pos != .none && pos != .hit {
                    boardMap[.p2]?[row][col] = .hit
                    currentPlayer = .p2
                    return true
                }
                return false
            }
            return false
        }
        else {
            if let pos = boardMap[.p1]?[row][col] {
                if pos != .none && pos != .hit {
                    boardMap[.p1]?[row][col] = .hit
                    currentPlayer = .p1
                    return true
                }
                return false
            }
            return false
        }
    }
}
