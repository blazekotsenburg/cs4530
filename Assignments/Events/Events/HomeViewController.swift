//
//  ViewController.swift
//  Events
//
//  Created by Blaze Kotsenburg on 2/13/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func loadView() {
        super.loadView()
        view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.lightGray
        contentView.label.textAlignment = .center
        contentView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        print("pressed")
        // present
    }

    var contentView: HomeView {
        return view as! HomeView
    }

}

