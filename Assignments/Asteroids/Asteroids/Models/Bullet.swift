//
//  Bullet.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/18/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import Foundation

struct Bullet {
    var position: (x: Float, y: Float)
    var stepSize: (x: Float, y: Float)
    var angle: Float
    var spawnedAt: Date
}
