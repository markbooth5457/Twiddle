//
//  PlaySound.swift
//  Simon WatchKit Extension
//
//  Created by Mark Booth on 23/03/2020.
//  Copyright © 2020 Mark Booth. All rights reserved.
//

import Foundation
import AVFoundation

var audioPlayer : AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("sound problem")
        }
    }
}

