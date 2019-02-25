//
//  AppDelegate.swift
//  Rectangles
//
//  Created by Blaze Kotsenburg on 1/30/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        
        let mainView: UIView = window!.rootViewController!.view
        mainView.backgroundColor = .lightGray
        
        let redView: UIView = UIView()
        redView.backgroundColor = .red
        redView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(redView)
        
        let greenView: UIView = UIView()
        greenView.backgroundColor = .green
        greenView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(greenView)
        
        let blueView: UIView = UIView()
        blueView.backgroundColor = .cyan
        blueView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(blueView)
        
        let views: [String : Any] = ["red": redView, "green": greenView, "blue": blueView]
        //LOOKUP: edges extended layout?
        mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[red]-12-|", options: [], metrics: nil, views: views))
        mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[red]-[green]-12-|", options: [], metrics: nil, views: views))
        mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[green]-12-|", options: [], metrics: nil, views: views))
        mainView.addConstraint(NSLayoutConstraint(item: redView, attribute: .width, relatedBy: .equal, toItem: greenView, attribute: .width, multiplier: 1.0, constant: 0.0))
        
        return true
    }
}

