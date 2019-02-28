//
//  ViewController.swift
//  Complications
//
//  Created by Blaze Kotsenburg on 2/27/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var bitchSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bitchSlider.value = 0.0
    }
}

