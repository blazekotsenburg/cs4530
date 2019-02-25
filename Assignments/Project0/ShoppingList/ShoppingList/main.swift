//
//  main.swift
//  ShoppingList
//
//  Created by Blaze Kotsenburg on 1/7/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import Foundation

// dictionary containing the item name (String) and quantity of item (Int).
var items = [String : Int]()
// regex patterns used for valid input checking
let patternWithQuantity = "\\b[a-zA-Z]+: [0-9]+\\b"
let patternNoQuantity   = "\\b[a-zA-Z]+\\b"

// describe to the user how to use the shopping list and then prompt the user to input items and quantities.
print("Enter shopping list items with format 'itemName: quantity' or just the 'itemName' for singular item.")
print("Once you have completed your shopping list, hit return once more to print the list and finish program.")
var item = readLine()

// repeat prompts while the user does not terminate program
while item != "" {
    
    // regex validation check, checks for single 'item' (ie apple) as well as 'item: quantity' format (ie apple: 5).
    // loop will keep prompting user for input until the user provides a valid input.
    while !item!.matches(patternWithQuantity) && !item!.matches(patternNoQuantity) {
        print("Ensure that your input is in the correct format: 'itemName: quantity' or 'itemName'.")
        item = readLine()
    }
    
    // check that the optional has a value and is not null (this avoids force unwrapping item throughought scope of the condition)
    if let item = item {
        
        //check for pattern 'item: quantity', handle as needed
        if item.matches(patternWithQuantity) {
            var parsedItem = item.split(separator: ":")
            let quantity = Int(String(parsedItem[1]).trimmingCharacters(in: .whitespacesAndNewlines))
            let itemName = String(parsedItem[0])
            
            if let val = items[itemName] {
                items[itemName] = val + quantity!
            }
            else {
                items[itemName] = quantity
            }
        }
        //check for pattern 'item', handle as needed
        else if item.matches(patternNoQuantity) {
            if let val = items[item] {
                items[item] = val + 1
            }
            else {
                items[item] = 1
            }
        }
    }
    // user input has been collected, prompt user again
    item = readLine()
}

var sortedItems  : [String] = []

// get the keys of each item in the dictionary so that they can be sorted in alphabetical order
for item in items {
    sortedItems.append(item.key)
}

sortedItems.sort()

// print the shopping list in corresponding order while accessing the corresponding quantities to each item.
for item in sortedItems {
    if let quantity = items[item] {
        print("\(item): " + quantity.description)
    }
}
