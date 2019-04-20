//
//  Asteroids.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/4/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol AsteroidsDataSource {
    func asteroids(shipCollisionDetectedFor asteroidsGame: Asteroids)
    func asteroids(removeAsteroidWith key: String, at index: Int)
    func asteroids(updateScoreWith newScore: Int)
    func asteroids(updateLivesWith livesString: String)
    func asteroids(gameOverWith score: Int)
}

class Asteroids: Codable {
    
    struct Ship: Codable {
        var angle: Float
        var velocity: (x: Float, y: Float)
        var acceleration: (x: Float, y: Float)
        var position: (x: Float, y: Float)
        var thrusterOn: Bool = false
        var rotatingLeft: Bool = false
        var rotatingRight: Bool = false
        var firingProjectile: Bool = false
        var respawnShieldOn: Bool
        var respawnShieldBegin: Date = Date()
        
        enum CodingKeys: CodingKey {
            case angle
            case velocity
            case acceleration
            case position
            case respawnShieldOn
//            case respawnShieldBegin
        }
        
        init(angle: Float, velocity: (x: Float, y: Float), acceleration: (x: Float, y: Float), position: (x: Float, y: Float), thrusterOn: Bool, rotatingLeft: Bool, rotatingRight: Bool, firingProjectile: Bool, respawnShieldOn: Bool, respawnShieldBegin: Date) {
            self.angle = angle
            self.velocity = velocity
            self.acceleration = acceleration
            self.position = position
            self.thrusterOn = thrusterOn
            self.rotatingLeft = rotatingLeft
            self.rotatingRight = rotatingRight
            self.firingProjectile = firingProjectile
            self.respawnShieldOn = respawnShieldOn
            self.respawnShieldBegin = respawnShieldBegin
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            angle = try values.decode(Float.self, forKey: .angle)
            let velocityArray = try values.decode([Float].self, forKey: .velocity)
            velocity = (x: velocityArray[0], y: velocityArray[1])
            let positionArray = try values.decode([Float].self, forKey: .position)
            position = (x: positionArray[0], y: positionArray[1])
            let accelerationArray = try values.decode([Float].self, forKey: .acceleration)
            acceleration = (x: accelerationArray[0], y: accelerationArray[1])
            respawnShieldOn = try values.decode(Bool.self, forKey: .respawnShieldOn)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(angle, forKey: .angle)
            try container.encode([velocity.x, velocity.y], forKey: .velocity)
            try container.encode([position.x, position.y], forKey: .position)
            try container.encode([acceleration.x, acceleration.y], forKey: .acceleration)
            try container.encode(respawnShieldOn, forKey: .respawnShieldOn)
            // this may need to be another elapsed time or something
//            try container.encode(respawnShieldBegin, forKey: .respawnShieldBegin)
        }
    }

    var lock: NSLock = NSLock()
    private var initialFrame: CGRect = CGRect()
    private var numberOfLives: Int = 3
    private var score: Int = 0
    private var gameLoopTimer: Timer = Timer()
    private var bulletTicks: Int = 0
    private var ship: Ship
    private var lastDate: Date = Date()
    var width: Float = 0.0
    var height: Float = 0.0
    private var level: Int = 4
    private var asteroidSpawnPoints: [(x: Float, y: Float)] = []// use this to reassign positions to asteroids after each level
    private var asteroids: [String: [AsteroidObject]] = ["large":[], "medium": [], "small": []]
    private var bulletQueue: [Bullet]
    private var gamePaused: Bool = false
    
    var dataSource: AsteroidsDataSource?
    
    //MARK: - CodingKey enum
    enum CodingKeys: CodingKey {
        //Properties for ship
        case ship
        //Properties for model itself
        case width
        case height
        case numberOfLives
        case score
        case level
        case asteroids
        case bulletQueue
    }
    
