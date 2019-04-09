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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        asteroidsGame = Asteroids()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var gameView: GameView {
        return view as! GameView
    }
    
    func gameView(accelerateShipIn gameView: GameView) {
        asteroidsGame.accelerateShip()
    }
    
    func gameView(getPositionForShipIn gameView: GameView) -> CGPoint {
        return asteroidsGame.getShipPosition()
    }
    
    func gameView(updateAngleIn gameView: GameView, for shipAngle: CGFloat) {
        asteroidsGame.setAngleForShip(with: shipAngle)
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
        asteroidsGame.setFrameForView(with: gameView.frame)
        gameView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        asteroidsGame.setFrameForView(with: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        gameView.reloadData()
    }
}
