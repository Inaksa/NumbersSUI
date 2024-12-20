//
//  GameDifficulty.swift
//  Numbers
//
//  Created by Alex Maggio on 19/12/2024.
//
import Foundation

struct BoardSize {
    let rows: Int
    let columns: Int
}

enum GameDifficulty: Int, Identifiable, CaseIterable {
    case debug = 3
    case easy = 0
    case medium = 1
    case hard = 2

    var gameSize: BoardSize {
        switch self {
        case .debug: return BoardSize(rows: 2, columns: 2)
        case .easy: return BoardSize(rows: 3, columns: 3)
        case .medium: return BoardSize(rows: 4, columns: 4)
        case .hard: return BoardSize(rows: 5, columns: 5)
        }
    }


    var displayValue: String {
        let title: String = "\(self)"
        let boardSize: String = "\(self.gameSize.rows)x\(self.gameSize.columns)"
        return "\(title.capitalized) (\(boardSize))"
    }

    static var items: [GameDifficulty] {
        [debug, easy, medium, hard]
    }

    var id: Int { rawValue }

    var shufflesRequired: Int {
        switch self {
        case .debug: return 100
        case .easy: return 1000
        case .medium: return 2000
        case .hard: return 3000
        }
    }
}
