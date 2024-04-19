//
//  AIResponse.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/18.
//

import Foundation

struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let role: String
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
