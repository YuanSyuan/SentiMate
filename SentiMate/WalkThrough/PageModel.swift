//
//  PageModel.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/28.
//

import Foundation

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var imageUrl: String?
    var tag: Int
    
    static var samplePage = Page(name: "Title Example", description: "This is a sample description for the purpose of debugging", imageUrl: "testImage", tag: 0)
    
    static var samplePages: [Page] = [
        Page(name: "陪伴你更了解自己", description: "歡迎使用 SentiMate — 您的心靈夥伴。", tag: 0),
        Page(name: "情緒識別", description: "AR 捕捉您的表情\n並使用 AI 辨識今日的情緒", imageUrl: "ARemotion2", tag: 1),
        Page(name: "情緒音樂庫", description: "SentiMate 將依照每日情緒推薦歌單\n陪你一起聆聽、理解和接受這些情緒", imageUrl: "aiplayer", tag: 2),
        Page(name: "情緒洞察", description: "追蹤您的情緒變化\n透過數據分析讓您更簡單的定期回顧", imageUrl: "piechart-3", tag: 3),
        Page(name: "AI 諮商室", description: "使用最新 OpenAI 模型\n分析您的情緒日記", imageUrl: "AIrobot", tag: 4),
        
        Page(name: "在開始之前...", description: "", tag: 5)
    ]
}

extension Page {
    func styledDescription() -> AttributedString {
        let lines = self.description.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    
        var finalAttributedString = AttributedString()
        
        for line in lines {
            var attributedLine = AttributedString(line)
            
            if let range = attributedLine.range(of: "SentiMate") {
                attributedLine[range].foregroundColor = midOrange
            }
            
            if let range = attributedLine.range(of: "AI") {
                attributedLine[range].foregroundColor = midOrange
            }
            
            if let range = attributedLine.range(of: "AR") {
                attributedLine[range].foregroundColor = midOrange
            }
            
            if let range = attributedLine.range(of: "數據分析") {
                attributedLine[range].foregroundColor = midOrange
            }
            
            if let range = attributedLine.range(of: "OpenAI") {
                attributedLine[range].foregroundColor = midOrange
            }

            finalAttributedString.append(attributedLine)
            
            if line != lines.last {
                finalAttributedString.append(AttributedString("\n"))
            }
        }
        
        return finalAttributedString
    }
}
