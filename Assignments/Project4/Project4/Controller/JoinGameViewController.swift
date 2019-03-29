//
//  JoinGameViewController.swift
//  Project4
//
//  Created by Blaze Kotsenburg on 3/27/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class JoinGameViewController: UIViewController, JoinGameViewDelegate {
    
    var webURL: URL = URL(string: "http://174.23.159.139:2142/api/lobby")!
    var guidDict: [String: String] = [String: String]()
    var guid: String = ""
    
    var joinGameView: JoinGameView {
        return view as! JoinGameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinGameView.delegate = self
        joinGameView.reloadData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func loadView() {
        view = JoinGameView()
    }
    
    func joinGameView(for joinGameView: JoinGameView) {
        let joinGameURL: URL = URL(string: "http://174.23.159.139:2142/api/lobby/\(guid)")!
        var post: URLRequest = URLRequest(url: joinGameURL)
        post.httpMethod = "PUT"
        let dataString: [String: String] = ["playerName": joinGameView.playerNameTextField.text!, "id": guid]
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dataString, options: [])
            post.httpBody = jsonData
        } catch {
            print("Error creating JSON string.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: post) { [weak self] (data, response, error) in
            guard error == nil else {
                fatalError("URL has failed.")
            }
            
            guard let data = data,
                let dataString = String(bytes: data, encoding: .utf8) else {
                    fatalError("no data to work with")
            }
            print(dataString)
            if let playerData = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                DispatchQueue.main.async { [weak self] in
                    self?.guidDict.updateValue(playerData["playerId"]!, forKey: (self?.guid)!)
                    self?.saveGameState()
                    let gameViewController: GameViewController = GameViewController()
                    gameViewController.guid = (self?.guid)!
                    gameViewController.playerId = playerData["playerId"]!
                    self?.present(gameViewController, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    
    func joinGameView(exitGameViewFor joinGameView: JoinGameView) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveGameState() {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        do {
            guard let jsonData = try? JSONEncoder().encode(guidDict) else {
                throw BattleShip.Error.encoding
            }
            guard (try? jsonData.write(to: docDirectory.appendingPathComponent(Constants.gameListFile))) != nil else {
                throw BattleShip.Error.writing
            }
        } catch let error where error is BattleShip.Error {
            print(error)
        } catch {
            print(error)
        }
    }
}

