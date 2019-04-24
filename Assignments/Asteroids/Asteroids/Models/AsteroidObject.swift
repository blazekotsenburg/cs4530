//
//  AsteroidObject.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/16/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import Foundation

struct AsteroidObject: Codable, Equatable {
    
    //MARK: - Overload operators
    static func == (lhs: AsteroidObject, rhs: AsteroidObject) -> Bool {
        return lhs.id == rhs.id
    }
    
    var velocity: (x: Float, y: Float)
    var position: (x: Float, y: Float)
    var acceleration: (x: Float, y: Float)
    var stepSize: (x: Float, y: Float)
    var id: Int
    
    init(velocity: (x: Float, y: Float), position: (x: Float, y: Float), acceleration: (x: Float, y: Float), stepSize: (x: Float, y: Float), id: Int) {
        self.velocity = velocity
        self.position = position
        self.acceleration = acceleration
        self.stepSize = stepSize
        self.id = id
    }
    
    enum CodingKeys: CodingKey {
        case velocity
        case position
        case acceleration
        case stepSize
        case id
    }
    
    //MARK: - Error enum
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let velocityArray = try values.decode([Float].self, forKey: .velocity)
        velocity = (x: velocityArray[0], y: velocityArray[1])
        let positionArray = try values.decode([Float].self, forKey: .position)
        position = (x: positionArray[0], y: positionArray[1])
        let accelerationArray = try values.decode([Float].self, forKey: .acceleration)
        acceleration = (x: accelerationArray[0], y: accelerationArray[1])
        let stepSizeArray = try values.decode([Float].self, forKey: .stepSize)
        stepSize = (x: stepSizeArray[0], y: stepSizeArray[1])
        id = try values.decode(Int.self, forKey: .id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode([velocity.x, velocity.y], forKey: .velocity)
        try container.encode([position.x, position.y], forKey: .position)
        try container.encode([acceleration.x, acceleration.y], forKey: .acceleration)
        try container.encode([stepSize.x, stepSize.y], forKey: .stepSize)
        try container.encode(id, forKey: .id)
    }
}

//MARK: - Array extension for BattleShip
extension Array where Element == AsteroidObject {
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw AsteroidObject.Error.encoding
        }
        guard (try? jsonData.write(to: url)) != nil else {
            throw AsteroidObject.Error.writing
        }
    }
    
    init(from url: URL) throws {
        let jsonData = try! Data(contentsOf: url)
        self  = try JSONDecoder().decode([AsteroidObject].self, from: jsonData)
    }
}

extension Dictionary where Dictionary<Key, Value> == [String: [AsteroidObject]] {
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw AsteroidObject.Error.encoding
        }
        guard (try? jsonData.write(to: url)) != nil else {
            throw AsteroidObject.Error.writing
        }
    }
    
    init(from url: URL) throws {
        let jsonData = try! Data(contentsOf: url)
        self  = try JSONDecoder().decode([String: [AsteroidObject]].self, from: jsonData)
    }
}

