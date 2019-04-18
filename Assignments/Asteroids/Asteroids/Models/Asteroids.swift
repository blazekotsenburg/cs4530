//
//  Asteroids.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/4/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol AsteroidsDataSource {
    func asteroids(toggleLockFor asteroidsGame: Asteroids, lockAcquired: Bool)
    func asteroids(shipCollisionDetectedFor asteroidsGame: Asteroids)
}

class Asteroids {
    
    struct Ship {
        var angle: Float
        var velocity: (x: Float, y: Float) //might need a vector
        var acceleration: (x: Float, y: Float)
        var position: (x: Float, y: Float)
        var thrusterOn: Bool
        var rotatingLeft: Bool
        var rotatingRight: Bool
        var firingProjectile: Bool
    }
    
//    struct AsteroidObject {
//        var velocity: (x: Float, y: Float)
//        var position: (x: Float, y: Float)
//        var acceleration: (x: Float, y: Float)
//    }
    var lock: NSLock = NSLock()
    private var initialFrame: CGRect = CGRect()
    private var numberOfLives: Int = Int()
    private var score: Int = Int()
    private var gameLoopTimer: Timer = Timer()
    private var bulletTimer: Timer = Timer()
    private var bulletTicks: Int
    private var ship: Ship
    private var lastDate: Date
    var width: Float
    var height: Float
    private var numberOfAsteroids: Int = 4
    private var asteroidSpawnPoints: [(x: Float, y: Float)] // use this to reassign positions to asteroids after each level
    private var asteroids: [String: [AsteroidObject]] = ["large":[], "medium": [], "small": []]
    private var bulletQueue: [Bullet]
    
    var dataSource: AsteroidsDataSource?
    
    init(width: Float, height: Float) {
        self.width = width
        self.height = height
        lastDate = Date()
        bulletQueue = []
        bulletTicks = 0
        ship = Ship(angle: 0.0, velocity: (0.0, 0.0), acceleration: (x: 0.0, y: 0.0), position: (x: self.width * 0.5, y: self.height * 0.5), thrusterOn: false, rotatingLeft: false, rotatingRight: false, firingProjectile: false)
        // this coordinate system is different than the one in gameView. now need to translate coordinate system.
        // will also need to initialize asteroids dictionary differently here. asteroidSpawnPoints won't be queried every time now.
        asteroidSpawnPoints = [(x: width * 0.1, y: height * 0.1),
                               (x: width * 0.8, y: height * 0.2),
                               (x: width * 0.25, y: height * 0.9),
                               (x: width * 0.75, y: height * 0.85)]
        
        for i in 0..<numberOfAsteroids {
            let randAngle: Float = Float.random(in: 0...180)
            asteroids["large"]?.append(AsteroidObject(velocity: (x: 0.0, y: 0.0), position: asteroidSpawnPoints[i], acceleration: (x: 0.0, y: 0.0), stepSize: (x: cos(randAngle) * 0.25, y: sin(randAngle) * 0.25)))
        }
        
        beginTimer()
        beginBulletTimer()
    }
    
    // make a function to reset the asteroid postions after each level ends.
    // loop through large key of dictionary and then append another large asteroid to the end with new position.
    
    func beginTimer() {
        gameLoopTimer = Timer.scheduledTimer(withTimeInterval: 1.0/120.0, repeats: true, block: { _ in
            let now: Date = Date()
            let elapsed: TimeInterval = now.timeIntervalSince(self.lastDate)
            self.lastDate = now
            self.executeGameLoop(elapsed: elapsed)
        })
    }
    
    func beginBulletTimer() {
        bulletTimer = Timer.scheduledTimer(withTimeInterval: 1.0/120.0, repeats: true, block: { _ in
            self.bulletTicks += 1
        })
    }
    
    private func executeGameLoop(elapsed: TimeInterval) {
        
        //TODO: - Check for collisions between objects
        asteroidCollision()
        
        // Check if the ship is supposed to rotate left or right
        if ship.rotatingRight {
            ship.angle += Float(elapsed) * 4.0
        }
        else if ship.rotatingLeft {
            ship.angle -= Float(elapsed) * 4.0
        }
        
        // Check if the ship is firing and that bullet ticks is greater than 20 (to create gap between each bullet)
        if ship.firingProjectile && bulletTicks >= 20 {
            lock.lock()
            let bullet: Bullet = Bullet(position: (x: ship.position.x, y: ship.position.y), stepSize: (x: cos(ship.angle) * 0.5, y: sin(ship.angle) * 0.5), angle: ship.angle, spawnedAt: Date())
            bulletQueue.append(bullet)
            bulletTicks = 0
            lock.unlock()
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
        ship.acceleration.x = ship.thrusterOn ? sin(ship.angle) * 70 : -ship.velocity.x * 0.5
        ship.acceleration.y = ship.thrusterOn ? -cos(ship.angle) * 70: -ship.velocity.y * 0.5
        
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
        
//        cleanUpBullets()
    }
    
    func cleanUpBullets() {
        //this will need a lock! gets an index out of bounds range when repeately tapping. bulletQueue being manipulated in two spots.
        lock.lock()
        for i in 0..<bulletQueue.count {
            let now: Date = Date()
            let elapsed: TimeInterval = now.timeIntervalSince(bulletQueue[i].spawnedAt)
            if elapsed > 2 {
                bulletQueue.remove(at: i)
            }
        }
        lock.unlock()
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
//                        let sumRadii = Float(((1.0 / 25.0) / 2.0) + ((1.0 / 100.0) / 2.0))
                        if centerDiffX + centerDiffY <= sumRadii {
//                            print("collision detected")
//                            dataSource?.asteroids(shipCollisionDetectedFor: self)
                            // TODO: - Make delegate to notify view that collision has happened and to remove the ship.
                        }
                    }
                    break
                default:
                    break
            }
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
        //this function needs to pass back all of the asteroid positions, not just the spawn points.
        return asteroids // returns the entire asteroids dictionary back to the gameView
    }
}
