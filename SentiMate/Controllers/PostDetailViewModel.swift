//
//  PostDetailViewModel.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/19.
//

import Combine
import FirebaseAuth
import UIKit

class PostDetailViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var emotion: String
    @Published var selectedCategoryIndex: Int?
    @Published var userInput: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(emotion: String) {
        self.emotion = emotion
    }
    
    func saveDiaryEntry(documentID: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        let userUID = Auth.auth().currentUser?.uid ?? "Unknown UID"
        var newEntry: [String: Any] = [
            "userID": userUID,
            "customTime": DateFormatter.diaryEntryFormatter.string(from: selectedDate),
            "emotion": emotion,
            "category": selectedCategoryIndex ?? 0,
            "content": userInput
        ]
        
        if let docID = documentID {
            newEntry["documentID"] = docID
        }
        
        if let documentID = newEntry["documentID"] as? String {
            FirebaseManager.shared.updateData(to: "diaries", documentID: documentID, data: newEntry) { result in
                completion(result)
            }
        } else {
            FirebaseManager.shared.saveData(to: "diaries", data: newEntry) { result in
                completion(result)
            }
        }
    }
    
    // for alert use
    func lastDiaryWithEmotion(_ emotion: String) -> Diary? {
        let sortedDiaries = DiaryManager.shared.diaries
            .filter { $0.emotion == emotion }
            .sorted { $0.customTime > $1.customTime }
        
        if sortedDiaries.count >= 2 {
            return sortedDiaries[1]
        } else {
            return nil
        }
    }
    
}

