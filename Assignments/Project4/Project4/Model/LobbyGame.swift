//
//  LobbyGame.swift
//  Project4
//
//  Created by Blaze Kotsenburg on 3/21/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import Foundation

class LobbyGame: Codable {
    var id: String
    var name: String
    var player1: String
    var player2: String
    var winner: String
    var status: String
    var missilesLaunched: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case player1
        case player2
        case winner
        case status
        case missilesLaunched
    }
    
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        player1 = try values.decode(String.self, forKey: .status)
        player2 = try values.decode(String.self, forKey: .status)
        winner = try values.decode(String.self, forKey: .status)
        status = try values.decode(String.self, forKey: .status)
        missilesLaunched = try values.decode(String.self, forKey: .status)
    }
}

//MARK: - Array extension for LobbyGame
extension Array where Element == LobbyGame {
    
    init(from url: URL) throws {
        let jsonData = try! Data(contentsOf: url)
        self  = try JSONDecoder().decode([LobbyGame].self, from: jsonData)
    }
}
