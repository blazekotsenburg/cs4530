//
//  regexMatch.swift
//  ShoppingList
//
//  Created by Blaze Kotsenburg on 1/8/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import Foundation

extension String {
    
    /**
     * Returns a boolean based on whether a string matches a specific regex pattern by using the .range().
     *
     * @params: regexPattern - the String type pattern used to compare against the invkoking string.
     *
     * @return: True if the string matches the pattern of the regex and false if the string doesn't
     * conform to the pattern of the regex (ie. .range() found no occurance of the string in the regex and returned nil)
     */
    func matches(_ regexPattern: String) -> Bool {
        
        // .range finds and returns the range of the first occurrence of a given string within a given range of the string,
        // subject to given options, using the specified locale, if any.
        return self.range(of: regexPattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
