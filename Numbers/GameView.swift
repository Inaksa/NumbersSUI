//
//  GameView.swift
//  Numbers
//
//  Created by Alex Maggio on 19/12/2024.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var processor: Processor

    @State private var presentMenu: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color.white
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        HStack {
                            Text("Score: ")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            Text(processor.scoreRepresentation())
                                .foregroundColor(Color.white)
                        }
                        .font(.custom(Styles.fontName, size: 60))
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                        .background { Color.green }
                        BoardView(processor: _processor)
                    }
                    .padding(.vertical)
                }
            }
            .overlay(alignment: .topTrailing) {
                HStack {
                    Spacer()
                    Button {
                        processor.perform(.navigateToSettings)
                    } label: {
                        Image(systemName: "pause.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                    }
                    .buttonStyle(NormalButton())
                }
                .padding(.horizontal)
            }
        }
        .fullScreenCover(
            isPresented: Binding(get: {
                coordinator.currentRoute.last == .menu
            }, set: { newValue in
                coordinator.dismiss()
            }),
            content: {
                MainMenu()
                    .presentationBackground {
                        Color.black
                            .opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                coordinator.dismiss()
                            }
                    }
            }
        )
        .fullScreenCover(
            isPresented: Binding(get: {
                coordinator.currentRoute.last == .settings
            }, set: { newValue in
                coordinator.dismiss()
                processor.perform(.unpause)

            }),
            content: {
                SettingsView()
                    .presentationBackground {
                        Color.black
                            .opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                coordinator.dismiss()
                            }
                    }
            }
        )
        .fullScreenCover(isPresented: Binding(get: {
            switch coordinator.currentRoute.last {
            case .gameOver:
                return true
            default:
                return false
            }
        }, set: { newValue in
            coordinator.dismiss()
        }), content: {
            switch coordinator.currentRoute.last {
            case .gameOver(let gamestatus):
                GameOverView(
                    gameStatus: gamestatus,
                    isHighScore: ScoreManager.shared.getMinHighScore(for: processor.difficulty) >= processor.score,
                    score: processor.score
                )
                    .presentationBackground {
                        Color.black
                            .opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                coordinator.dismiss()
                            }
                    }
            default:
                EmptyView()
            }
        })
//        .padding()
        .onAppear() {
            AudioManager.shared.startMusic()
        }
    }
}

#Preview {
    let coordinator = AppCoordinator()
    let processor = Processor(coordinator: coordinator)

    GameView()
        .environmentObject(processor.coordinator)
        .environmentObject(processor)
}
