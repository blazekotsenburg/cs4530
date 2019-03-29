//
//  GameDetailViewController.swift
//  Project4
//
//  Created by Blaze Kotsenburg on 3/29/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController, GameDetailViewDelegate {
    
    var gameDetailView: GameDetailView {
        return view as! GameDetailView
    }
    
    override func loadView() {
        view = GameDetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameDetailView.delegate = self
        gameDetailView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gameDetailView.reloadData()
    }
}
