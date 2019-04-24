//
//  HighScores.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/23/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import Foundation

class HighScores: Codable {
    var name: String
    var score: Int
    
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
}

extension Array where Element == HighScores {
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw HighScores.Error.encoding
        }
        guard (try? jsonData.write(to: url)) != nil else {
            throw HighScores.Error.writing
        }
    }
    
    init(from url: URL) throws {
        let jsonData = try! Data(contentsOf: url)
        self  = try JSONDecoder().decode([HighScores].self, from: jsonData)
    }
}
