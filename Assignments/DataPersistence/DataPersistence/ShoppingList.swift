//
//  ShoppingList.swift
//  DataPersistence
//
//  Created by Blaze Kotsenburg on 2/25/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import Foundation

struct ShoppingList: Codable {
    
    enum Error: Swift.Error {
        case encoding
        case writing
    }
    
    var storeName: String
    var items: [String]
}


extension Array where Element == ShoppingList {
    func save(to url: URL) throws {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            throw ShoppingList.Error.encoding
        }
        guard (try? jsonData.write(to: url)) != nil else {
            throw ShoppingList.Error.writing
        }
//        do{
//            try jsonData.write(to: url)
//        } catch {
//            ShoppingList.Error.writing
//        }
    }
    
    init(from url: URL) throws {
        let jsonData = try! Data(contentsOf: url)
        self  = try JSONDecoder().decode([ShoppingList].self, from: jsonData)
    }
}
