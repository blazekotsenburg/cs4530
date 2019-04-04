//
//  SwitchPlayerViewController.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/27/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class SwitchPlayerViewController: UIViewController, SwitchPlayerViewDelegate {
    
    var status: String = ""
    
    var switchPlayerView: SwitchPlayerView {
        return view as! SwitchPlayerView
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func loadView() {
        view = SwitchPlayerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchPlayerView.delegate = self
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        switchPlayerView.status.text = status
//    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchPlayerView(_ switchPlayerView: SwitchPlayerView, playerReady: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func switchPlayerView(getLaunchStatus switchPlayerView: SwitchPlayerView) -> String {
        return status
    }
}
