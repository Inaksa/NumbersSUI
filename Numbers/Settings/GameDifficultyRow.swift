//
//  GameDifficultyRow.swift
//  Numbers
//
//  Created by Alex Maggio on 19/12/2024.
//
import Foundation
import SwiftUI

struct GameDifficultyRow: View {
    enum Configuration {
        static let gameDifficultyItemSize: CGFloat = 35
        static var gameItemFont: Font {
            .custom(Styles.fontName, size: gameDifficultyItemSize)
        }
    }

    let difficulty: GameDifficulty
    let currentDifficulty: GameDifficulty

    var body: some View {
        HStack {
            Image(systemName: difficulty.rawValue == currentDifficulty.rawValue ? "checkmark.circle" : "circle")
            Text(difficulty.displayValue)
                .font(Configuration.gameItemFont)
            Spacer()
        }
    }
}
