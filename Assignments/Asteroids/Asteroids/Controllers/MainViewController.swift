//
//  MainViewController.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MainViewDelegate {
    
    var asteroidsGame: Asteroids?
    
    func mainView(presentHighScoresFor mainView: MainView) {
        let highScoresViewController: HighScoresViewController = HighScoresViewController()
        present(highScoresViewController, animated: true, completion: nil)
    }
    
    func mainView(presentGameViewFor mainView: MainView) {
        let gameViewController: GameViewController = GameViewController()
        if let _ = asteroidsGame {
            gameViewController.asteroidsGame = self.asteroidsGame!
        }
        else {
            gameViewController.asteroidsGame = Asteroids(width: Float(UIScreen.main.bounds.width), height: Float(UIScreen.main.bounds.height))
        }
//        if gameViewController.asteroidsGame.isGamePaused() {
//            gameViewController.asteroidsGame.toggleGameState(gamePaused: false)
//        }
        present(gameViewController, animated: true, completion: nil)
    }
    
    var mainView: MainView {
        return view as! MainView
    }
    
    override func loadView() {
        view = MainView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        mainView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "hasLoggedInBefore") {
            UserDefaults.standard.set(true, forKey: "hasLoggedInBefore")
            saveGameState()
        }
        else {
            loadSavedGame()
        }
        
        mainView.reloadData()
    }
    
    func saveGameState() {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        do {
            try asteroidsGame?.save(to: docDirectory.appendingPathComponent(Constants.asteroidsFile))
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
        mainView.setGameButtonText(with: "Resume")
    }
}

