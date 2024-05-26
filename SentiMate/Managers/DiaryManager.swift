//
//  DiaryManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/15.
//

import UIKit

class DiaryManager {
    static let shared = DiaryManager()
    var filteredDiaries = [Diary]()
    
    private init() {}
}

// MARK: - For AnalyticsVC, pie chart
extension DiaryManager {
    func getEmotionTypes(forPeriod period: TimePeriod) -> [EmotionType] {
        let frequencies = emotionFrequencies(forPeriod: period)
        guard filteredDiaries.count > 0 else { return [] }
        return frequencies.map { (emotionRaw, count) -> EmotionType in
                   guard let emotion = Emotions(rawValue: emotionRaw) else {
                       fatalError("Invalid emotion type")
                   }
            
            let percentage = Int((Double(count) / Double(filteredDiaries.count)) * 100.0.rounded())
            return EmotionType(emotion: emotion, percentage: percentage)
        }.sorted { $0.percentage > $1.percentage }
    }
    
    func emotionFrequencies(forPeriod period: TimePeriod) -> [String: Int] {
        let now = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        switch period {
        case .last7Days:
            let dateBoundary = calendar.date(byAdding: .day, value: -7, to: now)!
            filteredDiaries = FirebaseManager.shared.diaries.filter {
                if let diaryDate = dateFormatter.date(from: $0.customTime) {
                    return diaryDate >= dateBoundary
                }
                return false
            }
        case .last30Days:
            let dateBoundary = calendar.date(byAdding: .day, value: -30, to: now)!
            filteredDiaries = FirebaseManager.shared.diaries.filter {
                if let diaryDate = dateFormatter.date(from: $0.customTime) {
                    return diaryDate >= dateBoundary
                }
                return false
            }
        case .allTime:
            filteredDiaries = FirebaseManager.shared.diaries
        }
        
        return Dictionary(grouping: filteredDiaries, by: { $0.emotion })
            .mapValues { $0.count }
    }
}

// MARK: - For AnalyticsVC, circles
extension DiaryManager {
    func topCategories(forEmotion emotion: String) -> [CategoryData] {
        let filteredDiaries = FirebaseManager.shared.diaries.filter { $0.emotion == emotion }
        let grouped = Dictionary(grouping: filteredDiaries, by: { $0.category })
        
        let topCategories = grouped.mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .prefix(3) 
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
        let emotion: Emotions
        let percentage: Int
        var id: String {
            emotion.rawValue
        }
        
        var name: String {
            emotion.rawValue
        }
        
        var mandarinName: String {
            Emotions.getMandarinEmotion(emotion: emotion)
        }
        
        var color: UIColor {
            Emotions.getEmotionColor(emotion: emotion)
        }
}

