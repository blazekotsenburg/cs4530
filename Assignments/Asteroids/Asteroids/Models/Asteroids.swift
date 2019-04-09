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
        var velocityF: CGFloat //might need a vector
        var velocityO: CGFloat
        var acceleration: CGFloat
        var positionF: CGPoint
        var positionO: CGPoint
    }
    //TODO: - Need a way of managing asteroids
    private var initialFrame: CGRect = CGRect()
    private var numberOfLives: Int = Int()
    private var score: Int = Int()
    private var gameLoopTimer: Timer = Timer()
    private var ship: Ship = Ship(angle: 0.0, velocityF: 0.0, velocityO: 0.0, acceleration: 0.0, positionF: CGPoint(x: 0.0, y: 0.0), positionO: CGPoint(x: 0.0, y: 0.0))
    //TODO: - Update positionFs of objects
    //TODO: - Detect collisions between objects
    
    var dataSource: AsteroidsDataSource?
    
    init() {
        beginTimer()
    }
    
    func beginTimer() {
        gameLoopTimer = Timer.scheduledTimer(withTimeInterval: 1.0/120.0, repeats: true, block: { (gameLoopTimer) in
            self.updateShippositionFs()
//            self.decreaseShipAcceleration()
        })
    }
    
    //should be called from game loop
    private func updateShippositionFs() {
        increaseShipVelocity()
        //TODO: - Update x and y positionFs for ship
//        ship.positionF.x = ((ship.velocityF - ship.velocityO) / 2) * 1.0/60.0
        ship.positionF.x -= ship.velocityO * 1.0/120.0 + 0.5 * ship.acceleration * pow(1.0/120.0, 2)
//        ship.positionF.x -= 1
        
//        print(ship.positionF)
    }
    
    private func increaseShipVelocity() {
        ship.velocityF = ship.velocityO + ship.acceleration * 1.0/60.0
        ship.velocityO = ship.velocityF
    }
    
    private func decreaseShipAcceleration() {
        if ship.acceleration > 0.0 {
            ship.acceleration -= 0.5 //consider decreasing at faster rate than increasing velocity
        }
    }
    
    func setFrameForView(with rect: CGRect) {
        initialFrame = rect
        ship.positionF = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
    }
    
    func setAngleForShip(with newAngle: CGFloat) {
        ship.angle = newAngle
    }
    
    func accelerateShip() {
        //TODO: - update the acceleration of the ship in the direction of the velocity vector
        ship.acceleration += 10.0
    }
    
    func getShippositionF() -> CGPoint {
        return ship.positionF
    }
}
