//
//  DiaryManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/15.
//

import UIKit

class DiaryManager {
    static let shared = DiaryManager()
    
    private init() {}  // Private initializer to ensure singleton usage

    var diaries: [Diary] = []

    // Function to update diaries, previously handled by FirebaseManager callback
    func updateDiaries(newDiaries: [Diary]) {
        DispatchQueue.main.async {
            self.diaries = newDiaries
            NotificationCenter.default.post(name: NSNotification.Name("DiariesUpdated"), object: nil)
        }
    }
}

extension DiaryManager {
    func emotionFrequencies() -> [String: Int] {
        var frequencies = [String: Int]()
        for diary in diaries {
            frequencies[diary.emotion, default: 0] += 1
        }
        return frequencies
    }
    
    func getEmotionTypes() -> [EmotionType] {
            let frequencies = emotionFrequencies()
            print(frequencies)
            return frequencies.map { (emotion, count) -> EmotionType in
                EmotionType(name: emotion, count: count, color: colorForEmotion(emotion))
            }.sorted { $0.count > $1.count }
        }
    
    private func colorForEmotion(_ emotion: String) -> UIColor {
            switch emotion {
            case "Surprise": return .orange
            case "Happy": return .yellow
            case "Neutral": return .purple
            case "Fear": return .orange
            case "Sad": return .blue
            case "Angry": return .red
            case "Disgust": return .black
            default: return .gray
            }
        }
}


struct EmotionType: Identifiable {
    let name: String
    let count: Int
    let color: UIColor
    var id: String {
        name
    }
}
