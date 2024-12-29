//
//  AppCoordinator.swift
//  Numbers
//
//  Created by Alex Maggio on 28/12/2024.
//
import SwiftUI

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
