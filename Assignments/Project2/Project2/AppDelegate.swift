//
//  AppDelegate.swift
//  Project2
//
//  Created by Blaze Kotsenburg on 2/2/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var timeZoneLabel: UILabel = UILabel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        
        let mainView: UIView = window!.rootViewController!.view
        mainView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        
        let clockView: ClockView = ClockView()
        clockView.backgroundColor = .clear
        clockView.translatesAutoresizingMaskIntoConstraints = false
        clockView.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        mainView.addSubview(clockView)
        
        let width: CGFloat = mainView.frame.width
        
        timeZoneLabel.text = clockView.getTimeZoneLabel()
        timeZoneLabel.font = UIFont(name: "Avenir", size: 17.0)
        timeZoneLabel.textAlignment = .center
        timeZoneLabel.backgroundColor = .clear
        timeZoneLabel.textColor = .white
        timeZoneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let clockStackView: UIStackView = UIStackView(arrangedSubviews: [timeZoneLabel, clockView])
        clockStackView.axis = .vertical
        clockStackView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(clockStackView)
        
        let views: [String : Any] = ["clockView" : clockView, "clockStackView" : clockStackView, "timeZoneLabel" : timeZoneLabel]
        
        clockStackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[timeZoneLabel(<=\(width))]-|", options: [], metrics: nil, views: views))
        clockStackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[timeZoneLabel(<=20)]-10-[clockView]-|", options: [], metrics: nil, views: views))
        clockStackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[clockView(<=\(width))]-0-|", options: [], metrics: nil, views: views))
        clockStackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[timeZoneLabel]-0-[clockView(<=\(width))]", options: [], metrics: nil, views: views))
        
        mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[clockStackView(<=\(width))]-|", options: [], metrics: nil, views: views))
        mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[clockStackView(<=\(width))]-|", options: [], metrics: nil, views: views))
        
        return true
    }
    
    @objc func valueChanged(sender: Any) {
        
        if let clockView: ClockView = sender as? ClockView {
            timeZoneLabel.text = clockView.getTimeZoneLabel()
        }
    }
}

