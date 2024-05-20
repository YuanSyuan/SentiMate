//
//  MusicViewModel.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/20.
//

import Foundation
import AVFoundation

class MusicViewModel {
    var songs: [Playable] = []
    var player = MusicPlayer()
    var songIndex: Int = 0
    
    var currentSong: Playable? {
        return songIndex < songs.count ? songs[songIndex] : nil
    }
    
    func playSong(at index: Int) {
        songIndex = index
        guard let song = currentSong else { return }
//        player.play(item: song)
    }
    
    func togglePlayPause() {
        player.togglePlayPause()
    }
}
