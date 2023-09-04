//
//  Theme.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 04.09.2023.
//

import Foundation
import UIKit

struct Theme: Codable {
    let title: String
    let cardColor: CardColor?
    let cardSymbol: String
    let symbols: [String]

    enum CodingKeys: String, CodingKey {
        case title
        case cardColor = "card_color"
        case cardSymbol = "card_symbol"
        case symbols
    }

    func getSymbol(at index: Int) -> String {
        guard symbols.count > index else { fatalError("Index out of range for symbol") }

        return symbols[index]
    }
}

struct CardColor: Codable {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat

    enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode the color components from the snake_case keys
        red = try container.decode(CGFloat.self, forKey: .red)
        green = try container.decode(CGFloat.self, forKey: .green)
        blue = try container.decode(CGFloat.self, forKey: .blue)
    }

    func toUIColor() -> UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
