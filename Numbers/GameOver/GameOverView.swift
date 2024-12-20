//
//  GameOverView.swift
//  Numbers
//
//  Created by Alex Maggio on 20/12/2024.
//

import SwiftUI

struct GameOverView: View {
    let gameStatus: GameStatus
    var body: some View {
        VStack {
            Text("Game Over")
                .font(.title)
            Text("Result: \(gameStatus)")
        }
    }
}

#Preview {
    GameOverView(gameStatus: .win)
}