    //MARK: - Error enum
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    init(width: Float, height: Float) {
        self.width = width
        self.height = height
        self.lastDate = Date()
        self.bulletQueue = []
        self.bulletTicks = 0
        //this will need to be handled in some other way for initialization
        self.ship = Ship(angle: 0.0, velocity: (x: 0.0, y: 0.0), acceleration: (x: 0.0, y: 0.0), position: (x: self.width * 0.5, y: self.height * 0.5), thrusterOn: false, rotatingLeft: false, rotatingRight: false, firingProjectile: false, respawnShieldOn: false, respawnShieldBegin: Date())
        // this coordinate system is different than the one in gameView. now need to translate coordinate system.
        // will also need to initialize asteroids dictionary differently here. asteroidSpawnPoints won't be queried every time now.
        self.asteroidSpawnPoints = [(x: width * 0.1, y: height * 0.1),
                               (x: width * 0.8, y: height * 0.2),
                               (x: width * 0.25, y: height * 0.9),
                               (x: width * 0.75, y: height * 0.85),
                               (x: width * 0.5, y: height * 0.95),
                               (x: width * 0.35, y: height * 0.05)]
        
        spawnAsteroids()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ship = try values.decode(Ship.self, forKey: .ship)
        numberOfLives = try values.decode(Int.self, forKey: .numberOfLives)
        score = try values.decode(Int.self, forKey: .score)
        width = try values.decode(Float.self, forKey: .width)
        height = try values.decode(Float.self, forKey: .height)
        level = try values.decode(Int.self, forKey: .level)
        asteroids = try values.decode([String: [AsteroidObject]].self, forKey: .asteroids)
        bulletQueue = try values.decode([Bullet].self, forKey: .bulletQueue)
        gamePaused = false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ship, forKey: .ship)
        try container.encode(numberOfLives, forKey: .numberOfLives)
        try container.encode(score, forKey: .score)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(level, forKey: .level)
        try container.encode(asteroids, forKey: .asteroids)
        try container.encode(bulletQueue, forKey: .bulletQueue)
    }
    
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw Asteroids.Error.encoding
        }
        guard (try? jsonData.write(to: url)) != nil else {
            throw Asteroids.Error.writing
        }
    }
    
    private func spawnAsteroids() {
        for i in 0..<level {
            let randAngle: Float = Float.random(in: 0...180)
            asteroids["large"]?.append(AsteroidObject(velocity: (x: Float(0.0), y: Float(0.0)), position: asteroidSpawnPoints[i], acceleration: (x: Float(0.0), y: Float(0.0)), stepSize: (x: cos(randAngle) * 0.25, y: sin(randAngle) * 0.25)))
        }
    }
    
    // make a function to reset the asteroid postions after each level ends.
    // loop through large key of dictionary and then append another large asteroid to the end with new position.
    
    func beginTimer() {
        lastDate = Date()
        gameLoopTimer = Timer.scheduledTimer(withTimeInterval: 1.0/120.0, repeats: true, block: { _ in
            if !self.gamePaused {
                let now: Date = Date()
                let elapsed: TimeInterval = now.timeIntervalSince(self.lastDate)
                self.lastDate = now
                self.executeGameLoop(elapsed: elapsed)
                self.bulletTicks += 1
            }
        })
    }
    
    private func executeGameLoop(elapsed: TimeInterval) {
        
        if numberOfLives <= 0 {
            dataSource?.asteroids(gameOverWith: score)
        }
        
        if let asteroidLarge = asteroids["large"], let asteroidMedium = asteroids["medium"], let asteroidSmall = asteroids["small"] {
            if asteroidLarge.isEmpty && asteroidMedium.isEmpty && asteroidSmall.isEmpty {
                if numberOfLives > 0 && level <= 6{
                    level += 1
                    spawnAsteroids()
                }
            }
        }
        
        if ship.respawnShieldOn {
            let now: Date = Date()
            let elapsed: TimeInterval = now.timeIntervalSince(ship.respawnShieldBegin)
            if elapsed > 3.0 {
                ship.respawnShieldOn = false
            }
        }
        else {
            asteroidCollision()
        }
        
        // Check if the ship is supposed to rotate left or right
        if ship.rotatingRight {
            ship.angle += Float(elapsed) * 4.0
        }
        else if ship.rotatingLeft {
            ship.angle -= Float(elapsed) * 4.0
        }
        
        // Check if the ship is firing and that bullet ticks is greater than 20 (to create gap between each bullet)
        if ship.firingProjectile && bulletTicks >= 20 {
            let bullet: Bullet = Bullet(position: (x: ship.position.x, y: ship.position.y), stepSize: (x: sin(ship.angle) * 1.25, y: -cos(ship.angle) * 1.25), angle: ship.angle, spawnedAt: Date())
            bulletQueue.append(bullet)
            bulletTicks = 0
        }
        
        for i in 0..<bulletQueue.count {
            if bulletQueue[i].position.x > width {
                bulletQueue[i].position.x = 0.0
            }
            else if bulletQueue[i].position.x < 0.0 {
                bulletQueue[i].position.x = Float(width)
            }
            if bulletQueue[i].position.y > height {
                let currYPos = bulletQueue[i].position.y
                bulletQueue[i].position.y -= currYPos
            }
            else if bulletQueue[i].position.y < 0.0 {
                bulletQueue[i].position.y += Float(height)
            }
        }
        
        // Check if ship is still in the view
        if Float(ship.position.x) > width {
            ship.position.x = 0.0
        }
        else if ship.position.x < 0.0 {
            ship.position.x = Float(width)
        }
        if Float(ship.position.y) > height {
            let currYPos = Float(ship.position.y)
            ship.position.y -= Float(currYPos)
        }
        else if ship.position.y < 0.0 {
            ship.position.y += Float(height)
        }
        
        //Update the acceleration for the ship
        ship.acceleration.x = ship.thrusterOn ? sin(ship.angle) * 70 : -ship.velocity.x * 0.75
        ship.acceleration.y = ship.thrusterOn ? -cos(ship.angle) * 70: -ship.velocity.y * 0.75
        
        //Update the velocity and position of the ship
        ship.velocity.x += ship.acceleration.x * Float(elapsed)
        ship.position.x += ship.velocity.x * Float(elapsed)
        ship.velocity.y += ship.acceleration.y * Float(elapsed)
        ship.position.y += ship.velocity.y * Float(elapsed)
        
        //Update the positions of all the asteroids in the model
        for (size, asteroidList) in asteroids {
            for i in 0..<asteroidList.count {
                // check in here for whether the x or y position is off the screen so that it can be repositioned before updating velocity
                if let xPos = asteroids[size]?[i].position.x, let yPos = asteroids[size]?[i].position.y {
                    // Missing certain edge cases... eventually all asteroids are not spawing in correct spots (maybe solved)
                    if xPos > width {
                        asteroids[size]?[i].position.x = 0.0
                    }
                    else if xPos < 0.0 {
                        asteroids[size]?[i].position.x = width
                    }
                    if yPos > height {
                        if let currYPos = asteroids[size]?[i].position.y {
                            asteroids[size]?[i].position.y -= Float(currYPos)
                        }
                    }
                    else if yPos < 0.0 {
                        asteroids[size]?[i].position.y += height
                    }
                }
                
                let stepX = asteroids[size]?[i].stepSize.x
                asteroids[size]?[i].position.x += Float(stepX!)//Float((velocityX)! * Float(elapsed))
                let stepY = asteroids[size]?[i].stepSize.y
                asteroids[size]?[i].position.y += Float(stepY!)//Float((velocityY)! * Float(elapsed))
            }
        }
        
        for i in 0..<bulletQueue.count {
            bulletQueue[i].position.x += bulletQueue[i].stepSize.x
            bulletQueue[i].position.y += bulletQueue[i].stepSize.y
        }
        
        bulletCollision()
        cleanUpBullets()
    }
    
    func cleanUpBullets() {
        var indexesToRemove: [Int] = []
        for i in 0..<bulletQueue.count {
            let now: Date = Date()
            let elapsed: TimeInterval = now.timeIntervalSince(bulletQueue[i].spawnedAt)
            if elapsed > 2 {
                indexesToRemove.append(i)
            }
        }
        for index in indexesToRemove {
            bulletQueue.remove(at: index)
        }
    }
    
    func asteroidCollision() {
        for (size, asteroidList) in asteroids {
            switch size {
                case "large":
                    for i in 0..<asteroidList.count {
                        //Circle-circle collision detection: (x2-x1)^2 + (y1-y2)^2 <= (r1+r2)^2
                        let centerDiffX = pow((Float(ship.position.x) - asteroidList[i].position.x), 2)
                        let centerDiffY = pow((Float(ship.position.y) - asteroidList[i].position.y), 2)
                        let sumRadii = Float(pow((25.0 / 2.0) + 50.0, 2))
                        
                        if centerDiffX + centerDiffY <= sumRadii {
                            numberOfLives -= 1
                            if numberOfLives == 2 {
                                dataSource?.asteroids(updateLivesWith: "♥︎ ♥︎")
                            }
                            else if numberOfLives == 1 {
                                dataSource?.asteroids(updateLivesWith: "♥︎")
                            }
                            else {
                                dataSource?.asteroids(updateLivesWith: "")
                            }
                            
                            ship.position = (x: width / 2.0, y: height / 2.0)
                            ship.acceleration = (x: 0.0, y: 0.0)
                            ship.velocity = (x: 0.0, y: 0.0)
                            ship.angle = 0.0
                            ship.rotatingLeft = false
                            ship.rotatingRight = false
                            ship.thrusterOn = false
                            ship.firingProjectile = false
                            ship.respawnShieldOn = true
                            ship.respawnShieldBegin = Date()
                        }
                    }
                    break
                case "medium":
                    for i in 0..<asteroidList.count {
                        //Circle-circle collision detection: (x2-x1)^2 + (y1-y2)^2 <= (r1+r2)^2
                        let centerDiffX = pow((Float(ship.position.x) - asteroidList[i].position.x), 2)
                        let centerDiffY = pow((Float(ship.position.y) - asteroidList[i].position.y), 2)
                        let sumRadii = Float(pow((25.0 / 2.0) + 50.0, 2))
                        
                        if centerDiffX + centerDiffY <= sumRadii {
                            numberOfLives -= 1
                            if numberOfLives == 2 {
                                dataSource?.asteroids(updateLivesWith: "♥︎ ♥︎")
                            }
                            else if numberOfLives == 1 {
                                dataSource?.asteroids(updateLivesWith: "♥︎")
                            }
                            else {
                                dataSource?.asteroids(updateLivesWith: "")
                            }
                            
                            ship.position = (x: width / 2.0, y: height / 2.0)
                            ship.acceleration = (x: 0.0, y: 0.0)
                            ship.velocity = (x: 0.0, y: 0.0)
                            ship.angle = 0.0
                            ship.rotatingLeft = false
                            ship.rotatingRight = false
                            ship.thrusterOn = false
                            ship.firingProjectile = false
                            ship.respawnShieldOn = true
                            ship.respawnShieldBegin = Date()
                        }
                    }
                    break
                case "small":
                    for i in 0..<asteroidList.count {
                        //Circle-circle collision detection: (x2-x1)^2 + (y1-y2)^2 <= (r1+r2)^2
                        let centerDiffX = pow((Float(ship.position.x) - asteroidList[i].position.x), 2)
                        let centerDiffY = pow((Float(ship.position.y) - asteroidList[i].position.y), 2)
                        let sumRadii = Float(pow((25.0 / 2.0) + 50.0, 2))
                        
                        if centerDiffX + centerDiffY <= sumRadii {
                            numberOfLives -= 1
                            if numberOfLives == 2 {
                                dataSource?.asteroids(updateLivesWith: "♥︎ ♥︎")
                            }
                            else if numberOfLives == 1 {
                                dataSource?.asteroids(updateLivesWith: "♥︎")
                            }
                            else {
                                dataSource?.asteroids(updateLivesWith: "")
                            }
                            
                            ship.position = (x: width / 2.0, y: height / 2.0)
                            ship.acceleration = (x: 0.0, y: 0.0)
                            ship.velocity = (x: 0.0, y: 0.0)
                            ship.angle = 0.0
                            ship.rotatingLeft = false
                            ship.rotatingRight = false
                            ship.thrusterOn = false
                            ship.firingProjectile = false
                            ship.respawnShieldOn = true
                            ship.respawnShieldBegin = Date()
                        }
                    }
                    break
                default:
                    break
            }
        }
    }
    
    func bulletCollision() {
        
        var removeAsteroidIndexes: [(key: String, index: Int)] = []
        var removeBulletIndexes: [Int] = []
        for (size, asteroidList) in asteroids {
            if !bulletQueue.isEmpty && !asteroidList.isEmpty {
                for i in 0..<bulletQueue.count {
                    for j in 0..<asteroidList.count {
                        let centerDiffX = pow(bulletQueue[i].position.x - asteroidList[j].position.x, 2)
                        let centerDiffY = pow(bulletQueue[i].position.y - asteroidList[j].position.y, 2)
                        
                        let asteroidRadius: Float
                        let bulletRadius: Float = 2.5
                        let nextAsteroid: String
                        var addToScore: Int = 0
                        
                        switch size {
                            case "large":
                                asteroidRadius = 50.0
                                nextAsteroid = "medium"
                                addToScore += 20
                                break
                            case "medium":
                                asteroidRadius = 25.0
                                nextAsteroid = "small"
                                addToScore += 50
                                break
                            default:
                                asteroidRadius = 12.5
                                nextAsteroid = ""
                                addToScore += 100
                                break
                        }
                        
                        let sumRadii = pow(bulletRadius + asteroidRadius, 2)
                        
                        if centerDiffX + centerDiffY <= sumRadii {
                            dataSource?.asteroids(removeAsteroidWith: size, at: j)
                            removeAsteroidIndexes.append((key: size, index: j))
                            removeBulletIndexes.append(i)
                            
                            score += addToScore
                            dataSource?.asteroids(updateScoreWith: score)
                            
                            switch nextAsteroid {
                                case "medium":
                                    for _ in 0..<2 {
                                        let randAngle: Float = Float.random(in: 0...180)
                                        asteroids["medium"]?.append(AsteroidObject(velocity: (x: 0.0, y: 0.0), position: asteroidList[j].position, acceleration: (x: 0.0, y: 0.0), stepSize: (x: cos(randAngle) * 0.45, y: sin(randAngle) * 0.45)))
                                    }
                                    break
                                case "small":
                                    for _ in 0..<2 {
                                        let randAngle: Float = Float.random(in: 0...180)
                                        asteroids["small"]?.append(AsteroidObject(velocity: (x: 0.0, y: 0.0), position: asteroidList[j].position, acceleration: (x: 0.0, y: 0.0), stepSize: (x: cos(randAngle) * 0.65, y: sin(randAngle) * 0.65)))
                                    }
                                    break
                                default:
                                    break
                            }
                        }
                    }
                }
            }
        }
        
        for index in removeBulletIndexes {
            bulletQueue.remove(at: index)
        }
        for (key, index) in removeAsteroidIndexes {
            asteroids[key]?.remove(at: index)
        }
    }
    
    func rotateShipLeft(isRotatingLeft: Bool) {
        ship.rotatingLeft = isRotatingLeft
    }
    
    func rotateShipRight(isRotatingRight: Bool) {
        ship.rotatingRight = isRotatingRight
    }
    
    func getAngleForShip() -> Float {
        return ship.angle
    }
    
    func toggleThruster(thrusterOn: Bool) {
        ship.thrusterOn = thrusterOn
    }
    
    func fireProjectile(isFiringProjectile: Bool) {
        ship.firingProjectile = isFiringProjectile
    }
    
    func getShipPosition() -> (x: Float, y: Float) {
        return ship.position
    }
    
    func getAsteroidPositions() -> [String: [AsteroidObject]] {
        return asteroids // consider making this only send back positions
    }
    
    func toggleGameState(gamePaused: Bool) {
        self.gamePaused = gamePaused
    }
    
    func isGamePaused() -> Bool {
        return gamePaused
    }
    
    func getBulletPositions() -> [(x: Float, y: Float)] {
        var positions: [(x: Float, y: Float)] = [(x: Float, y: Float)]()
        for bullet in bulletQueue {
            positions.append(bullet.position)
        }
        return positions
    }
}
