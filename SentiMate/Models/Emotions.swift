//
//  Emotions.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/13.
//

import Foundation
import UIKit

let sceneEmojis: [String] = ["Emoticon_27.scn", "Emoticon_40.scn", "Emoticon_56.scn"]

enum Emotions: String {
    case surprise = "Surprise"
    case happy = "Happy"
    case neutral = "Neutral"
    case fear = "Fear"
    case sad = "Sad"
    case angry = "Angry"
    case disgust = "Disgust"
    
    static func getMandarinEmotion(emotion: Emotions) -> String {
        switch emotion {
        case .surprise:
            return "驚喜"
        case .happy:
            return "開心"
        case .neutral:
            return "普通"
        case .fear:
            return "緊張"
        case .sad:
            return "難過"
        case .angry:
            return "生氣"
        case .disgust:
            return "厭惡"
        }
    }
    
    static func getSceneEmoji(emotion: Emotions) -> String {
        switch emotion {
        case .surprise, .happy:
            return "Emoticon_27.scn"
        case .neutral:
            return "Emoticon_40.scn"
        case .fear, .sad, .angry, .disgust:
            return "Emoticon_56.scn"
        }
    }
    
    static func getEmotionColor(emotion: Emotions) -> UIColor {
        switch emotion {
        case .surprise:
            return lightRed
        case .happy:
            return softCoral
        case .neutral:
            return midOrange
        case .fear:
            return creamyWhite
        case .sad:
            return grayBlue
        case .angry:
            return brick
        case .disgust:
            return newBrown
        }
    }
    
    static func getEmotionSinger(emotion: Emotions) -> String {
        switch emotion {
        case .surprise:
            return surpriseSinger.randomElement() ?? ""
        case .happy:
            return happySinger.randomElement() ?? ""
        case .neutral:
            return neutralSinger.randomElement() ?? ""
        case .fear:
            return fearSinger.randomElement() ?? ""
        case .sad:
            return sadSinger.randomElement() ?? ""
        case .angry:
            return angrySinger.randomElement() ?? ""
        case .disgust:
            return disgustSinger.randomElement() ?? ""
        }
    }
    
}

