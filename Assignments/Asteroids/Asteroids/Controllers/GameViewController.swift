//
//  GameViewController.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameViewDelegate, AsteroidsDataSource {
    
    private var asteroidsGame: Asteroids
    private var lock: NSLock
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        asteroidsGame = Asteroids(width: 1.0, height: Float(UIScreen.main.bounds.width / UIScreen.main.bounds.height))
        asteroidsGame = Asteroids(width: Float(UIScreen.main.bounds.width), height: Float(UIScreen.main.bounds.height))
        lock = NSLock()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var gameView: GameView {
        return view as! GameView
    }
    
    func gameView(getAngleForShipIn gameView: GameView) -> Float {
        return asteroidsGame.getAngleForShip()
    }
    
    func gameView(rotateLeftPressed gameView: GameView, rotating: Bool) {
        asteroidsGame.rotateShipLeft(isRotatingLeft: rotating)
    }
    
    func gameView(rotateRightPressed gameView: GameView, rotating: Bool) {
        asteroidsGame.rotateShipRight(isRotatingRight: rotating)
    }
    
    func gameView(thrusterPressed gameView: GameView, thrusterOn: Bool) {
        asteroidsGame.toggleThruster(thrusterOn: thrusterOn)
    }
    
    func gameView(shootButtonToggled gameView: GameView, fireProjectile: Bool) {
        asteroidsGame.fireProjectile(isFiringProjectile: fireProjectile)
    }
    
    func gameView(getPositionForShipIn gameView: GameView) -> (x: Float, y: Float) {
        return asteroidsGame.getShipPosition()
    }
    
    func gameView(getAsteroidPositionsIn gameView: GameView) -> [String: [AsteroidObject]] {
        return asteroidsGame.getAsteroidPositions()
    }
    
    func gameView(acquireLockFor gameView: GameView, lockAcquired: Bool) {
        if lockAcquired {
            lock.lock()
        }
        else {
            lock.unlock()
        }
    }
    
    func asteroids(toggleLockFor asteroidsGame: Asteroids, lockAcquired: Bool) {
        if lockAcquired {
            lock.lock()
        }
        else {
            lock.unlock()
        }
    }
    
    func asteroids(shipCollisionDetectedFor asteroidsGame: Asteroids) {
        gameView.removeShip()
    }
    
    override func loadView() {
        view = GameView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.delegate = self
        asteroidsGame.dataSource = self
//        gameView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        gameView.reloadData()
    }
}
