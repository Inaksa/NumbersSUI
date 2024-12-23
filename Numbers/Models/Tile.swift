//
//  Tile.swift
//  Numbers
//
//  Created by Alex Maggio on 19/12/2024.
//

import Foundation

enum Tile: Equatable, Hashable {
    case empty
    case symbol(Int)

    func isNext(_ nextTile: Tile) -> Bool {
        switch self {
        case .empty:
            return true
        case .symbol(let symbol):
            return nextTile == .symbol(symbol + 1)
        }
    }
}
