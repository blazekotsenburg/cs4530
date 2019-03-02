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
    let homeViewController: HomeViewController = HomeViewController()
    var viewController: UIViewController = UIViewController()
//    var t: UIViewController.Type
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
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
//        viewController = homeViewController.topMostViewController()
//        let t = type(of: viewController)
//
//        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        //        print(docDirectory)
//        do {
//            if t == HomeViewController.self {
//                if let viewController = viewController as? HomeViewController {
//                    try viewController.gamesList.save(to: docDirectory.appendingPathComponent(Constants.battleShipListFile))
//                    let gamesData = try! JSONEncoder().encode(viewController.gamesList)
//                    UserDefaults.standard.set(gamesData, forKey: "Games")
//                }
////                try (viewController as! HomeViewController).gamesList.save(to: docDirectory.appendingPathComponent(Constants.battleShipListFile))
////                UserDefaults.standard.setValue(docDirectory, forKey: "Games")
//            }
//            else if t == GameViewController.self {
//                if let viewController = viewController as? GameViewController {
//                    try viewController.gamesList.save(to: docDirectory.appendingPathComponent(Constants.battleShipListFile))
//                    let gamesData = try! JSONEncoder().encode(viewController.gamesList)
//                    UserDefaults.standard.set(gamesData, forKey: "Games")
////                    print(UserDefaults.standard.data(forKey: "Games"))
//                }
////                try (viewController as! GameViewController).gamesList.save(to: docDirectory.appendingPathComponent(Constants.battleShipListFile))
////                UserDefaults.standard.setValue(docDirectory, forKey: "Games")
//            }
//            else if t == SwitchPlayerViewController.self {
//                if let viewController = viewController as? SwitchPlayerViewController {
//                    try viewController.gamesList.save(to: docDirectory.appendingPathComponent(Constants.battleShipListFile))
//                    UserDefaults.standard.setValue(viewController.gamesList, forKey: "Games")
//                }
////                try (viewController as! SwitchPlayerViewController).gamesList.save(to: docDirectory.appendingPathComponent(Constants.battleShipListFile))
//            }
//        } catch let error where error is BattleShip.Error {
//            print(error)
//        } catch {
//            print(error)
//        }
//
//        let arr = UserDefaults.standard.data(forKey: "Games")
//        print(arr)
//        let arr = UserDefaults.standard.data(forKey: "Games")
//        UserDefaults.standard.set(<#T##url: URL?##URL?#>, forKey: <#T##String#>)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        let count = UserDefaults.standard.integer(forKey: "Count")
//        print(count)
        //        print()
//        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        let jsonData = try! Data(contentsOf: docDirectory.appendingPathComponent(Constants.battleShipListFile))
//        let t = type(of: viewController)
//
//        if t == HomeViewController.self {
//            (viewController as! HomeViewController).gamesList = try! JSONDecoder().decode([BattleShip].self, from: jsonData)
//            gamesList = (viewController as! HomeViewController).gamesList
//        }
//        else if t == GameViewController.self {
//            (viewController as! GameViewController).gamesList = try! JSONDecoder().decode([BattleShip].self, from: jsonData)
//            gamesList = (viewController as! GameViewController).gamesList
//        }
//        else if t == SwitchPlayerViewController.self {
//            (viewController as! SwitchPlayerViewController).gamesList = try! JSONDecoder().decode([BattleShip].self, from: jsonData)
//            gamesList = (viewController as! SwitchPlayerViewController).gamesList
//        }
        
//        print(gamesList.count)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        UserDefaults.
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
