//
//  HomeViewModel.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/17.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var diaries: [Diary] = [] {
        didSet {
            updateDiaries()
        }
    }
    @Published var hintText: String = "快去填寫情緒日記吧"
    
    var firebaseManager = FirebaseManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        // binding diaries
        firebaseManager.$diaries
            .receive(on: DispatchQueue.main)
            .assign(to: \.diaries, on: self)
            .store(in: &cancellables)
        
        // listen to UserName update
        NotificationCenter.default.publisher(for: NSNotification.Name("UserNameUpdated"))
            .compactMap { $0.userInfo?["userName"] as? String }
            .sink { [weak self] newUserName in
                self?.userName = newUserName
            }
            .store(in: &cancellables)
    }
    
    func updateDiaries() {
        if diaries.isEmpty {
            hintText = "快去填寫情緒日記吧"
        } else {
            hintText = ""
        }
    }
    
    func loadUserName() {
        userName = UserDefaults.standard.string(forKey: "username") ?? ""
    }
    
    func listenForUpdates() {
        firebaseManager.listenForUpdate()
    }
    
    func getMostCommonEmotion() -> String? {
        return diaries.first?.emotion
    }
}
