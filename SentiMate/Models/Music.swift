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
"nature0",
"nature1",
"nature2",
"nature3",
"nature4",
"nature5",
"nature6"
]

let musicImage: [String] = [
    "musicImg0",
    "musicImg1",
    "musicImg2",
    "musicImg3",
    "musicImg4",
    "musicImg5",
    "musicImg6",
    "musicImg7",
    "musicImg8",
    "musicImg9",
    "musicImg10",
    "musicImg11"
]

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
    "草東沒有派對"
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
    "CarachAngren"
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
    "Bauhaus"
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
    "魏如萱"
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
    "RayLaMontagne"
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
    "HarryStyles"
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
