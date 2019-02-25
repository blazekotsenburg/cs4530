//
//  LeftView.swift
//  ManualLayout
//
//  Created by Blaze Kotsenburg on 1/28/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class LeftView: UIView {
    
    lazy var innerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.purple
        self.addSubview(view)
        return view
    }()
    
    lazy var view1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        return view
    }()
    lazy var view2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        self.addSubview(view)
        return view
    }()
    lazy var view3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        self.addSubview(view)
        return view
    }()
    lazy var view4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        self.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds.insetBy(dx: 10.0, dy: 10.0)
        innerView.frame = rect
        
        rect = rect.insetBy(dx: 5.0, dy: 5.0)
        (view1.frame, rect) = rect.divided(atDistance: rect.height * 0.25, from: .minYEdge)
        (view2.frame, rect) = rect.divided(atDistance: view1.frame.height, from: .minYEdge)
        (view3.frame, view4.frame) = rect.divided(atDistance: view1.frame.height, from: .minYEdge)
    }
}
