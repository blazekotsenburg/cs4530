//
//  ViewController.swift
//  DataPersistence
//
//  Created by Blaze Kotsenburg on 2/25/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var shoppingLists: [ShoppingList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<5 {
            var shoppingList = ShoppingList.init(storeName: "\(i)", items: [i, i+1,i+2].map(String.init))
//            print(shoppingList)
            shoppingLists.append(shoppingList)
        }
        
//        print()
//        print(shoppingLists)
    }


}

