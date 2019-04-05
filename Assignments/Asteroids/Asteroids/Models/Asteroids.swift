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
    //TODO: - Need a way of managing asteroids
    private var initialFrame: CGRect = CGRect()
    private var numberOfLives: Int = Int()
    private var score: Int = Int()
    private var gameLoopTimer: Timer = Timer()
    //TODO: - Implement a game loop
    //TODO: - Update positions of objects
    //TODO: - Detect collisions between objects
    
    var dataSource: AsteroidsDataSource?
    
    init() {
        
    }
    
    func setFrameForView(with rect: CGRect) {
        initialFrame = rect
    }
}
