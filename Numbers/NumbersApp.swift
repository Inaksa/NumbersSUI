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
