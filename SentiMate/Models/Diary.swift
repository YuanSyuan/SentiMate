//
//  Diary.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/12.
//
import UIKit
import FirebaseFirestore

struct Diary: Codable, Equatable {
    var documentID: String
    var emotion: String
    var content: String
    var customTime: String
    var category: Int
    var userID: String
}

let buttonTitles = ["工作", "學習", "感情", "社會", "家庭", "人際", "健康", "文化", "娛樂", "休閒", "生活", "個人目標"]
