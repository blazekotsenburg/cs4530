//
//  TableViewCell.swift
//  Project3
//
//  Created by Blaze Kotsenburg on 4/3/19.
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
        textLabel?.textAlignment = .left
        detailTextLabel?.textAlignment = .left
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
