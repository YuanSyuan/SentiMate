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

// MARK: - For AnalyticsVC, pie chart
struct EmotionType: Identifiable, Equatable {
    let name: String
    let percentage: Int
    let color: UIColor
    var id: String {
        name
    }
}

extension DiaryManager {
    
    func getEmotionTypes() -> [EmotionType] {
        let frequencies = emotionFrequencies()
        let totalDiaries = diaries.count
        guard totalDiaries > 0 else { return [] }
        
            return frequencies.map { (emotion, count) -> EmotionType in
                let percentage = Int((Double(count) / Double(totalDiaries)) * 100.0.rounded())
                return EmotionType(name: emotion, percentage: percentage, color: colorForEmotion(emotion))
            }.sorted { $0.percentage > $1.percentage }
        }
    
    func emotionFrequencies() -> [String: Int] {
        var frequencies = [String: Int]()
        for diary in diaries {
            frequencies[diary.emotion, default: 0] += 1
        }
        return frequencies
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

// MARK: - For AnalyticsVC, circles
struct CategoryData {
    let name: String
    let count: Int  // Number of entries in this category for the selected emotion
}

extension DiaryManager {
    
    func topCategories(forEmotion emotion: String) -> [CategoryData] {
        let filteredDiaries = diaries.filter { $0.emotion == emotion }
        let grouped = Dictionary(grouping: filteredDiaries, by: { $0.category })

        let topCategories = grouped.mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .prefix(3)  // Take the top 3 categories
            .map { CategoryData(name: buttonTitles[$0.key] ?? "Unknown", count: $0.value) }

        return Array(topCategories)
    }
}

