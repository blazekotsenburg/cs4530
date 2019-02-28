//
//  BattleShip.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/20/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//
import Foundation

protocol BattleShipDelegate {
    func battleShip(_ battleShip: BattleShip, cellChangedAt row: Int, and col: Int)
}

class BattleShip: Codable {
    
    //MARK: - Properties
    enum Token {
        case none   //where board is water
        case p1     //marks position of player1 ship
        case p2     //marks position of player2 ship
        case hit    //marks a ship who has been hit
        case miss   //marks a missed shot
        case ship5  //marks ship of size 5
        case ship4  //marks ship of size 4
        case ship3  //marks ship of size 3
        case ship2A //marks first ship of size 2
        case ship2B //marks seconds ship of size 2
    }
    
    var delegate: BattleShipDelegate?
    var winner: Token = .none
    var currentPlayer: Token = .p1 //assigning here might break, but try it for decoder
    var boardMap: [Token : [[Token]]] = [.p1: [], .p2: []]
    var shipHitPoints: [Token : [Token: Int]] = [.p1: [.ship5: 1, .ship4: 1, .ship3: 1, .ship2A: 1, .ship2B: 1],
                                                 .p2: [.ship5: 1, .ship4: 1, .ship3: 1, .ship2A: 1, .ship2B: 1]]
    
    //MARK - Model initialization
    init() {
//        winner = .none
//        currentPlayer = .p1
        initBoards()
    }
    
    //MARK: - CodingKey enum
    enum CodingKeys: String, CodingKey {
        case winner
        case currentPlayer
        case boardMap
        case shipHitPoints
    }
    
