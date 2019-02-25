//
//  AppDelegate.swift
//  OtherViews
//
//  Created by Blaze Kotsenburg on 2/4/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UIViewController()
        
        let mainView: UIView = window!.rootViewController!.view
        let colorTableView: UITableView = UITableView(frame: mainView.frame)
        colorTableView.dataSource = self
        colorTableView.delegate = self
        colorTableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        mainView.addSubview(colorTableView)
        
        return true
    }
    
    //Put the delegates into their respective extensions to help maintain readability
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 510
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self)) as? TableViewCell else {
            fatalError("Coulod not dequeue reusable cell of type: \(TableViewCell.self)")
        }
        _ = cell.increment
//        cell.contentView.addSubview(<#T##view: UIView##UIView#>) this is where you can actually customize a cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let color = UIColor(hue: CGFloat(indexPath.row) / 42.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        cell.backgroundColor = color
        cell.textLabel?.text = "hello, world: \(indexPath.row)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 42
    }
}

