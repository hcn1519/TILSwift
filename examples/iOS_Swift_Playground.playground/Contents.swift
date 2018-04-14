//: Playground - noun: a place where people can play

import UIKit

let arr1 = ["hello", "world", "it", "is", "swift"]
let arr2 = [0, 1, 2, 3, 4]

// zip Method: zip(sequence1: Sequence, sequence2: Sequence)
for (str, num) in zip(arr1, arr2) {
    print("\(num): \(str)")
}

// Result
//0: hello
//1: world
//2: it
//3: is
//4: swift

let dict1: [String: Int] = ["Hello": 0, "Swift": 1]

for (str, (key: key, value: value)) in zip(arr1, dict1) {
    print("\(str): \(value) - \(key)")
}

// Result
// hello: 1 - Swift
// world: 0 - Hello

let arr3 = ["a", "b", "c", "d", "e"]

for (label, (str, num)) in zip(arr3, (zip(arr1, arr2))) {
    print("\(label), \(num): \(str)")
}

// Result
//a, 0: hello
//b, 1: world
//c, 2: it
//d, 3: is
//e, 4: swift
