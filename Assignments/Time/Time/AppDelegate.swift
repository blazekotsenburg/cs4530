//
//  AppDelegate.swift
//  Time
//
//  Created by Blaze Kotsenburg on 1/23/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = UIViewController()
        
        //This is the view we will use to draw in
        let clockView: ClockView = ClockView()
        clockView.frame = CGRect(x: 20.0, y: 10.0, width: 280.0, height: 400.0)
        clockView.backgroundColor = UIColor.lightGray
        window?.rootViewController?.view.addSubview(clockView)
        
        return true
    }
}

