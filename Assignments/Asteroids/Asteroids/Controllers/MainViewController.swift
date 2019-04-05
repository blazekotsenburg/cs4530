//
//  MainViewController.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MainViewDelegate {
    
    func mainView(presentHighScoresFor mainView: MainView) {
        let highScoresViewController: HighScoresViewController = HighScoresViewController()
        present(highScoresViewController, animated: true, completion: nil)
    }
    
    func mainView(presentGameViewFor mainView: MainView) {
        let gameViewController: GameViewController = GameViewController()
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
        mainView.reloadData()
    }
}

