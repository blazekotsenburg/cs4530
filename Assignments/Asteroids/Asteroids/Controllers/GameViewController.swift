//
//  GameViewController.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameViewDelegate, AsteroidsDataSource {
    
    var asteroidsGame: Asteroids?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        asteroidsGame?.dataSource = self
    }
    
    override func loadView() {
        view = GameView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var gameView: GameView {
        return view as! GameView
    }
    
    func gameView(getAngleForShipIn gameView: GameView) -> Float {
        return asteroidsGame!.getAngleForShip()
    }
    
    func gameView(rotateLeftPressed gameView: GameView, rotating: Bool) {
        asteroidsGame!.rotateShipLeft(isRotatingLeft: rotating)
    }
    
    func gameView(rotateRightPressed gameView: GameView, rotating: Bool) {
        asteroidsGame!.rotateShipRight(isRotatingRight: rotating)
    }
    
    func gameView(thrusterPressed gameView: GameView, thrusterOn: Bool) {
        asteroidsGame!.toggleThruster(thrusterOn: thrusterOn)
    }
    
    func gameView(shootButtonToggled gameView: GameView, fireProjectile: Bool) {
        asteroidsGame!.fireProjectile(isFiringProjectile: fireProjectile)
    }
    
    func gameView(getPositionForShipIn gameView: GameView) -> (x: Float, y: Float) {
        return asteroidsGame!.getShipPosition()
    }
    
    func gameView(getAsteroidPositionsIn gameView: GameView) -> [String: [AsteroidObject]] {
        return asteroidsGame!.getAsteroidPositions()
    }
    
    func gameView(getBulletPositionsIn gameView: GameView) -> [(x: Float, y: Float)] {
        return asteroidsGame!.getBulletPositions()
    }
    
    func gameView(homeButtonPressed: GameView) {
        saveGameState()
        gameView.timer.invalidate()
        asteroidsGame?.gameLoopTimer.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    func gameView(getAngleForAsteroiFor key: String, at index: Int) -> Float {
        return asteroidsGame!.angleForAsteroid(key: key, index: index)
    }
    
    func asteroids(shipCollisionDetectedFor asteroidsGame: Asteroids) {
        gameView.removeShip()
    }
    
    func asteroids(removeAsteroidWith key: String, at index: Int) {
        gameView.removeAsteroid(key: key, index: index)
    }
    
    func asteroids(updateScoreWith newScore: Int) {
        gameView.setScoreLabel(with: newScore.description)
    }
    
    func asteroids(updateLivesWith livesString: String) {
        gameView.setLivesLabel(with: livesString)
    }
    
    func asteroids(gameOverWith: Int) {
        gameView.timer.invalidate()
        asteroidsGame?.gameLoopTimer.invalidate()
        let gameOverViewController: GameOverViewController = GameOverViewController()
        gameOverViewController.score = gameOverWith
        present(gameOverViewController, animated: true, completion: nil)
    }
    
    func togglePause(pauseGame: Bool) {
//        asteroidsGame?.toggleGameState(gamePaused: pauseGame)
        if pauseGame {
            asteroidsGame?.gameLoopTimer.invalidate()
            gameView.timer.invalidate()
        }
        else {
            gameView.beginTimer()
            asteroidsGame?.beginTimer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.delegate = self
        asteroidsGame!.dataSource = self
//        gameView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        asteroidsGame?.beginTimer()
        gameView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        gameView.reloadData()
    }
    
    func saveGameState() {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        do {
            try asteroidsGame!.save(to: docDirectory.appendingPathComponent(Constants.asteroidsFile))
        } catch let error where error is Asteroids.Error {
            print(error)
        } catch {
            print(error)
        }
    }
    
    func loadSavedGame() {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonData = try! Data(contentsOf: docDirectory.appendingPathComponent(Constants.asteroidsFile))
        asteroidsGame = try! JSONDecoder().decode(Asteroids.self, from: jsonData)
    }
}
