//
//  SettingsView.swift
//  Numbers
//
//  Created by Alex Maggio on 19/12/2024.
//

import SwiftUI

struct SettingsView: View {
    enum Configuration {
        static let sliderTitleSize: CGFloat = 40
        static let sliderCaptionSize: CGFloat = 35
        static var sliderFont: Font {
            .custom(Styles.fontName, size: sliderTitleSize)
        }
        static var sliderItemFont: Font {
            .custom(
                Styles.fontName,
                size: sliderCaptionSize
            )
        }

        static let gameDifficultySize: CGFloat = 40
        static let gameDifficultyItemSize: CGFloat = 35
        static var difficultyFont: Font {
            .custom(Styles.fontName, size: gameDifficultySize)
        }
        static var gameItemFont: Font {
            .custom(
                Styles.fontName,
                size: gameDifficultyItemSize
            )
        }
    }

    @EnvironmentObject var processor: Processor
    @EnvironmentObject var coordinator: AppCoordinator

    @State private var musicVolume: Double = Double(AudioManager.shared.volumeBGM)
    @State private var soundVolume: Double = Double(AudioManager.shared.volumeSFX)

    var body: some View {
        VStack {
            Text("Settings")
                .font(Configuration.sliderFont)
            getVolumeSlider("Music Volume", value: $musicVolume)
                .onChange(of: musicVolume) { _, newValue in
                    processor.perform(.changeMusicVolume(newValue))
                }
            getVolumeSlider("Sound Volume", value: $soundVolume)
                .onChange(of: soundVolume) { _, newValue in
                    processor.perform(.changeSoundVolume(newValue))
                }


            Text("Game Difficulty")
                .font(Configuration.difficultyFont)
                .padding()

            ForEach(GameDifficulty.allCases) { difficulty in
                GameDifficultyRow(difficulty: difficulty, currentDifficulty: processor.difficulty)
//                .onTapGesture { processor.difficulty = difficulty }
                .onTapGesture { processor.perform(.changeDifficulty(difficulty)) }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.vertical, 2)
            }

            HStack {
                Button {
                    coordinator.dismiss()
                } label: {
                    Text("Save")
                }
                .buttonStyle(MenuButton())
                Button {
                    coordinator.dismiss()
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(DestructiveButton())
            }
            .padding()
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
        .padding()
    }

    @ViewBuilder
    private func getVolumeSlider(_ caption: String, value: Binding<Double>) -> some View {
        HStack {
            Text(caption)
                .font(Configuration.sliderItemFont)
                .frame(width: 150)
            Slider(
                value: value,
                in: 0...1,
                step: 0.1,
                label: { EmptyView() },
                minimumValueLabel: { Text("-").font(Configuration.sliderItemFont) },
                maximumValueLabel: { Text("+").font(Configuration.sliderItemFont) }
            )
        }
        .padding()
    }
}

#Preview {
    let coordinator = AppCoordinator()
    let processor = Processor(coordinator: coordinator)

    SettingsView()
        .environmentObject(processor.coordinator)
        .environmentObject(processor)
}
