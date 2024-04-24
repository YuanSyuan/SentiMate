//
//  DiaryManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/15.
//

import UIKit

class DiaryManager {
    static let shared = DiaryManager()
    
    private init() {}

    var diaries: [Diary] = []

    func updateDiaries(newDiaries: [Diary]) {
        DispatchQueue.main.async {
            self.diaries = newDiaries
            NotificationCenter.default.post(name: NSNotification.Name("DiariesUpdated"), object: nil)
        }
    }
}

// MARK: - For PostDetailVC, same emotion alert
extension DiaryManager {
    func lastDiaryWithEmotion(_ emotion: String) -> Diary? {
        return diaries
            .filter { $0.emotion == emotion }
            .sorted { $0.customTime > $1.customTime }
            .first
    }
}

// MARK: - For AnalyticsVC, pie chart
extension DiaryManager {
    
    func getEmotionTypes(forPeriod period: TimePeriod) -> [EmotionType] {
           let frequencies = emotionFrequencies(forPeriod: period)
           let totalDiaries = diaries.count
           guard totalDiaries > 0 else { return [] }
           return frequencies.map { (emotion, count) -> EmotionType in
               let percentage = Int((Double(count) / Double(totalDiaries)) * 100.0.rounded())
               return EmotionType(name: emotion, percentage: percentage, color: colorForEmotion(emotion))
           }.sorted { $0.percentage > $1.percentage }
       }
    
    func emotionFrequencies(forPeriod period: TimePeriod) -> [String: Int] {
            var filteredDiaries = [Diary]()

            let now = Date()
            let calendar = Calendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            switch period {
            case .last7Days:
                let dateBoundary = calendar.date(byAdding: .day, value: -7, to: now)!
                filteredDiaries = diaries.filter {
                        if let diaryDate = dateFormatter.date(from: $0.customTime) {
                            return diaryDate >= dateBoundary
                        }
                        return false
                    }
            case .last30Days:
                let dateBoundary = calendar.date(byAdding: .day, value: -30, to: now)!
                filteredDiaries = diaries.filter {
                        if let diaryDate = dateFormatter.date(from: $0.customTime) {
                            return diaryDate >= dateBoundary
                        }
                        return false
                    }
            case .allTime:
                filteredDiaries = diaries
            }

            return Dictionary(grouping: filteredDiaries, by: { $0.emotion })
                .mapValues { $0.count }
        }
    
    private func colorForEmotion(_ emotion: String) -> UIColor {
            switch emotion {
            case "Surprise": return lightRed
            case "Happy": return softCoral
            case "Neutral": return midOrange
            case "Fear": return creamyWhite
            case "Sad": return grayBlue
            case "Angry": return brick
            case "Disgust": return newBrown
            default: return UIColor(hex: "cccccc")
            }
        }
}

// MARK: - For AnalyticsVC, circles
extension DiaryManager {
    
    func topCategories(forEmotion emotion: String) -> [CategoryData] {
        let filteredDiaries = diaries.filter { $0.emotion == emotion }
        let grouped = Dictionary(grouping: filteredDiaries, by: { $0.category })

        let topCategories = grouped.mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .prefix(3)  // Take the top 3 categories
            .map { CategoryData(name: buttonTitles[$0.key] , count: $0.value) }

        return Array(topCategories)
    }
}

struct CategoryData {
    let name: String
    let count: Int
}


enum TimePeriod: String, CaseIterable {
    case last7Days = "7天"
    case last30Days = "1個月"
    case allTime = "全部"
}

struct EmotionType: Identifiable, Equatable {
    let name: String
    let percentage: Int
    let color: UIColor
    var id: String {
        name
    }
}

extension EmotionType {
    var mandarinName: String {
        switch self.name {
        case "Happy":
            return "開心"
        case "Sad":
            return "難過"
        case "Angry":
            return "生氣"
        case "Fear":
            return "緊張"
        case "Surprise":
            return "驚喜"
        case "Disgust":
            return "厭惡"
        case "Neutral":
            return "普通"
        default:
            return self.name
        }
    }
}

extension EmotionType {
    var emojiImageName: String {
        switch self.name {
        case "Fear":
            return "fear"
        case "Sad":
            return "sad"
        case "Neutral":
            return "neutral"
        case "Happy":
            return "happy"
        case "Surprise":
            return "surprise"
        case "Angry":
            return "angry"
        default:
            return "disgust"
        }
    }
}

