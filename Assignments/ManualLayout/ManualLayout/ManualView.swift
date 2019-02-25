//
//  ManualView.swift
//  ManualLayout
//
//  Created by Blaze Kotsenburg on 1/28/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class ManualView: UIView {
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cyan
        self.addSubview(view)
        return view
    }()
    
    lazy var leftView: UIView = {
        let view = LeftView()
        view.backgroundColor = .blue
        self.addSubview(view)
        return view
    }()
    
    lazy var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerView)
//        addSubview(leftView)
//        addSubview(rightView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        (headerView.frame, rect) = rect.divided(atDistance: frame.height * 0.15, from: .minYEdge)
        (leftView.frame, rightView.frame) = rect.divided(atDistance: frame.width * 0.5, from: .minXEdge)
    }
}
