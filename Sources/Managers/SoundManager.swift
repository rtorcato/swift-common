//
//  PlaySound.swift
//  Slot Machine

//

// import AVFoundation
import SwiftUI
import AVKit

// var audioPlayer: AVAudioPlayer?
//
// func playSound(fileName: String, fileFormat: String) {
//    if let path = Bundle.main.path(forResource: fileName, ofType: fileFormat) {
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
//            audioPlayer?.play()
//        } catch {
//            print("Could not find and play the sound file")
//        }
//    }
//
// }
//
// final class SoundManager {
//
//    static let instance = SoundManager() // Singleton
//
//    var player: AVAudioPlayer?
//
//    enum SoundOption: String {
//        case tada
//        case badum
//    }
//
//    func playSound(sound: SoundOption) {
//
//        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
//
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//        } catch let error {
//            print("Error playing sound. \(error.localizedDescription)")
//        }
//    }
// }
