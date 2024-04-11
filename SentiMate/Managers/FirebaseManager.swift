//
//  FirebaseManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import FirebaseFirestore

class FirebaseManager {

    static let shared = FirebaseManager()

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
}

