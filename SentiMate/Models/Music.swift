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

struct SoftMusic {
var name: String
var url: String
var image: String
}

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
//let playlistURL: [String] = [
//    "https://drive.google.com/uc?export=download&id=1vdiQkUHeafUSlaO1chuC8PKBPzkwrEwF",
//    "https://drive.google.com/uc?export=download&id=1APkC88ExN3RS-1s-mBKviyisbRqB7tOF",
//    "https://drive.google.com/uc?export=download&id=1cXW0Qp1a4qbUnt7k306GvXYfBQWHsQNq",
//    "https://drive.google.com/uc?export=download&id=1xQZmCFawXZIhPQ8MGuzgAjjR2yGBmt38",
//    "https://drive.google.com/uc?export=download&id=1rH-ZQJL41RrtcONLniqhSLIJYzbPYGli",
//    "https://drive.google.com/uc?export=download&id=1inf-U2tPdXLLCFMkqHKc2Vt-IdF_YWld",
//    "https://drive.google.com/uc?export=download&id=1Q89f4_7dER3U2pcG9ZMoeqwsddb4LJyO",
//    "https://drive.google.com/uc?export=download&id=1VyF_RybC_idY8Nm_4iglbIRcNfE8TUT5",
//    "https://drive.google.com/uc?export=download&id=1Cksi2q_N7MHG31ccIJtlk5eykPO1Nq8Z",
//    "https://drive.google.com/uc?export=download&id=1wywUEzkmKbWEdorGjM_WLyW_kE4c_K_h",
//    "https://drive.google.com/uc?export=download&id=1spi10b4Dg9IqkAbwV1m4Wh_xfpoPiyc5",
//    "https://drive.google.com/uc?export=download&id=1ZYIkBn_JSSlwr3cOrmuNhbH70BoVllwz"
//]
//
//let musicImage: [String] = [
//    "musicImg0",
//    "musicImg1",
//    "musicImg2",
//    "musicImg3",
//    "musicImg4",
//    "musicImg5",
//    "musicImg6",
//    "musicImg7",
//    "musicImg8",
//    "musicImg9",
//    "musicImg10",
//    "musicImg11"
//]

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
    "草東沒有派對",
    "潤荷",
    "陳粒"
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
    "BillieEilish"
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
    "徐佳瑩",
    "蔡健雅",
    "魏如萱",
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

//Json 大分類
struct SearchResponse: Codable {
    let resultCount : Int
    let results: [StoreItem]
}
//Json 小分類,名稱需要與Json一樣
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
