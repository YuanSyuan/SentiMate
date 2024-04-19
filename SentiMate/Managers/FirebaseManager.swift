//
//  FirebaseManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import FirebaseFirestore
import FirebaseStorage

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
                        dateFormatter.dateFormat = "yyyy-MM-dd" 

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
    
    func loadAudioFiles(completion: @escaping (Bool, Error?) -> Void) {
            // Define the folder path where your audio files are located
            let filesFolderRef = storageRef.child("music")
            
            // List all files in the directory
            filesFolderRef.listAll { (result, error) in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                guard let items = result?.items else {
                        // Handle the case where result is nil
                        completion(false, NSError(domain: "FirebaseManagerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No items in result."]))
                        return
                    }
                
                for item in items {
                    // The name of the file
                    let fileName = item.name
                    
                    // Create a URL for the local file you'll move the audio to
                    let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
                    
                    // Download to the local filesystem
                    item.write(toFile: localURL) { url, error in
                        if let error = error {
                            print("Error downloading audio file: \(error)")
                        } else if let url = url {
                            let audioFile = AudioFile(name: fileName, localURL: url)
                            self.audioFiles.append(audioFile)
                            completion(true, nil)
                        }
                    }
                }
            }
        }

}

