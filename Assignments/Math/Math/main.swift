//
//  main.swift
//  Math
//
//  Created by Blaze Kotsenburg on 1/9/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import Foundation

// class is a reference type, setting any class to an existing class and changing the data will update both of the objects.
// lookup copy unwrite

// value type
struct Vector {
    var x: Double
    var y: Double
}

let v: Vector = Vector(x: 10.0, y: 7.0)


let x: Int? = 5

print("x: \(x!)")

let y: Double? = 7.0
let z: String? = "asdf"

// you have to break scope with the guard statement, it avoids tree of doom. 
guard let unwrappedY = y else {
    exit(0)
}

guard let unwrappedZ = z else {
    exit(0)
}

// both of these assignments must not be nil in order continue past this conditional.
guard let unwrappedY = y, let unwrappedZ = z else {
    exit(0)
}

