//
//  NewGameViewController.swift
//  Project4
//
//  Created by Blaze Kotsenburg on 3/21/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController, NewGameViewDelegate {
    
    var webURL: URL = URL(string: "http://174.23.159.139:2142/api/lobby")!
    var guidDict: [String: String] = [:]
    
    var newGameView: NewGameView {
        return view as! NewGameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGameView.delegate = self
        newGameView.reloadData()
    }
    
    override func loadView() {
        view = NewGameView()
    }
    
    func newGameView(createGameFor newGameView: NewGameView) {
        var post: URLRequest = URLRequest(url: webURL)
        post.httpMethod = "POST"
        let dataString: [String: Any] = ["gameName": newGameView.gameNameTextField.text!, "playerName": newGameView.playerNameTextField.text!]
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
            if let dataForGUID = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                DispatchQueue.main.async { [weak self] in
                    self?.guidDict.updateValue(dataForGUID["playerId"]!, forKey: dataForGUID["gameId"]!)
                    self?.saveGameState()
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        task.resume()
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
