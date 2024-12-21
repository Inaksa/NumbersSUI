//
//  Board.swift
//  Numbers
//
//  Created by Alex Maggio on 19/12/2024.
//

import Foundation

struct Position {
    let row: Int
    let column: Int
}

public struct Board {
    private(set) var cells: [Tile] = []
    let rows: Int
    let columns: Int

    private let shuffleTimes: Int
    private var isShuffling: Bool = false

    init(rows: Int, columns: Int, maxShuffles: Int, cells: [Tile]? = nil) {
        self.rows = rows
        self.columns = columns
        self.shuffleTimes = maxShuffles

        if let cells = cells {
            self.cells = cells
        } else {
            for item in 0 ..< rows * columns - 1 {
                let tile = Tile.symbol(item + 1)
                self.cells.append(tile)
            }
            self.cells.append(.empty)
        }
    }

    func isSolved() -> Bool {
        var retValue: Bool = true

        if let lastTile = cells.last, lastTile != .empty {
            return false
        }
        
        var prevItem: Tile = .empty
        cells
            .forEach { item in
                if item != .empty {
                    retValue = retValue && (prevItem.isNext(item))
                    prevItem = item
                }
            }
        return retValue
    }

    func getTile(at position: Position) -> Tile? {
        guard position.row * columns + position.column < cells.count else { return nil }
        return cells[position.row * columns + position.column]
    }

    mutating func shuffle() {
        guard !isShuffling else { return }
        isShuffling = true
        var shuffledCellCount = shuffleTimes
        var seenIndices: [Int] = Array(0 ..< (rows * columns))

        while shuffledCellCount > 0 {
            guard let randomIndex = seenIndices.randomElement() else {
                seenIndices = Array(0 ..< (rows * columns))
                continue
            }
            let randomRow = randomIndex / columns
            let randomColumn = randomIndex - randomRow * columns
            if let aTile = getTile(at: Position(row: randomRow, column: randomColumn)) {
                doMove(aTile)
                seenIndices.removeAll { $0 == randomIndex }
                shuffledCellCount -= 1
            }
        }

        isShuffling = false
    }
    
    mutating func doMove(_ tile: Tile) {
        guard let tilePosition = cells.firstIndex(of: tile) else { return }
        let tileRow = tilePosition / columns
        let tileColumn = tilePosition - tileRow * columns

        var validPositionsToCheck: [Position] = [
            Position(row: tileRow - 1, column: tileColumn),
            Position(row: tileRow + 1, column: tileColumn),
            Position(row: tileRow, column: tileColumn - 1),
            Position(row: tileRow, column: tileColumn + 1)
        ]
        validPositionsToCheck.removeAll { position in
            position.row < 0            ||
            position.row > rows         ||
            position.column < 0         ||
            position.column >= columns  ||
            position.row * columns + position.column >= cells.count
        }

        validPositionsToCheck.forEach { position in
            if let destinationTile = getTile(at: position),
               case destinationTile = .empty,
               let destinationIndex = cells.firstIndex(of: destinationTile) {
                cells.swapAt(tilePosition, destinationIndex)
//                cells.remove(at: tilePosition)
//                cells.insert(.empty, at: tilePosition)
            }
        }
    }

    var toString: String {
        var retValue: String = ""
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                switch getTile(at: Position(row: row, column: column)) {
                case .empty, .none:
                    retValue += "E "
                case .symbol(let symbol):
                    let symbolRepresentation = "\(symbol)  ".prefix(2)
                    retValue = retValue + symbolRepresentation
                }
                retValue += "\t"
            }
            retValue += "\n"
        }

        return retValue
    }
}
