//
//  TableViewCell.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 2/24/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let lock = NSLock()
    static var count: Int = 0 {
        didSet {
//            print(count)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    override func draw(_ rect: CGRect) {
//        textLabel!.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: textLabel!.frame.width, height: frame.height)
//        textLabel?.numberOfLines = 2
//        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.textAlignment = .center
//
//        let detailLabelXOrigin = frame.origin.x + textLabel!.frame.width
//        let detailLabelYOrigin = frame.origin.y
//        detailTextLabel!.frame = CGRect(x: 0, y: 0, width: frame.width * 0.666, height: frame.height)
//        detailTextLabel?.numberOfLines = 2
//        detailTextLabel?.lineBreakMode = .byWordWrapping
        detailTextLabel?.textAlignment = .center
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let increment: Void = {
        TableViewCell.lock.lock()
        defer{ TableViewCell.lock.unlock() }
        TableViewCell.count += 1
    }()
    
    deinit {
        TableViewCell.lock.lock()
        defer{ TableViewCell.lock.unlock() }
        TableViewCell.count -= 1
    }
}
