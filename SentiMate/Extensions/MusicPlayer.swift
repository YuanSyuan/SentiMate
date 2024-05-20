//
//  MusicPlayer.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/20.
//

import Foundation
import AVFoundation

class MusicPlayer {
    private var player: AVPlayer?
    
//    func play(item: Playable) {
//        guard let url = item.trackURL else { return }
//        player = AVPlayer(url: url)
//        player?.play()
//    }
//    
    func pause() {
        player?.pause()
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        if player.timeControlStatus == .paused {
            player.play()
        } else {
            player.pause()
        }
    }
}
