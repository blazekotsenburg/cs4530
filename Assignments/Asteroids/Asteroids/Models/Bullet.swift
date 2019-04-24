//
//  Bullet.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/18/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import Foundation

struct Bullet: Codable, Equatable {
    
    var position: (x: Float, y: Float)
    var stepSize: (x: Float, y: Float)
    var angle: Float
    var spawnedAt: Date = Date()
    var id: Int
    
    init(position: (x: Float, y: Float), stepSize: (x: Float, y: Float), angle: Float, spawnedAt: Date, id: Int) {
        self.position = position
        self.stepSize = stepSize
        self.angle = angle
        self.spawnedAt = spawnedAt
        self.id = id
    }
    
    //MARK: - Overload operators
    static func == (lhs: Bullet, rhs: Bullet) -> Bool {
        return lhs.id == rhs.id
    }
    
    //MARK: - Error enum
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    enum CodingKeys: CodingKey {
        case position
        case stepSize
        case angle
        case id
//        case spawnedAt
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let positionArray = try values.decode([Float].self, forKey: .position)
        position = (x: positionArray[0], y: positionArray[1])
        let stepSizeArray = try values.decode([Float].self, forKey: .stepSize)
        stepSize = (x: stepSizeArray[0], y: stepSizeArray[1])
        angle = try values.decode(Float.self, forKey: .angle)
        id = try values.decode(Int.self, forKey: .id)
//        spawnedAt = try values.decode(Date.self, forKey: .spawnedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode([position.x, position.y], forKey: .position)
        try container.encode([stepSize.x, stepSize.y], forKey: .stepSize)
        try container.encode(angle, forKey: .angle)
        try container.encode(id, forKey: .id)
    }
}

//MARK: - Array extension for BattleShip
extension Array where Element == Bullet {
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw Bullet.Error.encoding
        }
        guard (try? jsonData.write(to: url)) != nil else {
            throw Bullet.Error.writing
        }
    }
    
    init(from url: URL) throws {
        let jsonData = try! Data(contentsOf: url)
        self  = try JSONDecoder().decode([Bullet].self, from: jsonData)
    }
}
