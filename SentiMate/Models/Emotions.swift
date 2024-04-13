//
//  Emotions.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/13.
//

import Foundation

enum Emotion: String, CaseIterable {
    case fear
    case sad
    case neutral
    case happy
    case surprise
    case angry
    case disgust
    
    var content: String {
        switch self {
        case .fear:
            return "畏懼"
        case .sad:
            return "難過"
        case .neutral:
            return "普通"
        case .happy:
            return "開心"
        case .surprise:
            return "驚喜"
        case .angry:
            return "生氣"
        case .disgust:
            return "噁心"
        }
    }
    
    var imageNumber: String {
        switch self {
        case .fear:
            return ""
        case .sad:
            return ""
        case .neutral:
            return ""
        case .happy:
            return ""
        case .surprise:
            return ""
        case .angry:
            return ""
        case .disgust:
            return ""
        }
    }
    
    var artists: [String] {
        switch self {
        case .fear:
            return fearSinger
        case .sad:
            return sadSinger
        case .neutral:
            return neutralSinger
        case .happy:
            return happySinger
        case .surprise:
            return surpriseSinger
        case .angry:
            return angrySinger
        case .disgust:
            return disgustSinger
        }
    }
}
