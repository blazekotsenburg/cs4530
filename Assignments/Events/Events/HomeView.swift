//
//  HomeView.swift
//  Events
//
//  Created by Blaze Kotsenburg on 2/13/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class HomeView: UIView {
    var label: UILabel = UILabel()
    var button: UIButton = UIButton()
    
    override init(frame: CGRect) {
        label = UILabel()
        super.init(frame: frame)
        
        let stackView = UIStackView()
        addSubview(stackView)
        
        label.backgroundColor = UIColor.lightGray
        label.textAlignment = .center
        addSubview(label)
        stackView.addArrangedSubview(label)
        
        button.setTitle("Go!", for: .normal)
        stackView.addArrangedSubview(button)
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
