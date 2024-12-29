//
//  Processor.swift
//  Numbers
//
//  Created by Alex Maggio on 28/12/2024.
//
import Foundation
import Combine
import SwiftUI

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
    private var musicVolume: Double = Double(AudioManager.shared.volumeBGM) {
        didSet {
            AudioManager.shared.setMusicVolume(Float(musicVolume))
        }
    }
    private var soundVolume: Double = Double(AudioManager.shared.volumeSFX) {
        didSet {
            AudioManager.shared.setSFXVolume(Float(soundVolume))
        }
    }

    private var startTime: Date?
    private var timer: Timer!
    private var isPaused: Bool = false
    @Published var score: TimeInterval = 0

    func scoreRepresentation() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: score) ?? ""
    }


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
            self.startTime = Date()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            self.isPaused = false
        case .navigateToSettings:
            coordinator.currentRoute.append(.settings)
        case .tapOnTile:
            handleGameAction(action)
        case .pause:
            isPaused = true
        case .unpause:
            isPaused = false
        }
    }

    @objc
    private func update() {
        guard !isPaused else { return }
        let elapsedTime = Date().timeIntervalSince(startTime!)
//        score = Double(Int(elapsedTime) * 100) / Double(100)
        score = Double(elapsedTime * Double(100)) / Double(100)
    }

    private func handleSettingsAction(_ settingsAction: ProcessorAction) {
        switch settingsAction {
        case .changeDifficulty(let gameDifficulty):
            self.difficulty = gameDifficulty
            self.perform(.startNewGame)
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
            withAnimation(.easeInOut(duration: 0.2)) {
                if self.board.doMove(tile) {
                    self.board = Board(
                        rows: self.board.rows,
                        columns: self.board.columns,
                        maxShuffles: difficulty.shufflesRequired,
                        cells: self.board.cells
                    )

                    if self.board.isSolved() {
                        self.perform(.pause)
                        self.coordinator.currentRoute.append(.gameOver(.win))
                    }
                }
            }
        default:
            break
        }
    }
}

class ScoreManager {
    private init() {}
    static let shared = ScoreManager()

    func getTopScores(for difficulty: GameDifficulty) -> [TimeInterval] {
        var retValue: [TimeInterval] = []

        for score in 0 ..< 10 {
            if let aScore = UserDefaults.standard.object(forKey: "score_\(score)_\(difficulty)") as? TimeInterval {
                retValue.append(aScore)
            }
        }

        return retValue
    }


    func addScore(for difficulty: GameDifficulty, score: TimeInterval) {
        var scores = getTopScores(for: difficulty)
        scores.append(score)
        scores = scores.sorted()
        scores = scores.prefix(upTo: 10).map(\.self)

        for score in 0 ..< 10 {
            UserDefaults.standard.set(scores[score], forKey: "score_\(score)_\(difficulty)")
        }
    }

    func getMinHighScore(for difficulty: GameDifficulty) -> TimeInterval {
        getTopScores(for: difficulty).min() ?? TimeInterval.infinity
    }
}
