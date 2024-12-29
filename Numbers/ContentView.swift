//
//  ContentView.swift
//  Numbers
//
//  Created by Alex Maggio on 19/12/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var processor: Processor

    @State private var presentMenu: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                BoardView(processor: _processor)
                    .padding(.bottom)
                Button {
                    processor.perform(.navigateToSettings)
                } label: {
                    Text("Toggle Menu")
                }
                .buttonStyle(MenuButton())
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
                GameOverView(gameStatus: gamestatus, isHighScore: false, score: 100)
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
        .padding()
        .onAppear() {
            AudioManager.shared.startMusic()
        }
    }
}

#Preview {
    let coordinator = AppCoordinator()
    let processor = Processor(coordinator: coordinator)

    ContentView()
        .environmentObject(processor.coordinator)
        .environmentObject(processor)
}
