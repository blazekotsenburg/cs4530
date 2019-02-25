//
//  AppDelegate.swift
//  Viewing
//
//  Created by Blaze Kotsenburg on 1/14/19.
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
        
        let view: UIView = UIView()
        view.backgroundColor = UIColor.cyan
        view.frame = CGRect(x: 30.0, y: 70.0, width: 300.0, height: 100.0)
        window?.rootViewController?.view.addSubview(view)
        
        let subview: UIView = UIView()
        subview.backgroundColor = UIColor.red
        subview.frame = CGRect(x: 10.0, y: 10.0, width: 200.0, height: 20.0)
        
        let toggle: UISwitch = UISwitch()
        toggle.frame = CGRect(x: 30.0, y: 30.0, width: 200.0, height: 50.0)
        window?.rootViewController?.view.addSubview(toggle)
        
        let label: UILabel = UILabel()
        label.text = "Hello, World!"
        label.frame = CGRect(x: 10.0, y: 10.0, width: 200.0, height: 20.0)
        label.backgroundColor = UIColor.orange
        label.textColor = UIColor.green
        window?.rootViewController?.view.addSubview(label)
        
        view.addSubview(subview)
        
        return true
    }
}

