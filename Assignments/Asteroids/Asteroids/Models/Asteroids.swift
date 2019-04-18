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
}

class Asteroids {
    
    struct Ship {
        var angle: CGFloat
        var velocity: (x: CGFloat, y: CGFloat) //might need a vector
        var acceleration: (x: CGFloat, y: CGFloat)
        var position: CGPoint
        var thrusterOn: Bool
        var rotatingLeft: Bool
        var rotatingRight: Bool
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
    private var ship: Ship
    private var lastDate: Date
    var width: Float
    var height: Float
    private var numberOfAsteroids: Int = 4
    private var asteroidSpawnPoints: [(x: Float, y: Float)] // use this to reassign positions to asteroids after each level
    private var asteroids: [String: [AsteroidObject]] = ["large":[], "medium": [], "small": []]
    //TODO: - Update positions of objects
    //TODO: - Detect collisions between objects
    
    var dataSource: AsteroidsDataSource?
    
    init(width: Float, height: Float) {
        self.width = width
        self.height = height
        lastDate = Date()
        ship = Ship(angle: 0.0, velocity: (0.0, 0.0), acceleration: (x: 0.0, y: 0.0), position: CGPoint(x: Double(self.width * 0.5), y: Double(self.height * 0.5)), thrusterOn: false, rotatingLeft: false, rotatingRight: false)
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
    
    //should be called from game loop
    private func executeGameLoop(elapsed: TimeInterval) {
        if ship.rotatingRight {
            ship.angle += CGFloat(elapsed) * 4.0
        }
        else if ship.rotatingLeft {
            ship.angle -= CGFloat(elapsed) * 4.0
        }
        
        //TODO: - Check for collisions between objects
        asteroidCollision()
        
        // check if ship is still in the view
        if Float(ship.position.x) > width {
            ship.position.x = 0.0
        }
        else if ship.position.x < 0.0 {
            ship.position.x = CGFloat(width)
        }
        if Float(ship.position.y) > height {
            let currYPos = Float(ship.position.y)
            ship.position.y -= CGFloat(currYPos)
        }
        else if ship.position.y < 0.0 {
            ship.position.y += CGFloat(height)
        }
        
        ship.acceleration.x = ship.thrusterOn ? sin(ship.angle) * 70 : -ship.velocity.x * 0.5
        ship.acceleration.y = ship.thrusterOn ? -cos(ship.angle) * 70: -ship.velocity.y * 0.5
        
        ship.velocity.x += ship.acceleration.x * CGFloat(elapsed)
        ship.position.x += ship.velocity.x * CGFloat(elapsed)
        ship.velocity.y += ship.acceleration.y * CGFloat(elapsed)
        ship.position.y += ship.velocity.y * CGFloat(elapsed)
        
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
                
//                let cosAngle = cos((asteroids[size]?[i].angle)!)
                let stepX = asteroids[size]?[i].stepSize.x
//                asteroids[size]?[i].velocity.x += Float(stepX!)// make this second constant a random property for x & y for each asteroid
//                let velocityX = asteroids[size]?[i].velocity.x
                asteroids[size]?[i].position.x += Float(stepX!)//Float((velocityX)! * Float(elapsed))
//                let sinAngle = sin((asteroids[size]?[i].angle)!)
                let stepY = asteroids[size]?[i].stepSize.y
                asteroids[size]?[i].velocity.y += Float(stepY!)
//                let velocityY = asteroids[size]?[i].velocity.y
                asteroids[size]?[i].position.y += Float(stepY!)//Float((velocityY)! * Float(elapsed))
            }
        }
    }
    
    func asteroidCollision() {
        for (size, asteroidList) in asteroids {
            switch size {
                case "large":
                    for i in 0..<asteroidList.count {
                        //(x2-x1)^2 + (y1-y2)^2 <= (r1+r2)^2
                        let centerDiffX = pow((Float(ship.position.x) - asteroidList[i].position.x), 2)
                        let centerDiffY = pow((Float(ship.position.y) - asteroidList[i].position.y), 2)
                        let sumRadii = Float(pow((25.0 / 2.0) + 50.0, 2))
//                        let sumRadii = Float(((1.0 / 25.0) / 2.0) + ((1.0 / 100.0) / 2.0))
                        if centerDiffX + centerDiffY <= sumRadii {
                            print("collision detected")
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
    
    func getAngleForShip() -> CGFloat {
        return ship.angle
    }
    
    func toggleThruster(thrusterOn: Bool) {
        ship.thrusterOn = thrusterOn
    }
    
    func getShipPosition() -> CGPoint {
        return ship.position
    }
    
    func getAsteroidPositions() -> [String: [AsteroidObject]] {
        //this function needs to pass back all of the asteroid positions, not just the spawn points.
        return asteroids // returns the entire asteroids dictionary back to the gameView
    }
}
