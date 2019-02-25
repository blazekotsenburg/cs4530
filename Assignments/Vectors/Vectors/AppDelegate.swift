//
//  AppDelegate.swift
//  Vectors
//
//  Created by Blaze Kotsenburg on 1/16/19.
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
        
        window?.rootViewController?.view.backgroundColor = UIColor.green
        let mainView: UIView = window!.rootViewController!.view
        
        let vector0XSlider: UISlider = UISlider()
        vector0XSlider.frame = CGRect(x: 10.0, y: 60.0, width: 280.0, height: 40.0)
        vector0XSlider.addTarget(self, action: #selector(vectorChanged), for: .valueChanged)
        mainView.addSubview(vector0XSlider)
        
        let vector1XSlider: UISlider = UISlider()
        vector1XSlider.frame = CGRect(x: 10.0, y: 110.0, width: 280.0, height: 40.0)
        mainView.addSubview(vector1XSlider)
        
        let vector2XSlider: UISlider = UISlider()
        vector2XSlider.frame = CGRect(x: 10.0, y: 160.0, width: 280.0, height: 40.0)
        mainView.addSubview(vector2XSlider)
        
        let vector3XSlider: UISlider = UISlider()
        vector3XSlider.frame = CGRect(x: 10.0, y: 210.0, width: 280.0, height: 40.0)
        mainView.addSubview(vector3XSlider)
        return true
    }
    
    @objc func vectorChanged(sender: Any) {
        // sender: UISlider does not guarantee that it will be UISlider. This is a mix of Swift and Obj-C and is BAD!
        // TODO: Do stuff when vector slider changed
        
        let vector0XSlider: UISlider? = sender as? UISlider //always check that it is actually the type that you expect, because it does not check for you.
        if let vector0XSlider = vector0XSlider {
            print("Changed to: \(vector0XSlider.value)")
        }
    }
    
    func updateAddition(vector0X: Float, vector0Y: Float, vector1X: Float, vector1Y: Float) {
        // Could just pass in each UISlider as well. Making them properties of the class.
        let vectorResultX: Float = vector0X + vector1X
        let vectorResultY: Float = vector0Y + vector1Y
    }
}

