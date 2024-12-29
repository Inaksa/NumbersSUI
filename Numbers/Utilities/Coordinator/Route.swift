//
//  Route.swift
//  Numbers
//
//  Created by Alex Maggio on 28/12/2024.
//

enum Route: Hashable {
    case home
    case menu
    case settings
    case game
    case gameOver(GameStatus)
}
