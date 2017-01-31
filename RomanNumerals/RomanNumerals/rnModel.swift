//
//  rnModel.swift
//  RomanNumerals
//
//  Created by Kevin Zeckser on 5/26/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

import Foundation

class RNManager {
    
    static let sharedInstance = RNManager()
    // MARK: Properties
    
    fileprivate let romanNumerals = [("M",1000),("CM",900), ("D",500),("CD",400),("C",100),("XC",90),("L",50),("XL",40),("X",10),("IX",9),("V",5),("IV",4),("I",1)]
    fileprivate let romanSystem :Dictionary<String,Int> = ["I": 1, "IV": 4, "V": 5, "IX": 9, "X": 10, "L": 50, "C": 100, "D": 500,"CM": 900,"M": 1000]
    
    
    // MARK: Functions
    
    // Conversion with loop iteration
    func convertToRomanNumeral(_ input :Int) -> String {
        
        guard input > 0 && input < 4001 else { return "Not a valid number." }
        
        var total = input
        var output = ""
        
        for (letter, number) in romanNumerals {
            while total >= number {
                total -= number
                output += letter
            }
        }
        return output
    }
    
    // Conversion with recursive call & dictionary
    func recursiveRomanNumeral(_ input :Int) -> String {
        
        guard input > 0 && input < 4001 else { return "" }
        
        var min: Int = Int.max
        var output :String = ""
        var previousChar :String = "I"
        var previousNumber :Int = 1
        
        for (letter, number) in romanSystem {
            
            if input - number >= 0 {
                if input - number < min {
                    min = input - number
                    previousChar = letter
                    previousNumber = number
                }
                
            }
        }
        output += previousChar
        output = output + recursiveRomanNumeral(input - previousNumber)
        return output
    }
}
