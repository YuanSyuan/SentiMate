//
//  Playlist.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/13.
//

import Foundation

let playlist: [String] = ["情緒特調", "沈澱專區"]

let playlistDescription: [String] = [
    "專屬情緒歌單，陪你一起聆聽、理解和接受情緒。",
    "聽見自然、敞洋大海，適合睡前想好好放鬆的你。"
]

let playlistImage: [String] = [
    "backgroundAngry",
    "backgroundSad",
]

// 整合兩個不同的 struct
protocol Playable {
    var songName: String { get }
    var artist: String { get }
    var albumImage: String { get }
    var trackURL: URL { get }
}

// Apple Music API
struct SearchResponse: Codable {
    let resultCount : Int
    let results: [StoreItem]
}
// 歌曲 struct - 情緒特調
struct StoreItem: Codable, Equatable {
    let artistName: String
    let trackName: String
    let collectionName: String?
    let previewUrl: URL
    let artworkUrl100: URL
    let trackPrice: Double?
    let releaseDate: Date
    let isStreamable: Bool?
    
    var artworkUrl500: URL {
        artworkUrl100.deletingLastPathComponent().appendingPathComponent("500x500bb.jpg")
    }
}

extension StoreItem: Playable {
    var songName: String { 
        return trackName
    }
    
    var artist: String {
        return artistName
    }
    
    var albumImage: String {
        return artworkUrl500.absoluteString
    }
    
    var trackURL: URL {
        return previewUrl
    }
    
}

// 歌曲 struct - 沈澱專區
struct SoftMusic {
    var name: String
    var url: String
    var image: String
}

extension SoftMusic: Playable {
    var songName: String {
        return name
    }
    
    var artist: String {
        return "Suno"
    }
    
    var albumImage: String {
        return image
    }
    
    var trackURL: URL {
        return URL(string: url)!
    }
    
    
}

// 歌單 Array - 情緒特調
let angrySinger: [String] = [
    "Slipknot",
    "RageAgainsttheMachine",
    "Pantera",
    "Korn",
    "Metallica",
    "LimpBizkit",
    "Disturbed",
    "SystemofaDown",
    "FiveFingerDeathPunch",
    "MarilynManson",
    "KanhoYakushiji",
    "Ólafur Arnalds",
    "草東沒有派對",
    "潤荷",
    "陳粒",
    "告五人"
]

let disgustSinger: [String] = [
    "GGAllin",
    "CannibalCorpse",
    "Napalm Death",
    "CradleofFilth",
    "Behemoth",
    "Gorgoroth",
    "AnaalNathrakh",
    "DyingFetus",
    "PigDestroyer",
    "CarachAngren",
    "BillieEilish",
    "Ólafur Arnalds"
]


let fearSinger: [String] = [
    "NineInchNails",
    "MarilynManson",
    "Tool",
    "Radiohead",
    "Portishead",
    "AphexTwin",
    "MassiveAttack",
    "AliceCooper",
    "TheCure",
    "Bauhaus",
    "Ólafur Arnalds",
    "告五人",
    "梁靜茹",
    "徐佳瑩",
    "蔡健雅",
    "告五人",
    // 韓文
    "Rothy",
    "JimmyBrown",
    // 日文
    "Aimer"
]

let sadSinger: [String] = [
    "Adele",
    "ElliotSmith",
    "SufjanStevens",
    "BonIver",
    "SamSmith",
    "LanaDelRey",
    "TheNational",
    "BillieEilish",
    "AmyWinehouse",
    "DamienRice",
    "梁靜茹",
    "徐佳瑩",
    "蔡健雅",
    "魏如萱",
    "陳綺貞",
    "告五人",
    // 韓文
    "PaulKim"
]

let neutralSinger: [String] = [
    "NorahJones",
    "JackJohnson",
    "TheLumineers",
    "Coldplay",
    "JohnMayer",
    "EdSheeran",
    "TheMachine",
    "JasonMraz",
    "VanceJoy",
    "RayLaMontagne",
    // 韓文
    "AKMU"
]

let happySinger: [String] = [
    "PharrellWilliams",
    "TheBeachBoys",
    "TaylorSwift",
    "BrunoMars",
    "JustinTimberlake",
    "KatyPerry",
    "Beyoncé",
    "Maroon5",
    "HarryStyles",
    "就以斯",
    // 韓文
    "NewJeans"
]

let surpriseSinger: [String] = [
    "Björk",
    "Gorillaz",
    "DavidBowie",
    "Beck",
    "OutKast",
    "LadyGaga",
    "MGMT",
    "FlamingLips",
    "St.Vincent",
    "Prince"
]

// 歌單 Array - 沈澱專區
let softMusicPlaylist: [SoftMusic] = [
    SoftMusic(name: "Whispering Winds", url: "https://drive.google.com/uc?export=download&id=1vdiQkUHeafUSlaO1chuC8PKBPzkwrEwF", image: "musicImg0"),
    SoftMusic(name: "Moonlit Serenade", url: "https://drive.google.com/uc?export=download&id=1APkC88ExN3RS-1s-mBKviyisbRqB7tOF", image: "musicImg1"),
    SoftMusic(name: "Celestial Echoes", url: "https://drive.google.com/uc?export=download&id=1cXW0Qp1a4qbUnt7k306GvXYfBQWHsQNq", image: "musicImg2"),
    SoftMusic(name: "Gentle Embrace", url: "https://drive.google.com/uc?export=download&id=1xQZmCFawXZIhPQ8MGuzgAjjR2yGBmt38", image: "musicImg3"),
    SoftMusic(name: "Silent Reverie", url: "https://drive.google.com/uc?export=download&id=1rH-ZQJL41RrtcONLniqhSLIJYzbPYGli", image: "musicImg4"),
    SoftMusic(name: "Ethereal Moments", url: "https://drive.google.com/uc?export=download&id=1inf-U2tPdXLLCFMkqHKc2Vt-IdF_YWld", image: "musicImg5"),
    SoftMusic(name: "Misty Horizons", url: "https://drive.google.com/uc?export=download&id=1Q89f4_7dER3U2pcG9ZMoeqwsddb4LJyO", image: "musicImg6"),
    SoftMusic(name: "Twilight Whispers", url: "https://drive.google.com/uc?export=download&id=1VyF_RybC_idY8Nm_4iglbIRcNfE8TUT5", image: "musicImg7"),
    SoftMusic(name: "Tranquil Mornings", url: "https://drive.google.com/uc?export=download&id=1Cksi2q_N7MHG31ccIJtlk5eykPO1Nq8Z", image: "musicImg8"),
    SoftMusic(name: "Velvet Dreams", url: "https://drive.google.com/uc?export=download&id=1wywUEzkmKbWEdorGjM_WLyW_kE4c_K_h", image: "musicImg9"),
    SoftMusic(name: "Softly Spoken", url: "https://drive.google.com/uc?export=download&id=1spi10b4Dg9IqkAbwV1m4Wh_xfpoPiyc5", image: "musicImg10"),
    SoftMusic(name: "Quietude Cascade", url: "https://drive.google.com/uc?export=download&id=1ZYIkBn_JSSlwr3cOrmuNhbH70BoVllwz", image: "musicImg11")
]
