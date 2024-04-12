//
//  FirebaseManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import FirebaseFirestore

class FirebaseManager {

    static let shared = FirebaseManager()
    var onNewData: (([Diary]) -> Void)?
    
    private init() {}

    func saveData(to collection: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
            let db = Firestore.firestore()
            db.collection(collection).addDocument(data: data) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    
    
//    func fetchPosts() {
//            let db = Firestore.firestore()
//            db.collection("posts").order(by: "customTime", descending: true).getDocuments { [weak self] (querySnapshot, error) in
//                guard let documents = querySnapshot?.documents else {
//                    print("Error fetching posts: \(error?.localizedDescription ?? "Unknown error")")
//                    return
//                }
//                self?.posts = documents.compactMap { Post(document: $0) }
//            }
//        }
    
    func listenForUpdate() {
        let db = Firestore.firestore()
        db.collection("diaries")
            .addSnapshotListener { querySnapshot, error in
                var diaries = [Diary]()
                if let err = error {
                    print("can't load data \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            
                            let data = doc.data()
                            if  let emotion = data["emotion"] as? String,
                                let userID = data["userID"] as? String,
                                let customTime = data["customTime"] as? String,
                                let category = data["category"] as? Int,
                                let content = data["content"] as? String {
                                let newEntry = Diary(emotion: emotion, content: content, customTime: customTime, category: category, userID: userID)
                                
                                diaries.append(newEntry)
                            }
                        }
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd" // Replace with your date format

                        diaries.sort { firstDiary, secondDiary in
                            // Convert customTime strings to Date objects
                            if let firstDate = dateFormatter.date(from: firstDiary.customTime),
                               let secondDate = dateFormatter.date(from: secondDiary.customTime) {
                                // Return true if the first date is more recent than the second date
                                return firstDate > secondDate
                            }
                            return false // If dates can't be compared, keep the original order
                        }
                    }
                    
                }
                self.onNewData?(diaries)
            }
    }

}

