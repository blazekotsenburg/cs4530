//
//  GameDetailViewController.swift
//  Project4
//
//  Created by Blaze Kotsenburg on 3/29/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController, GameDetailViewDelegate {
    
    var guid: String = ""
    
    var gameDetailView: GameDetailView {
        return view as! GameDetailView
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        
        getGameDetails()
        gameDetailView.reloadData()
    }
    
    func gameDetailView(dismiss gameDetailView: GameDetailView) {
        dismiss(animated: true, completion: nil)
    }
    
    private func getGameDetails() {
        let webURL: URL = URL(string: "http://174.23.159.139:2142/api/lobby/\(guid)")!
        let loadBoardTask = URLSession.shared.dataTask(with: webURL) { [weak self] (data, response, error) in
            guard error == nil else {
                fatalError("URL dataTask failed: \(error!)")
            }
            guard let data = data,
                let dataString = String(bytes: data, encoding: .utf8) else {
                    fatalError("no data to work with")
            }
            print(dataString)
            if let gameDetailData = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DispatchQueue.main.async {
                    if let gameDetailView = self?.gameDetailView {
                        gameDetailView.gameNameLabel.text = "Game name: \(gameDetailData["name"] as? String ?? "Unavailable")"
                        gameDetailView.playerLabel.text = "Player 1: \(gameDetailData["player1"] as? String ?? "Unavailable")"
                        gameDetailView.opponentLabel.text = "Player 2: \(gameDetailData["player1"] as? String ?? "Unavailable")"
                        var winner = ""
                        if gameDetailData["winner"] as? String == "IN_PROGRESS" {
                            winner = "N/A"
                        }
                        else {
                            winner = gameDetailData["winner"] as! String
                        }
                        gameDetailView.winnerLabel.text = "Winner: \(winner)"
                        gameDetailView.gameStatusLabel.text = "Game status: \(gameDetailData["status"] as? String ?? "Unavailable")"
                        gameDetailView.totalMissilesLaunchedLabel.text = "Total missiles launched: \(gameDetailData["missilesLaunched"] as? String ?? "Unavailable")"
                    }
                }
            }
        }
        loadBoardTask.resume()
    }
}
