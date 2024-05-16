//
//  DiaryManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/15.
//

import UIKit

class DiaryManager: ObservableObject {
    static let shared = DiaryManager()
    
    private init() {}
    
    @Published var diaries: [Diary] = []
    
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
        let sortedDiaries = diaries
            .filter { $0.emotion == emotion }
            .sorted { $0.customTime > $1.customTime }
        
        if sortedDiaries.count >= 2 {
            return sortedDiaries[1]
        } else {
            return nil
        }
    }
}

// MARK: - For AnalyticsVC, pie chart
extension DiaryManager {
    func getEmotionTypes(forPeriod period: TimePeriod) -> [EmotionType] {
        let frequencies = emotionFrequencies(forPeriod: period)
        let totalDiaries = diaries.count
        guard totalDiaries > 0 else { return [] }
        
        return frequencies.map { (emotionRaw, count) -> EmotionType in
                   guard let emotion = Emotions(rawValue: emotionRaw) else {
                       fatalError("Invalid emotion type")
                   }
            
            let percentage = Int((Double(count) / Double(totalDiaries)) * 100.0.rounded())
            return EmotionType(emotion: emotion, percentage: percentage)
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
        let emotion: Emotions
        let percentage: Int
        var id: String {
            emotion.rawValue
        }
        
        var name: String {
            emotion.rawValue
        }
        
        var mandarinName: String {
            Emotions.getMandarinEmotion(emotion: emotion.rawValue)
        }
        
        var color: UIColor {
            Emotions.getEmotionColor(emotion: emotion.rawValue)
        }
}

