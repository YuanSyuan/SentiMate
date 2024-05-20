//
//  OpenAIManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/18.
//

import Foundation
import Alamofire

class OpenAIManager {
    static let shared = OpenAIManager()
    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist["OPENAI_API_KEY"] as? String else {
            fatalError("Couldn't find key 'OPENAI_API_KEY' in 'APIKey.plist'.")
        }
        return value
    }
    
    private let apiURL = "https://api.openai.com/v1/chat/completions"
    
    private init() {}
    
    func analyzeDiaryEntry(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let headers: HTTPHeaders = [
            .authorization(bearerToken: apiKey),
            .contentType("application/json")
        ]
        
        let parameters: [String: Any] = [
            "model": "gpt-4-turbo",
            "messages": [
                ["role": "system",
                 "content": """
                                     你是一名心理諮詢師，正在分析一個人的情緒日記。請用繁體中文總結這篇日記，滿足以下要求：
                                     1. 提供簡潔的改進建議。
                                     2. 回應不超過200個字。
                                     3. 將回應分為三段：
                                         a. 大方向統整。
                                         b. 提供具體建議。
                                         c. 給出結論。
                                     4. 以句號結束回應。
                                     """],
                ["role": "user",
                 "content": "\(prompt), category的值是\(buttonTitles)的索引" ]
            ],
            "max_tokens": 400
        ]
        
        AF.request(apiURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }
                do {
                    let result = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                    if let text = result.choices.first?.message.content {
                        completion(.success(text))
                    } else {
                        
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            case .failure(let error):
                print("Networking error: \(error.localizedDescription)")
            }
        }
        
    }
}