    //MARK: - Error enum
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    //MARK: - Decoding requirements & functions
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let winnerStr = try values.decode(String.self, forKey: BattleShip.CodingKeys.winner)
        if winnerStr == "Player 1" {
            winner = .p1
        }
        else if winnerStr == "Player 2" {
            winner = .p2
        }
        else {
            winner = .none
        }
        let decodedMaps = try values.decode([String: [[String]]].self, forKey: BattleShip.CodingKeys.boardMap)
        boardMap = decodePlayerMaps(serializedBoards: decodedMaps)
        let decodedShipHitPoints = try values.decode([String: [String: Int]].self, forKey: BattleShip.CodingKeys.shipHitPoints)
        shipHitPoints = decodeShipHitPoints(serializedHitPoints: decodedShipHitPoints)
    }
    
    func decodePlayerMaps(serializedBoards: [String: [[String]]]) -> [Token : [[Token]]]{
        var playerMaps: [Token: [[Token]]] = [.p1: [], .p2: []]
        for (k, _) in serializedBoards {
            let key: Token = k == "Player 1" ? .p1 : .p2
            for row in 0..<10 {
                var rowTokens: [Token] = []
                for col in 0..<10 {
                    if serializedBoards[k]?[row][col] == "ship5" {
                        rowTokens.append(.ship5)
                    }
                    else if serializedBoards[k]?[row][col] == "ship4" {
                        rowTokens.append(.ship4)
                    }
                    else if serializedBoards[k]?[row][col] == "ship3" {
                        rowTokens.append(.ship3)
                    }
                    else if serializedBoards[k]?[row][col] == "ship2A" {
                        rowTokens.append(.ship2A)
                    }
                    else if serializedBoards[k]?[row][col] == "ship2B" {
                        rowTokens.append(.ship2B)
                    }
                    else if serializedBoards[k]?[row][col] == "hit" {
                        rowTokens.append(.hit)
                    }
                    else if serializedBoards[k]?[row][col] == "miss" {
                        rowTokens.append(.miss)
                    }
                    else {
                        rowTokens.append(.none)
                    }
                }
                playerMaps[key]?.append(rowTokens)
            }
        }
        return playerMaps
    }
    
    func decodeShipHitPoints(serializedHitPoints: [String: [String: Int]]) -> [Token: [Token: Int]] {
        var playerShips: [Token: [Token: Int]] = [.p1: [.ship5: 0, .ship4: 0, .ship3: 0, .ship2A: 0, .ship2B: 0],
                                                    .p2: [.ship5: 0, .ship4: 0, .ship3: 0, .ship2A: 0, .ship2B: 0]]
        for (k, list) in serializedHitPoints {
            let key: Token = k == "Player 1" ? .p1 : .p2
            for (ship, hp) in list {
                if ship == "ship5" {
                    playerShips[key]![.ship5] = hp
                }
                else if ship == "ship4" {
                    playerShips[key]![.ship4] = hp
                }
                else if ship == "ship3" {
                    playerShips[key]![.ship3] = hp
                }
                else if ship == "ship2A" {
                    playerShips[key]![.ship2A] = hp
                }
                else {
                    playerShips[key]![.ship2B] = hp
                }
            }
        }
        return playerShips
    }
    
    //MARK: - Encoding functions
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var gameWinner = ""
        if winner == .p1 {
            gameWinner = "Player 1"
        }
        else if winner == .p2 {
            gameWinner = "Player 2"
        }
        else {
            gameWinner = "None"
        }
        let currPlayer = currentPlayer == .p1 ? "Player 1" : "Player 2"
        let maps = encodePlayerMaps()
        let hpForShips = encodeShipHitPoints()
        try container.encode(gameWinner, forKey: BattleShip.CodingKeys.winner)
        try container.encode(currPlayer, forKey: BattleShip.CodingKeys.currentPlayer)
        try container.encode(maps, forKey: BattleShip.CodingKeys.boardMap)
        try container.encode(hpForShips, forKey: BattleShip.CodingKeys.shipHitPoints)
    }
    
    func encodePlayerMaps() -> [String: [[String]]] {
        var playerMaps: [String: [[String]]] = ["Player 1": [], "Player 2": []]
        for (k, _) in boardMap {
            let key = k == .p1 ? "Player 1" : "Player 2"
            for row in 0..<10 {
                var rowStrings: [String] = []
                for col in 0..<10 {
                    if boardMap[k]?[row][col] == .ship5 {
                        rowStrings.append("ship5")
                    }
                    else if boardMap[k]?[row][col] == .ship4 {
                        rowStrings.append("ship4")
                    }
                    else if boardMap[k]?[row][col] == .ship3 {
                        rowStrings.append("ship3")
                    }
                    else if boardMap[k]?[row][col] == .ship2A {
                        rowStrings.append("ship2A")
                    }
                    else if boardMap[k]?[row][col] == .ship2B {
                        rowStrings.append("ship2B")
                    }
                    else if boardMap[k]?[row][col] == .hit {
                        rowStrings.append("hit")
                    }
                    else if boardMap[k]?[row][col] == .miss {
                        rowStrings.append("miss")
                    }
                    else {
                        rowStrings.append("none")
                    }
                }
                playerMaps[key]?.append(rowStrings)
            }
        }
        return playerMaps
    }
    
    func encodeShipHitPoints() -> [String: [String: Int]] {
        var playerShips: [String: [String: Int]] = ["Player 1": ["ship5": 0, "ship4": 0, "ship3": 0, "ship2A": 0, "ship2B": 0],
                                                      "Player 2": ["ship5": 0, "ship4": 0, "ship3": 0, "ship2A": 0, "ship2B": 0]]
        for (k, list) in shipHitPoints {
            let key = k == .p1 ? "Player 1" : "Player 2"
            for (ship, hp) in list {
                if ship == .ship5 {
                    playerShips[key]!["ship5"] = hp
                }
                else if ship == .ship4 {
                    playerShips[key]!["ship4"] = hp
                }
                else if ship == .ship3 {
                    playerShips[key]!["ship3"] = hp
                }
                else if ship == .ship2A {
                    playerShips[key]!["ship2A"] = hp
                }
                else {
                    playerShips[key]!["ship2B"] = hp
                }
            }
        }
        return playerShips
    }
    
    //MARK: - Game logic
    
    /**
     Initializes boards with enum Token for each player.
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
                                        shipHitPoints[player]![shipToken[ships.count]!, default: 1] += 1
                                        shipCache.append((row: row, col: col + moveTo))
                                    }
                                    else {
                                        if let token: Token = boardMap[player]?[row][col] {
                                            shipHitPoints[player]![token] = 1
                                        }
                                        for ship in shipCache {
                                            boardMap[player]?[ship.row][ship.col] = .none
                                        }
                                        shipWasPlaced = false
                                        break
                                    }
                                }
                            }
                            else{
                                if let token: Token = boardMap[player]?[row][col] {
                                    shipHitPoints[player]![token] = 1
                                }
                                for ship in shipCache {
                                    boardMap[player]?[ship.row][ship.col] = .none
                                }
                                shipWasPlaced = false
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
                                        shipHitPoints[player]![shipToken[ships.count]!, default: 1] += 1
                                        shipCache.append((row: row, col: col - moveTo))
                                    }
                                    else {
                                        if let token: Token = boardMap[player]?[row][col] {
                                            shipHitPoints[player]![token] = 1
                                        }
                                        for ship in shipCache {
                                            boardMap[player]?[ship.row][ship.col] = .none
                                        }
                                        shipWasPlaced = false
                                        break
                                    }
                                }
                            }
                            else{
                                if let token: Token = boardMap[player]?[row][col] {
                                    shipHitPoints[player]![token] = 1
                                }
                                for ship in shipCache {
                                    boardMap[player]?[ship.row][ship.col] = .none
                                }
                                shipWasPlaced = false
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
                                        shipHitPoints[player]![shipToken[ships.count]!, default: 1] += 1
                                        shipCache.append((row: row + moveTo, col: col))
                                    }
                                    else {
                                        if let token: Token = boardMap[player]?[row][col] {
                                            shipHitPoints[player]![token] = 1
                                        }
                                        for ship in shipCache {
                                            boardMap[player]?[ship.row][ship.col] = .none
                                        }
                                        shipWasPlaced = false
                                        break
                                    }
                                }
                            }
                            else{
                                if let token: Token = boardMap[player]?[row][col] {
                                    shipHitPoints[player]![token] = 1
                                }
                                for ship in shipCache {
                                    boardMap[player]?[ship.row][ship.col] = .none
                                }
                                shipWasPlaced = false
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
                                        shipHitPoints[player]![shipToken[ships.count]!, default: 1] += 1
                                        shipCache.append((row: row - moveTo, col: col))
                                    }
                                    else {
                                        if let token: Token = boardMap[player]?[row][col] {
                                            shipHitPoints[player]![token] = 1
                                        }
                                        for ship in shipCache {
                                            boardMap[player]?[ship.row][ship.col] = .none
                                        }
                                        shipWasPlaced = false
                                        break
                                    }
                                }
                            }
                            else{
                                if let token: Token = boardMap[player]?[row][col] {
                                    shipHitPoints[player]![token] = 1
                                }
                                for ship in shipCache {
                                    boardMap[player]?[ship.row][ship.col] = .none
                                }
                                shipWasPlaced = false
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
    func takeTurn(at row: Int, and col: Int) {
        if currentPlayer == .p1 {
            if let pos = boardMap[.p2]?[row][col] {
                if pos != .none && pos != .hit {
                    print("P1: hit P2 ship at row: \(row), col: \(col)")
                    shipHitPoints[.p2]?[pos, default: 0] -= 1
                    if shipHitPoints[.p2]?[pos] == 0 {
                        print("ship sank!")
                    }
                    boardMap[.p2]?[row][col] = .hit
                    currentPlayer = .p2
                }
                else if pos == .none {
                    boardMap[.p2]?[row][col] = .miss
                    currentPlayer = .p2
                    print("P1: missed P2 ship at row: \(row), col: \(col)")
                }
            }
        }
        else {
            if let pos = boardMap[.p1]?[row][col] {
                if pos != .none && pos != .hit {
                    print("P2: hit P1 ship at row: \(row), col: \(col)")
                    shipHitPoints[.p1]?[pos, default: 0] -= 1
                    if shipHitPoints[.p1]?[pos] == 0 {
                        print("ship sank!")
                    }
                    boardMap[.p1]?[row][col] = .hit
                    currentPlayer = .p1
                }
                else if pos == .none {
                    boardMap[.p1]?[row][col] = .miss
                    currentPlayer = .p1
                    print("P2: missed P1 ship at row: \(row), col: \(col)")
                }
                
            }
        }
        delegate?.battleShip(self, cellChangedAt: row, and: col) // may need to pass in the player value to determine whos board changed
    }
}

//MARK: - Array extension for BattleShip
extension Array where Element == BattleShip {
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw BattleShip.Error.encoding
        }
        guard (try? jsonData.write(to: url)) != nil else {
            throw BattleShip.Error.writing
        }
    }
    
    init(from url: URL) throws {
        let jsonData = try! Data(contentsOf: url)
        self  = try JSONDecoder().decode([BattleShip].self, from: jsonData)
    }
}
