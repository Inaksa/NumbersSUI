//
//  AudioManager.swift
//  Numbers
//
//  Created by Alex Maggio on 28/12/2024.
//

import Foundation
import AVFoundation
import UIKit

enum SoundFX {
    case complete
    case highscore
    case tap
    case mix

    var resourceName: String {
        switch self {
        case .complete:
            return "complete"
        case .highscore:
            return "completeWithHighscore"
        case .tap:
            return "tap"
        case .mix:
            return "vgmenuselect"
        }

    }
}

enum ConfigKeys {}

extension ConfigKeys {
    enum AudioManager: String {
        case bgmVolume = "SoundManager_BGM_Volume"
        case sfxVolume = "SoundManager_SFX_Volume"
    }
}

class AudioManager {
    static let shared = AudioManager()

    private var bgmPlayer: AVAudioPlayer!
    private var sfxPlayer: AVAudioPlayer!

    private init() {
        loadConfig()
    }

    func startMusic() {
        if let data = NSDataAsset(name: "bgm2")?.data,
           let bgmPlayer = try? AVAudioPlayer(data: data) {
            bgmPlayer.numberOfLoops = Int.max
            bgmPlayer.setVolume(volumeBGM, fadeDuration: 1)
            bgmPlayer.play()

            self.bgmPlayer = bgmPlayer
        }
    }

    func playSound(_ sfx: SoundFX) {
        if sfxPlayer != nil,
           sfxPlayer.isPlaying {
            sfxPlayer.stop()
        }

        if let data = NSDataAsset(name: sfx.resourceName)?.data,
           let sfxPlayer = try? AVAudioPlayer(data: data) {
            sfxPlayer.setVolume(volumeSFX, fadeDuration: 0)
            sfxPlayer.prepareToPlay()
            sfxPlayer.play()
            self.sfxPlayer = sfxPlayer
        }
    }

    func setMusicVolume(_ volume: Float = 1) {
        volumeBGM = volume
        guard bgmPlayer != nil else {
            return
        }
        bgmPlayer.setVolume(volume, fadeDuration: 0)
        saveConfig()
    }

    func setSFXVolume(_ volume: Float = 1) {
        volumeSFX = volume
        guard sfxPlayer != nil else {
            return
        }
        sfxPlayer.setVolume(volume, fadeDuration: 0)
        saveConfig()
    }

    private(set) var volumeBGM: Float = 1
    private(set) var volumeSFX: Float = 1

    private func saveConfig() {
        UserDefaults.standard.set(volumeBGM, forKey: ConfigKeys.AudioManager.bgmVolume.rawValue)
        UserDefaults.standard.set(volumeSFX, forKey: ConfigKeys.AudioManager.sfxVolume.rawValue)
    }

    private func loadConfig() {
        if let newVolume = UserDefaults.standard.value(forKey: ConfigKeys.AudioManager.bgmVolume.rawValue) as? Float {
            setMusicVolume(newVolume)
        } else {
            setMusicVolume(0.7)
        }

        if let newVolume = UserDefaults.standard.value(forKey: ConfigKeys.AudioManager.sfxVolume.rawValue) as? Float {
            setSFXVolume(newVolume)
        } else {
            setSFXVolume(0.7)
        }
    }
}
