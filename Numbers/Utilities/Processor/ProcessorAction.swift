//
//  ProcessorAction.swift
//  Numbers
//
//  Created by Alex Maggio on 28/12/2024.
//


enum ProcessorAction {
    case changeDifficulty(GameDifficulty)
    case changeMusicVolume(Double)
    case changeSoundVolume(Double)
    case startNewGame
    case navigateToSettings
    case tapOnTile(Tile)
    case pause
    case unpause
}
