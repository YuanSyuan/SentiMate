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
    
    
    static func getMandarinEmotion(emotion: String) -> String {
        switch emotion {
        case Emotions.surprise.rawValue:
            return "驚喜"
        case Emotions.happy.rawValue:
            return "開心"
        case Emotions.neutral.rawValue:
            return "普通"
        case Emotions.fear.rawValue:
            return "緊張"
        case Emotions.sad.rawValue:
            return "難過"
        case Emotions.angry.rawValue:
            return "生氣"
        default:
            return "厭惡"
        }
    }
    
    static func getSceneEmoji(emotion: String) -> String {
        switch emotion {
        case Emotions.surprise.rawValue, Emotions.happy.rawValue:
            return "Emoticon_27.scn"
        case Emotions.neutral.rawValue:
            return "Emoticon_40.scn"
        default:
            return "Emoticon_56.scn"
        }
    }
    
    static func getEmotionColor(emotion: String) -> UIColor {
        switch emotion {
        case Emotions.surprise.rawValue:
            return lightRed
        case Emotions.happy.rawValue:
            return softCoral
        case Emotions.neutral.rawValue:
            return midOrange
        case Emotions.fear.rawValue:
            return creamyWhite
        case Emotions.sad.rawValue:
            return grayBlue
        case Emotions.angry.rawValue:
            return brick
        default:
            return newBrown
        }
    }
    
    static func getEmotionSinger(emotion: String) -> String {
        switch emotion {
        case Emotions.surprise.rawValue:
            return surpriseSinger.randomElement() ?? ""
        case Emotions.happy.rawValue:
            return happySinger.randomElement() ?? ""
        case Emotions.neutral.rawValue:
            return neutralSinger.randomElement() ?? ""
        case Emotions.fear.rawValue:
            return fearSinger.randomElement() ?? ""
        case Emotions.sad.rawValue:
            return sadSinger.randomElement() ?? ""
        case Emotions.angry.rawValue:
            return angrySinger.randomElement() ?? ""
        default:
            return disgustSinger.randomElement() ?? ""
        }
}

}

