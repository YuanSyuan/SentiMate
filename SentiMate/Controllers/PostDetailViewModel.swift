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
    
//    private func handleSaveResult(_ result: Result<Void, Error>) {
//        switch result {
//        case .success():
//            DispatchQueue.main.async {
//                self.showAlert()
//            }
//        case .failure(let error):
//            print("Error saving data: \(error)")
//        }
//    }
    
//    private func showAlert() {
//        if let lastDiary = DiaryManager.shared.lastDiaryWithEmotion(emotion), let emotionEnum = Emotions(rawValue: lastDiary.emotion) {
//            let mandarinEmotion = Emotions.getMandarinEmotion(emotion: emotionEnum)
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 4
//            paragraphStyle.alignment = .center
//            
//            let attributes = NSAttributedString(string: "\(lastDiary.content)", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
//            
//            DispatchQueue.main.async {
//                AlertView.instance.showAlert(
//                    image: lastDiary.emotion,
//                    title: "上次感到\(mandarinEmotion)是因為「\(buttonTitles[lastDiary.category])」",
//                    message: attributes,
//                    alertType: .reminder
//                )
//                
//                let generator = UINotificationFeedbackGenerator()
//                generator.notificationOccurred(.success)
//            }
//        }
//    }
}

