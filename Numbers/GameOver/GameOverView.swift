//
//  GameOverView.swift
//  Numbers
//
//  Created by Alex Maggio on 20/12/2024.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var processor: Processor

    let gameStatus: GameStatus

    @State private var showTiles = false
    @State private var showCheckmark = false

    let score: Int
    let tileNumbers = Array(1...5)

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                // Victory Text
                Text("Game Over")
                    .font(.custom(Styles.fontName, size: 60))
                    .foregroundColor(.blue)

                // Score
                Text("SCORE: \(score)")
                    .font(.custom(Styles.fontName, size: 50))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)

            HStack(spacing: 10) {
                ForEach(tileNumbers, id: \.self) { number in
                    NumberTile(number: number)
                        .offset(y: showTiles ? 0 : -50)
                        .opacity(showTiles ? 1 : 0)
                        .animation(
                            .spring(
                                response: 0.5,
                                dampingFraction: 0.7,
                                blendDuration: 0
                            )
                            .delay(Double(number - 1) * 0.1),
                            value: showTiles
                        )
                }
            }
                .padding(.vertical, 30)
                .padding(.horizontal)

            if isHighscore {
                VStack(spacing: 15) {
                    Text("This is a new high score!")
                        .font(.custom(Styles.fontName, size: 50).bold())
                        .foregroundColor(Color(red: 0.02, green: 0.59, blue: 0.41))
                        .multilineTextAlignment(.center)

                    // Checkmark
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 10))
                        path.addLine(to: CGPoint(x: 10, y: 20))
                        path.addLine(to: CGPoint(x: 30, y: 0))
                    }
                    .trim(from: 0, to: showCheckmark ? 1 : 0)
                    .stroke(Color(red: 0.02, green: 0.59, blue: 0.41), lineWidth: 4)
                    .frame(width: 30, height: 20)
                    .animation(.easeInOut(duration: 0.5).delay(0.5), value: showCheckmark)
                }
                .padding(.horizontal)
            }

            Button {
                coordinator.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 40, height: 40)
                    .background(Color.black)
                    .clipShape(Circle())
                    .foregroundStyle(.white)
            }
            .padding(.vertical)

        }
        .padding()
        .background(content: { Color.white })
        .clipShape(RoundedRectangle(cornerRadius: Styles.CornerRadius.large))
        .onAppear {
            showTiles = true
            showCheckmark = true
        }
    }

    private let isHighscore: Bool = true
}

struct NumberTile: View {
    let number: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(red: 0.15, green: 0.39, blue: 0.92))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(red: 0.12, green: 0.25, blue: 0.69), lineWidth: 2)
                )
                .frame(width: 50, height: 50)

            Text("\(number)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.orange)
        }
    }
}

#Preview {
    let coordinator = AppCoordinator()
    let processor = Processor(coordinator: coordinator)

    GameOverView(gameStatus: .win, score: 100)
        .environmentObject(processor.coordinator)
        .environmentObject(processor)
}
