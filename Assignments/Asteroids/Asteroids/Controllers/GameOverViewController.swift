//
//  GameOverViewController.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/19/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController, GameOverViewDelegate {
    var gameOverView: GameOverView {
        return view as! GameOverView
    }
    
    override func loadView() {
        view = GameOverView()
    }
    
    func gameOverViewReturnToMain() {
        UserDefaults.standard.set(false, forKey: "gameExists")
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameOverView.delegate = self
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
}
