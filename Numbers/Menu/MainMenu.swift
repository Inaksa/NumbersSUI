//
//  Menu.swift
//  Numbers
//
//  Created by Alex Maggio on 19/12/2024.
//

import SwiftUI

enum MenuOption: CaseIterable, Identifiable {
    case newGame
    case settings
    
    var id: Self { self }
    
    var label: String {
        switch self {
        case .newGame:
            return "New Game"
        case .settings:
            return "Settings"
        }
    }

    var associatedAction: ProcessorAction {
        switch self {
        case .newGame:
            return .startNewGame
        case .settings:
            return .navigateToSettings
        }
    }
}

struct MainMenu: View {
    @EnvironmentObject var processor: Processor

    var body: some View {
        VStack(spacing: 16) {
            ForEach(MenuOption.allCases) { option in
                Button {
                    processor.perform(option.associatedAction)
                } label: {
                    Text(option.label)
                }
                .buttonStyle(MenuButton())
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: Styles.CornerRadius.medium)
                .fill(Color.white)
        }
        .overlay {
            RoundedRectangle(cornerRadius: Styles.CornerRadius.medium)
                .stroke(.blue, lineWidth: 4)
        }
    }
}

#Preview {
    let coordinator = AppCoordinator()
    let processor = Processor(coordinator: coordinator)

    MainMenu()
        .environmentObject(processor.coordinator)
        .environmentObject(processor)
}
