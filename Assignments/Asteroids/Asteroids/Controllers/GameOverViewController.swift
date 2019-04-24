//
//  GameOverViewController.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/19/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController, GameOverViewDelegate {
    
    var score: Int
    private var highScores: [(name: String, score: Int)]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        score = 0
        highScores = []
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var gameOverView: GameOverView {
        return view as! GameOverView
    }
    
    override func loadView() {
        view = GameOverView()
    }
    
    func gameOverViewReturnToMain() {
        UserDefaults.standard.set(false, forKey: "gameExists")
        saveGameState() // Ensure that this is what needs to be done here.
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameOverView.delegate = self
        let highScores = loadSavedScores()
        if highScores.isEmpty || highScores[highScores.count - 1].score <= score || highScores.count < 10 {
            gameOverView.setPlayerNameField()
        }
    }
    
    func gameOverView(saveGameFor player: String) {
        var highScores = loadSavedScores()
        if highScores.isEmpty {
            saveGameScores(scores: [HighScores(name: player, score: score)])
            UserDefaults.standard.set(false, forKey: "gameExists")
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            return
        }
        
        highScores.sort(by: {$0.score < $1.score})
        if highScores[0].score > score && highScores.count < 10 {
            highScores.insert(HighScores(name: player, score: score), at: 0)
            saveGameScores(scores: highScores.sorted(by: {$0.score > $1.score}))
            UserDefaults.standard.set(false, forKey: "gameExists")
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            return
        }
        
        var i: Int = 0
        while i < highScores.count {
            if highScores[i].score > score {
                break
            }
            i += 1
        }
        highScores.insert(HighScores(name: player, score: score), at: i)
        
        if highScores.count > 10 {
            highScores.removeFirst()
        }
        
        saveGameScores(scores: highScores.sorted(by: {$0.score > $1.score}))
        UserDefaults.standard.set(false, forKey: "gameExists")
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameOverView.setScoreLabel(score: score)
        gameOverView.reloadData()
        //Check Userdefaults for highscores
    }
    
    func saveGameScores(scores: [HighScores]) {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        do {
            try scores.save(to: docDirectory.appendingPathComponent(Constants.highScoresFile))
        } catch let error where error is HighScores.Error {
            print(error)
        } catch {
            print(error)
        }
    }
    
    func saveGameState() {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        do {
            try Asteroids(width: Float(UIScreen.main.bounds.width), height: Float(UIScreen.main.bounds.height)).save(to: docDirectory.appendingPathComponent(Constants.asteroidsFile))
        } catch let error where error is Asteroids.Error {
            print(error)
        } catch {
            print(error)
        }
    }
    
    func loadSavedScores() -> [HighScores] {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonData = try! Data(contentsOf: docDirectory.appendingPathComponent(Constants.highScoresFile))
        let highScores = try! JSONDecoder().decode([HighScores].self, from: jsonData)
        return highScores
    }
}
