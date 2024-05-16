//
//  FirebaseManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct AudioFile: Equatable {
    let name: String
    let localURL: URL
}

class FirebaseManager {

    static let shared = FirebaseManager()
    var onNewData: (([Diary]) -> Void)?
    
    private let storageRef = Storage.storage().reference()
      var audioFiles: [AudioFile] = []
      
    
    private init() {}

    func saveData(to collection: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
            let db = Firestore.firestore()
            var mutableData = data
        
        let documentReference = db.collection(collection).document() // Create a document reference with a new document ID
            
            // Step 2: Add the document ID to the data
            mutableData["documentID"] = documentReference.documentID
        
        documentReference.setData(mutableData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    
    func listenForUpdate() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("diaries")
            .whereField("userID", isEqualTo: userId)
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
                                let content = data["content"] as? String,
                                let documentID = data["documentID"] as? String{
                                let newEntry = Diary(documentID: documentID, emotion: emotion, content: content, customTime: customTime, category: category, userID: userID)
                                
                                diaries.append(newEntry)
                            }
                        }
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd" 

                        diaries.sort { firstDiary, secondDiary in
                            if let firstDate = dateFormatter.date(from: firstDiary.customTime),
                               let secondDate = dateFormatter.date(from: secondDiary.customTime) {
                                return firstDate > secondDate
                            }
                            return false
                        }
                    }
                    
                }
                self.onNewData?(diaries)
            }
    }
    
    func deleteDiaryEntry(documentID: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("diaries").document(documentID).delete() { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func updateData(to collection: String, documentID: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection(collection).document(documentID).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

