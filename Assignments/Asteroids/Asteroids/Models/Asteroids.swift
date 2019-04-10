//
//  Asteroids.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/4/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

protocol AsteroidsDataSource {
    
}

class Asteroids {
    
    struct Ship {
        var angle: CGFloat
        var velocityF: (x: CGFloat, y: CGFloat) //might need a vector
        var velocityO: (x: CGFloat, y: CGFloat)
        var acceleration: CGFloat
        var positionF: CGPoint
        var positionO: CGPoint
    }
    //TODO: - Need a way of managing asteroids
    private var initialFrame: CGRect = CGRect()
    private var numberOfLives: Int = Int()
    private var score: Int = Int()
    private var gameLoopTimer: Timer = Timer()
    private var ship: Ship = Ship(angle: 0.0, velocityF: (0.0, 0.0), velocityO: (0.0, 0.0), acceleration: 0.0, positionF: CGPoint(x: 0.0, y: 0.0), positionO: CGPoint(x: 0.0, y: 0.0))
    private var currentDate: Date
    //TODO: - Update positionFs of objects
    //TODO: - Detect collisions between objects
    
    var dataSource: AsteroidsDataSource?
    
    init() {
        currentDate = Date()
        beginTimer()
    }
    
    func beginTimer() {
        gameLoopTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true, block: { (gameLoopTimer) in
            self.updateShipPosition()
//            self.decreaseShipAcceleration()
        })
    }
    
    //should be called from game loop
    private func updateShipPosition() {
        increaseShipVelocity() // this likely does not need to be called here
        
        //TODO: - Update x and y positionFs for ship
        
        //convert the angle in radians to degrees
//        let angleInDegrees = ((ship.angle * 180) / .pi) - .pi/2

//        ship.positionF.x = ship.velocityO * cos(angleInDegrees)
//        ship.positionF.y = ship.velocityO * sin(angleInDegrees)
        
//        ship.positionF.x -= ship.velocityO * 1.0/120.0 + 0.5 * ship.acceleration * pow(1.0/120.0, 2)
        let elapsedTime = Date.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate
//        print(currentDate.timeIntervalSinceReferenceDate)
//        print(elapsedTime)
        
        ship.positionF.x = ship.positionO.x + ship.velocityO.x * CGFloat(elapsedTime) + 0.5 * ship.acceleration * pow(CGFloat(elapsedTime), 2)
        ship.positionF.y = ship.positionO.y + ship.velocityO.y * CGFloat(elapsedTime) + 0.5 * ship.acceleration * pow(CGFloat(elapsedTime), 2)
    }
    
    private func increaseShipVelocity() {
//        ship.velocityF = ship.velocityO + ship.acceleration * 1.0/60.0
//        ship.velocityO = ship.velocityF
        let angleInDegrees = ((ship.angle * 180) / .pi) - .pi/2
        ship.velocityO.x = ship.velocityO.x * cos(angleInDegrees)
        ship.velocityO.y = ship.velocityO.y * sin(angleInDegrees)
        
        let elapsedTime = Date.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate
        
        ship.velocityF.x = ship.velocityO.x + ship.acceleration * CGFloat(elapsedTime)
        ship.velocityF.y = ship.velocityO.y + ship.acceleration * CGFloat(elapsedTime)
    }
    
    private func decreaseShipAcceleration() {
        if ship.acceleration > 0.0 {
            ship.acceleration -= 1.0 //consider decreasing at faster rate than increasing velocity
        }
        else {
            ship.acceleration = 0.0
        }
    }
    
    func setFrameForView(with rect: CGRect) {
        initialFrame = rect
        ship.positionO = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
    }
    
    func setAngleForShip(with newAngle: CGFloat) {
        ship.angle = newAngle
    }
    
    func accelerateShip() {
        //TODO: - update the acceleration of the ship in the direction of the velocity vector
        ship.acceleration += 1.0
    }
    
    func getShipPosition() -> CGPoint {
        return ship.positionF
    }
}
