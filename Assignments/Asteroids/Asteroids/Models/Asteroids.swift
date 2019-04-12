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
        var velocity: (x: CGFloat, y: CGFloat) //might need a vector
        var acceleration: (x: CGFloat, y: CGFloat)
        var position: CGPoint
        var thrusterOn: Bool
        var rotatingLeft: Bool
        var rotatingRight: Bool
    }
    //TODO: - Need a way of managing asteroids
    private var initialFrame: CGRect = CGRect()
    private var numberOfLives: Int = Int()
    private var score: Int = Int()
    private var gameLoopTimer: Timer = Timer()
    private var ship: Ship = Ship(angle: 0.0, velocity: (0.0, 0.0), acceleration: (x: 0.0, y: 0.0), position: CGPoint(x: 0.0, y: 0.0), thrusterOn: false, rotatingLeft: false, rotatingRight: false)
    private var lastDate: Date
    var width: Float
    var height: Float
    //TODO: - Update positions of objects
    //TODO: - Detect collisions between objects
    
    var dataSource: AsteroidsDataSource?
    
    init(width: Float, height: Float) {
        self.width = width
        self.height = height
        lastDate = Date()
        beginTimer()
    }
    
    func beginTimer() {
        gameLoopTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true, block: { _ in
            // TODO: Calculate elapsed time
            let now: Date = Date()
            let elapsed: TimeInterval = now.timeIntervalSince(self.lastDate)
            self.lastDate = now
            
            self.executeGameLoop(elapsed: elapsed)
//            self.decreaseShipAcceleration()
        })
    }
    
    //should be called from game loop
    private func executeGameLoop(elapsed: TimeInterval) {
        
        if ship.rotatingRight {
            ship.angle += CGFloat(elapsed) * 2.0
        }
        else if ship.rotatingLeft {
            ship.angle -= CGFloat(elapsed) * 2.0
        }
        
        ship.acceleration.x = ship.thrusterOn ? sin(ship.angle) * 50.0 : -ship.velocity.x * 0.5
        ship.acceleration.y = ship.thrusterOn ? -cos(ship.angle) * 50.0 : -ship.velocity.y * 0.5
        
        ship.velocity.x += ship.acceleration.x * CGFloat(elapsed)
        ship.position.x += ship.velocity.x * CGFloat(elapsed)
        ship.velocity.y += ship.acceleration.y * CGFloat(elapsed)
        ship.position.y += ship.velocity.y * CGFloat(elapsed)
        
        //convert the angle in radians to degrees
//        let angleInDegrees = ((ship.angle * 180) / .pi) - .pi/2

//        ship.position.x = ship.velocityO * cos(angleInDegrees)
//        ship.position.y = ship.velocityO * sin(angleInDegrees)
        
//        ship.position.x -= ship.velocityO * 1.0/120.0 + 0.5 * ship.acceleration * pow(1.0/120.0, 2)
//        let elapsedTime = Date.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate
//        print(currentDate.timeIntervalSinceReferenceDate)
//        print(elapsedTime)
        
//        ship.position.x = ship.positionO.x + ship.velocityO.x * CGFloat(elapsedTime) + 0.5 * ship.acceleration * pow(CGFloat(elapsedTime), 2)
//        ship.position.y = ship.positionO.y + ship.velocityO.y * CGFloat(elapsedTime) + 0.5 * ship.acceleration * pow(CGFloat(elapsedTime), 2)
        
//        ship.position.x = ship.positionO.x + ship.velocityO.x * 1.0/60.0 + 0.5 * ship.acceleration * pow(1.0/60.0, 2)
//        ship.position.y = ship.positionO.y + ship.velocityO.y * 1.0/60.0 + 0.5 * ship.acceleration * pow(1.0/60.0, 2)
    }
    
    func setFrameForView(with rect: CGRect) {
        initialFrame = rect
        ship.position = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
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
}
