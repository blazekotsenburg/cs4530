//
//  AppDelegate.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/20/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var gamesList: [BattleShip]?
    let homeViewController: HomeViewController = HomeViewController()
    var viewController: UIViewController = UIViewController()
//    var t: UIViewController.Type
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        homeViewController.gamesList = [BattleShip()]
        window?.rootViewController = homeViewController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        print(window?.rootViewController?.topMostViewController())
        viewController = homeViewController.topMostViewController()
        let t = type(of: viewController)
        
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        //        print(docDirectory)
        do {
            if t == HomeViewController.self {
                try (viewController as! HomeViewController).gamesList.save(to: docDirectory.appendingPathComponent(Constants.battleShipListFile))
            }
            else if type(of: viewController) == GameViewController.self {
//            else if t == GameViewController.self {
                try (viewController as! GameViewController).gamesList.save(to: docDirectory.appendingPathComponent(Constants.battleShipListFile))
            }
            else if t == SwitchPlayerViewController.self {
                try (viewController as! SwitchPlayerViewController).gamesList.save(to: docDirectory.appendingPathComponent(Constants.battleShipListFile))
            }
        } catch let error where error is BattleShip.Error {
            print(error)
        } catch {
            print(error)
        }
        
//        viewController.shoppingLists = []
//        let count = UserDefaults.standard.integer(forKey: "Count") + 1
//        UserDefaults.standard.set(count, forKey: "Count")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        let count = UserDefaults.standard.integer(forKey: "Count")
//        print(count)
        //        print()
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonData = try! Data(contentsOf: docDirectory.appendingPathComponent(Constants.battleShipListFile))
        let t = type(of: viewController)
        if t == HomeViewController.self {
            (viewController as! HomeViewController).gamesList = try! JSONDecoder().decode([BattleShip].self, from: jsonData)
            print((viewController as! HomeViewController).gamesList)
        }
        else if t == GameViewController.self {
            (viewController as! GameViewController).gamesList = try! JSONDecoder().decode([BattleShip].self, from: jsonData)
            print((viewController as! GameViewController).gamesList)
        }
        if t == SwitchPlayerViewController.self {
            (viewController as! SwitchPlayerViewController).gamesList = try! JSONDecoder().decode([BattleShip].self, from: jsonData)
            print((viewController as! SwitchPlayerViewController).gamesList)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let jsonData = try! Data(contentsOf: docDirectory.appendingPathComponent(Constants.battleShipListFile))
        let t = type(of: viewController)
        if t == HomeViewController.self {
            (viewController as! HomeViewController).gamesList = try! JSONDecoder().decode([BattleShip].self, from: jsonData)
            print((viewController as! HomeViewController).gamesList)
        }
        else if t == GameViewController.self {
            (viewController as! GameViewController).gamesList = try! JSONDecoder().decode([BattleShip].self, from: jsonData)
            print((viewController as! GameViewController).gamesList)
        }
        if t == SwitchPlayerViewController.self {
            (viewController as! SwitchPlayerViewController).gamesList = try! JSONDecoder().decode([BattleShip].self, from: jsonData)
            print((viewController as! SwitchPlayerViewController).gamesList)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

/**
 This extension includes a recursive function that continues to retrieve the last presented UIViewController on top of the stack
 
 - Return: The top most UIViewController from the stack
 */
extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            if let visibleController = navigation.visibleViewController {
                return visibleController.topMostViewController()
            }
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
