//
//  NumbersApp.swift
//  Numbers
//
//  Created by Alex Maggio on 19/12/2024.
//

import SwiftUI

enum GameStatus {
    case win
    case inProgress
    case lost
}

enum Route: Hashable {
    case home
    case menu
    case settings
    case game
    case gameOver(GameStatus)
}

class AppCoordinator: ObservableObject {
    @Published var currentRoute: [Route] = [.home]

    func dismiss() {
        if currentRoute.count > 1 {
            currentRoute.removeLast()
        }

        if currentRoute.last == .home {
            currentRoute = [.home]
        }
    }
}

enum ProcessorAction {
    case changeDifficulty(GameDifficulty)
    case changeMusicVolume(Double)
    case changeSoundVolume(Double)
    case startNewGame
    case navigateToSettings
    case tapOnTile(Tile)
}

class Processor: ObservableObject {
    enum Configuration {
        static let initialDifficulty: GameDifficulty = .hard
        static let initialMusicVolume: Double = 0.7
        static let initialSoundVolume: Double = 0.7
    }
    let coordinator: AppCoordinator
    @Published var difficulty: GameDifficulty = Configuration.initialDifficulty {
        didSet {
            self.board = Board(
                rows: difficulty.gameSize.columns,
                columns: difficulty.gameSize.rows,
                maxShuffles: difficulty.shufflesRequired
            )
            self.board.shuffle()
        }
    }
    private var musicVolume: Double = Configuration.initialMusicVolume
    private var soundVolume: Double = Configuration.initialSoundVolume

    @Published var board: Board = Board(
        rows: Configuration.initialDifficulty.gameSize.columns,
        columns: Configuration.initialDifficulty.gameSize.rows,
        maxShuffles: Configuration.initialDifficulty.shufflesRequired
    )

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func perform(_ action: ProcessorAction) {
        switch action {
        case .changeDifficulty, .changeMusicVolume, .changeSoundVolume:
            handleSettingsAction(action)
        case .startNewGame:
            print("Starting new game")
            var board = Board(
                rows: difficulty.gameSize.columns,
                columns: difficulty.gameSize.rows,
                maxShuffles: difficulty.shufflesRequired
            )
            board.shuffle()
            self.board = board
        case .navigateToSettings:
            coordinator.currentRoute.append(.settings)
        case .tapOnTile:
            handleGameAction(action)
        }
    }

    private func handleSettingsAction(_ settingsAction: ProcessorAction) {
        switch settingsAction {
        case .changeDifficulty(let gameDifficulty):
            self.difficulty = gameDifficulty
        case .changeMusicVolume(let volume):
            self.musicVolume = volume
        case .changeSoundVolume(let volume):
            self.soundVolume = volume
        default:
            break
        }
    }
    private func handleGameAction(_ gameAction: ProcessorAction) {
        switch gameAction {
        case .tapOnTile(let tile):
            self.board.doMove(tile)
            self.board = Board(
                rows: self.board.rows,
                columns: self.board.columns,
                maxShuffles: difficulty.shufflesRequired,
                cells: self.board.cells
            )

            if self.board.isSolved() {
                self.coordinator.currentRoute.append(.gameOver(.win))
            }
        default:
            break
        }
    }
}

@main
struct NumbersApp: App {
    let processor = Processor(coordinator: AppCoordinator())
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(processor.coordinator)
                .environmentObject(processor)
        }
    }
}
