//
//  MenuButton.swift
//  Numbers
//
//  Created by Alex Maggio on 19/12/2024.
//
import SwiftUI

struct NormalButton: ButtonStyle {
    enum ButtonConfiguration {
        static let fontSize: CGFloat = 50
        static let opacity: Double = 0.5

        static let overlayOpacity: Double = 0.5
        static let overlayHeight: CGFloat = 10

        static let titleColor: Color = .white
        static let titleBackgroundColor: Color = .blue
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom(Styles.fontName, size: ButtonConfiguration.fontSize))
            .padding()
            .opacity(configuration.isPressed ? ButtonConfiguration.opacity : 1)
            .foregroundStyle(ButtonConfiguration.titleColor)
            .background(ButtonConfiguration.titleBackgroundColor)
            .overlay(alignment: .bottom) {
                if configuration.isPressed {
                    EmptyView()
                } else {
                    Color.black
                        .opacity(ButtonConfiguration.overlayOpacity)
                        .frame(height: ButtonConfiguration.overlayHeight)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    Button(action: { print("Pressed") }) {
        Label("Press Me", systemImage: "star")
    }
    .buttonStyle(NormalButton())
}
