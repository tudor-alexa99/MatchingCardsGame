//
//  Array+Int.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 04.09.2023.
//

import Foundation

extension Array where Element == Int {
    static func generatePairs(maximumNumberOfPairs: Int) -> [Int] {
        // Ensure that the maximum number of pairs is non-negative
        guard maximumNumberOfPairs >= 0 else {
            return []
        }
        
        // Calculate the total count of elements in the resulting array
        let totalCount = maximumNumberOfPairs * 2
        
        // Create an array with values from 0 to maximumNumberOfPairs
        let rangeArray = Array(0..<maximumNumberOfPairs)
        
        // Duplicate the rangeArray and shuffle it
        var resultArray = (rangeArray + rangeArray).shuffled()
        
        // Trim the resultArray to the desired totalCount
        if resultArray.count > totalCount {
            resultArray = Array(resultArray.prefix(totalCount))
        }
        
        return resultArray
    }
}
