//
//  TableViewCell.swift
//  OtherViews
//
//  Created by Blaze Kotsenburg on 2/4/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let lock = NSLock()
    static var count: Int = 0 {
        didSet {
            print(count)
        }
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
