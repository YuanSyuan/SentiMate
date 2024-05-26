//
//  AnalyticsViewModel.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/23.
//

import Foundation
import Combine

class AnalyticsViewModel:ObservableObject {
    @Published var diaries: [Diary] = []
    @Published var AIResponse: String?
    
    private var firebaseManager = FirebaseManager.shared
    var cancellables = Set<AnyCancellable>()
    
    var latestDiaries: [Diary] {
        Array(diaries.prefix(7))
    }
    
    init() {
        firebaseManager.$diaries
            .receive(on: DispatchQueue.main)
            .assign(to: \.diaries, on: self)
            .store(in: &cancellables)
    }
    
    func analyzeEntry(completion: @escaping () -> Void) {
        let combinedText = latestDiaries.map { entry -> String in
            let content = entry.content
            let category = entry.category
            let emotion = entry.emotion
            
            return "Category: \(category), Emotion: \(emotion), Diary: \(content) "
        }.joined(separator: " ")
        
        analyzeDiaryEntries(combinedText, completion: completion)
    }
    
    private func analyzeDiaryEntries(_ content: String, completion: @escaping () -> Void) {
        OpenAIManager.shared.analyzeDiaryEntry(prompt: content) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let analyzedText):
                    self?.AIResponse = analyzedText
                case .failure(let error):
                    print("Error analyzing diary entries: \(error.localizedDescription)")
                }
                completion()
            }
        }
    }
}

