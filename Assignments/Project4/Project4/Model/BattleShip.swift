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

struct Coordinate: Codable {
    var xPos: Int
    var yPos: Int
    var status: String
}

class BattleShip: Codable {
    
    //MARK: - Properties
    enum Token {
        case none     //water on board
        case player   //player token
        case opponent //opponent token
        case hit      //marks a ship which has been hit
        case miss     //marks a missed shot
        case ship     //marks ship
    }
    
    var delegate: BattleShipDelegate?
    var eventString: String = ""
    var winner: Token = .none
    var boardMap: [Token : [[Token]]] = [.player: [], .opponent: []]
    var playerBoard: [Coordinate] = []
    var opponentBoard: [Coordinate] = []
    
    //MARK - Model initialization
    init() {
        initBoards()
    }
    
    private func initBoards() {
        var currBoard: Token = .player
        for i in 0...1 {
            if i == 1 {
                currBoard = .opponent
            }
            let rowForBoard: [Token] = [.none, .none, .none, .none, .none, .none, .none, .none, .none, .none]
            for _ in 0..<10 {
                boardMap[currBoard]?.append(rowForBoard)
            }
        }
    }
    
    //MARK: - CodingKey enum
    enum CodingKeys: CodingKey {
        case playerBoard
        case opponentBoard
    }
    
    //MARK: - Error enum
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    //MARK: - Decoding requirements & functions
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        playerBoard = try values.decode([Coordinate].self, forKey: CodingKeys.playerBoard)
        opponentBoard = try values.decode([Coordinate].self, forKey: CodingKeys.opponentBoard)
        decodePlayerMaps(for: playerBoard, and: opponentBoard)
    }
    
    func decodePlayerMaps(for playerBoard: [Coordinate], and opponentBoard: [Coordinate]) {
        initBoards()
        
        for gameToken in playerBoard {
            if gameToken.status == "MISS" {
                boardMap[.player]?[gameToken.yPos][gameToken.xPos] = .miss
            }
            else if gameToken.status == "HIT" {
                boardMap[.player]?[gameToken.yPos][gameToken.xPos] = .hit
            }
            else if gameToken.status == "SHIP" {
                boardMap[.player]?[gameToken.yPos][gameToken.xPos] = .ship
            }
            else if gameToken.status == "NONE" {
                boardMap[.player]?[gameToken.yPos][gameToken.xPos] = .none
            }
        }
        for gameToken in opponentBoard {
            if gameToken.status == "MISS" {
                boardMap[.opponent]?[gameToken.yPos][gameToken.xPos] = .miss
            }
            else if gameToken.status == "HIT" {
                boardMap[.opponent]?[gameToken.yPos][gameToken.xPos] = .hit
            }
            else if gameToken.status == "NONE" {
                boardMap[.opponent]?[gameToken.yPos][gameToken.xPos] = .none
            }
        }
    }
    
    //MARK: - Encoding functions
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var gameWinner = ""
//        if winner == .p1 {
//            gameWinner = "Player 1"
//        }
//        else if winner == .p2 {
//            gameWinner = "Player 2"
//        }
//        else {
//            gameWinner = "None"
//        }
//        let currPlayer = currentPlayer == .p1 ? "Player 1" : "Player 2"
//        let maps = encodePlayerMaps()
//        let hpForShips = encodeShipHitPoints()
//        try container.encode(eventString, forKey: BattleShip.CodingKeys.eventString)
//        try container.encode(gameWinner, forKey: BattleShip.CodingKeys.winner)
//        try container.encode(currPlayer, forKey: BattleShip.CodingKeys.currentPlayer)
//        try container.encode(maps, forKey: BattleShip.CodingKeys.boardMap)
//        try container.encode(hpForShips, forKey: BattleShip.CodingKeys.shipHitPoints)
    }
}

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

