//
//  GameViewController.swift
//  Asteroids
//
//  Created by Blaze Kotsenburg on 4/3/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameViewDelegate {
    
    
    var gameView: GameView {
        return view as! GameView
    }
    
    override func loadView() {
        view = GameView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.delegate = self
        gameView.reloadData()
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        gameView.setNeedsLayout()
//    }
}
